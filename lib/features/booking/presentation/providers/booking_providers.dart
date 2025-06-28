import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../shared/models/booking_model.dart';
import '../../../../shared/models/service_model.dart';
import '../../../../shared/models/barber_model.dart';
import '../../data/datasources/booking_remote_data_source.dart';
import '../../data/repositories/booking_repository_impl.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../domain/usecases/booking_usecases.dart';
import '../../domain/usecases/service_usecases.dart';

// Data source
final bookingRemoteDataSourceProvider = Provider<BookingRemoteDataSource>((ref) {
  return BookingRemoteDataSourceImpl(
    firestore: FirebaseFirestore.instance,
  );
});

// Repository
final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  return BookingRepositoryImpl(
    remoteDataSource: ref.read(bookingRemoteDataSourceProvider),
  );
});

// Use cases - Services
final getServicesProvider = Provider<GetServices>((ref) {
  return GetServices(ref.read(bookingRepositoryProvider));
});

final getServiceByIdProvider = Provider<GetServiceById>((ref) {
  return GetServiceById(ref.read(bookingRepositoryProvider));
});

final getAvailableBarbersProvider = Provider<GetAvailableBarbers>((ref) {
  return GetAvailableBarbers(ref.read(bookingRepositoryProvider));
});

final getBarbersByServiceProvider = Provider<GetBarbersByService>((ref) {
  return GetBarbersByService(ref.read(bookingRepositoryProvider));
});

final getBarberByIdProvider = Provider<GetBarberById>((ref) {
  return GetBarberById(ref.read(bookingRepositoryProvider));
});

// Use cases - Bookings
final createBookingProvider = Provider<CreateBooking>((ref) {
  return CreateBooking(ref.read(bookingRepositoryProvider));
});

final getCustomerBookingsProvider = Provider<GetCustomerBookings>((ref) {
  return GetCustomerBookings(ref.read(bookingRepositoryProvider));
});

final cancelBookingProvider = Provider<CancelBooking>((ref) {
  return CancelBooking(ref.read(bookingRepositoryProvider));
});

final getAvailableTimeSlotsProvider = Provider<GetAvailableTimeSlots>((ref) {
  return GetAvailableTimeSlots(ref.read(bookingRepositoryProvider));
});

// Stream providers
final customerBookingsStreamProvider = StreamProvider.family<List<BookingModel>, String>((ref, customerId) {
  final repository = ref.read(bookingRepositoryProvider);
  return repository.getCustomerBookingsStream(customerId);
});

final bookingStreamProvider = StreamProvider.family<BookingModel, String>((ref, bookingId) {
  final repository = ref.read(bookingRepositoryProvider);
  return repository.getBookingStream(bookingId);
});

// State providers for services and barbers
final servicesProvider = FutureProvider<List<ServiceModel>>((ref) async {
  final usecase = ref.read(getServicesProvider);
  final result = await usecase();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (services) => services,
  );
});

final availableBarbersProvider = FutureProvider<List<BarberModel>>((ref) async {
  final usecase = ref.read(getAvailableBarbersProvider);
  final result = await usecase();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (barbers) => barbers,
  );
});