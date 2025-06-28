import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/models/booking_model.dart';
import '../../../../shared/models/service_model.dart';
import '../../../../shared/models/barber_model.dart';

abstract class BookingRepository {
  // Services
  Future<Either<Failure, List<ServiceModel>>> getServices();
  Future<Either<Failure, ServiceModel>> getServiceById(String id);
  
  // Barbers
  Future<Either<Failure, List<BarberModel>>> getAvailableBarbers();
  Future<Either<Failure, List<BarberModel>>> getBarbersByService(String serviceId);
  Future<Either<Failure, BarberModel>> getBarberById(String id);
  
  // Time slots
  Future<Either<Failure, List<String>>> getAvailableTimeSlots({
    required String barberId,
    required DateTime date,
    required int serviceDuration,
  });
  
  // Bookings
  Future<Either<Failure, BookingModel>> createBooking(BookingModel booking);
  Future<Either<Failure, List<BookingModel>>> getCustomerBookings(String customerId);
  Future<Either<Failure, BookingModel>> getBookingById(String id);
  Future<Either<Failure, BookingModel>> updateBooking(BookingModel booking);
  Future<Either<Failure, void>> cancelBooking(String bookingId, String reason);
  
  // Streams
  Stream<List<BookingModel>> getCustomerBookingsStream(String customerId);
  Stream<BookingModel> getBookingStream(String bookingId);
}