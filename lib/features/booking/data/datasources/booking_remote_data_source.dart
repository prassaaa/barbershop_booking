import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/models/booking_model.dart';
import '../../../../shared/models/service_model.dart';
import '../../../../shared/models/barber_model.dart';

abstract class BookingRemoteDataSource {
  Future<List<ServiceModel>> getServices();
  Future<ServiceModel> getServiceById(String id);
  Future<List<BarberModel>> getAvailableBarbers();
  Future<List<BarberModel>> getBarbersByService(String serviceId);
  Future<BarberModel> getBarberById(String id);
  Future<List<String>> getAvailableTimeSlots({
    required String barberId,
    required DateTime date,
    required int serviceDuration,
  });
  Future<BookingModel> createBooking(BookingModel booking);
  Future<List<BookingModel>> getCustomerBookings(String customerId);
  Future<BookingModel> getBookingById(String id);
  Future<BookingModel> updateBooking(BookingModel booking);
  Future<void> cancelBooking(String bookingId, String reason);
  Stream<List<BookingModel>> getCustomerBookingsStream(String customerId);
  Stream<BookingModel> getBookingStream(String bookingId);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final FirebaseFirestore firestore;
  
  BookingRemoteDataSourceImpl({required this.firestore});
  
  @override
  Future<List<ServiceModel>> getServices() async {
    try {
      final snapshot = await firestore
          .collection(AppConstants.servicesCollection)
          .where('isActive', isEqualTo: true)
          .orderBy('name')
          .get();
      
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return ServiceModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw ServerException('Failed to fetch services: ${e.toString()}');
    }
  }
  
  @override
  Future<ServiceModel> getServiceById(String id) async {
    try {
      final doc = await firestore
          .collection(AppConstants.servicesCollection)
          .doc(id)
          .get();
      
      if (!doc.exists) {
        throw const ServerException('Service not found');
      }
      
      final data = doc.data()!;
      data['id'] = doc.id;
      return ServiceModel.fromJson(data);
    } catch (e) {
      throw ServerException('Failed to fetch service: ${e.toString()}');
    }
  }
  
  @override
  Future<List<BarberModel>> getAvailableBarbers() async {
    try {
      final snapshot = await firestore
          .collection(AppConstants.barbersCollection)
          .where('isActive', isEqualTo: true)
          .orderBy('rating', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return BarberModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw ServerException('Failed to fetch barbers: ${e.toString()}');
    }
  }  
  @override
  Future<List<BarberModel>> getBarbersByService(String serviceId) async {
    try {
      final snapshot = await firestore
          .collection(AppConstants.barbersCollection)
          .where('isActive', isEqualTo: true)
          .get();
      
      // Filter barbers who can provide this service
      final barbers = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return BarberModel.fromJson(data);
      }).toList();
      
      // Get service to check availableFor
      final service = await getServiceById(serviceId);
      
      return barbers.where((barber) => 
          service.availableFor.isEmpty || 
          service.availableFor.contains(barber.id)
      ).toList();
    } catch (e) {
      throw ServerException('Failed to fetch barbers for service: ${e.toString()}');
    }
  }
  
  @override
  Future<BarberModel> getBarberById(String id) async {
    try {
      final doc = await firestore
          .collection(AppConstants.barbersCollection)
          .doc(id)
          .get();
      
      if (!doc.exists) {
        throw const ServerException('Barber not found');
      }
      
      final data = doc.data()!;
      data['id'] = doc.id;
      return BarberModel.fromJson(data);
    } catch (e) {
      throw ServerException('Failed to fetch barber: ${e.toString()}');
    }
  }
  
  @override
  Future<List<String>> getAvailableTimeSlots({
    required String barberId,
    required DateTime date,
    required int serviceDuration,
  }) async {
    try {
      // Get barber to check working hours
      final barber = await getBarberById(barberId);
      
      // Get day of week
      final dayNames = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
      final dayName = dayNames[date.weekday - 1];
      
      final shift = barber.getShiftForDay(dayName);
      if (shift == null || !shift.isWorking) {
        return [];
      }
      
      // Generate time slots
      final slots = _generateTimeSlots(
        startTime: shift.startTime!,
        endTime: shift.endTime!,
        duration: serviceDuration,
        breakTimes: shift.breakTimes,
      );
      
      // Get existing bookings for this date
      final existingBookings = await _getBookingsForDate(barberId, date);
      
      // Filter out booked slots
      return slots.where((slot) => 
          !_isSlotBooked(slot, existingBookings, serviceDuration)
      ).toList();
    } catch (e) {
      throw ServerException('Failed to get time slots: ${e.toString()}');
    }
  }
  
  List<String> _generateTimeSlots({
    required String startTime,
    required String endTime,
    required int duration,
    required List<String> breakTimes,
  }) {
    final slots = <String>[];
    final start = _parseTime(startTime);
    final end = _parseTime(endTime);
    
    var current = start;
    while (current.add(Duration(minutes: duration)).isBefore(end) || 
           current.add(Duration(minutes: duration)).isAtSameMomentAs(end)) {
      final timeString = _formatTime(current);
      
      // Check if slot conflicts with break times
      bool isBreak = false;
      for (final breakTime in breakTimes) {
        if (breakTime.contains('-')) {
          final parts = breakTime.split('-');
          final breakStart = _parseTime(parts[0]);
          final breakEnd = _parseTime(parts[1]);
          
          if (current.isBefore(breakEnd) && 
              current.add(Duration(minutes: duration)).isAfter(breakStart)) {
            isBreak = true;
            break;
          }
        }
      }
      
      if (!isBreak) {
        slots.add(timeString);
      }
      
      current = current.add(const Duration(minutes: 30)); // 30-minute intervals
    }
    
    return slots;
  }  
  DateTime _parseTime(String timeString) {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }
  
  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
  
  Future<List<BookingModel>> _getBookingsForDate(String barberId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    
    final snapshot = await firestore
        .collection(AppConstants.bookingsCollection)
        .where('barberId', isEqualTo: barberId)
        .where('bookingDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('bookingDate', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .where('status', whereIn: [AppConstants.bookingWaiting, AppConstants.bookingConfirmed])
        .get();
    
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return BookingModel.fromJson(data);
    }).toList();
  }
  
  bool _isSlotBooked(String slot, List<BookingModel> bookings, int serviceDuration) {
    final slotTime = _parseTime(slot);
    final slotEnd = slotTime.add(Duration(minutes: serviceDuration));
    
    for (final booking in bookings) {
      final bookingTime = _parseTime(booking.timeSlot);
      // Assuming booking duration from service (would need to fetch service)
      final bookingEnd = bookingTime.add(const Duration(minutes: 30)); // Default duration
      
      // Check if slots overlap
      if (slotTime.isBefore(bookingEnd) && slotEnd.isAfter(bookingTime)) {
        return true;
      }
    }
    
    return false;
  }
  
  @override
  Future<BookingModel> createBooking(BookingModel booking) async {
    try {
      final data = booking.toJson();
      data.remove('id');
      data['createdAt'] = FieldValue.serverTimestamp();
      data['updatedAt'] = FieldValue.serverTimestamp();
      
      final docRef = await firestore
          .collection(AppConstants.bookingsCollection)
          .add(data);
      
      final doc = await docRef.get();
      final newData = doc.data()!;
      newData['id'] = doc.id;
      
      return BookingModel.fromJson(newData);
    } catch (e) {
      throw ServerException('Failed to create booking: ${e.toString()}');
    }
  }
  
  @override
  Future<List<BookingModel>> getCustomerBookings(String customerId) async {
    try {
      final snapshot = await firestore
          .collection(AppConstants.bookingsCollection)
          .where('customerId', isEqualTo: customerId)
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return BookingModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw ServerException('Failed to fetch customer bookings: ${e.toString()}');
    }
  }  
  @override
  Future<BookingModel> getBookingById(String id) async {
    try {
      final doc = await firestore
          .collection(AppConstants.bookingsCollection)
          .doc(id)
          .get();
      
      if (!doc.exists) {
        throw const ServerException('Booking not found');
      }
      
      final data = doc.data()!;
      data['id'] = doc.id;
      return BookingModel.fromJson(data);
    } catch (e) {
      throw ServerException('Failed to fetch booking: ${e.toString()}');
    }
  }
  
  @override
  Future<BookingModel> updateBooking(BookingModel booking) async {
    try {
      final data = booking.toJson();
      data.remove('id');
      data['updatedAt'] = FieldValue.serverTimestamp();
      
      await firestore
          .collection(AppConstants.bookingsCollection)
          .doc(booking.id)
          .update(data);
      
      return await getBookingById(booking.id);
    } catch (e) {
      throw ServerException('Failed to update booking: ${e.toString()}');
    }
  }
  
  @override
  Future<void> cancelBooking(String bookingId, String reason) async {
    try {
      await firestore
          .collection(AppConstants.bookingsCollection)
          .doc(bookingId)
          .update({
        'status': AppConstants.bookingCancelled,
        'cancelReason': reason,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw ServerException('Failed to cancel booking: ${e.toString()}');
    }
  }
  
  @override
  Stream<List<BookingModel>> getCustomerBookingsStream(String customerId) {
    return firestore
        .collection(AppConstants.bookingsCollection)
        .where('customerId', isEqualTo: customerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return BookingModel.fromJson(data);
            }).toList());
  }
  
  @override
  Stream<BookingModel> getBookingStream(String bookingId) {
    return firestore
        .collection(AppConstants.bookingsCollection)
        .doc(bookingId)
        .snapshots()
        .map((snapshot) {
          if (!snapshot.exists) {
            throw const ServerException('Booking not found');
          }
          final data = snapshot.data()!;
          data['id'] = snapshot.id;
          return BookingModel.fromJson(data);
        });
  }
}