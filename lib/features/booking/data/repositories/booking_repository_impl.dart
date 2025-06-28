import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/models/booking_model.dart';
import '../../../../shared/models/service_model.dart';
import '../../../../shared/models/barber_model.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_remote_data_source.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;
  
  BookingRepositoryImpl({required this.remoteDataSource});
  
  @override
  Future<Either<Failure, List<ServiceModel>>> getServices() async {
    try {
      final services = await remoteDataSource.getServices();
      return Right(services);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure.internalError());
    }
  }
  
  @override
  Future<Either<Failure, ServiceModel>> getServiceById(String id) async {
    try {
      final service = await remoteDataSource.getServiceById(id);
      return Right(service);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure.internalError());
    }
  }
  
  @override
  Future<Either<Failure, List<BarberModel>>> getAvailableBarbers() async {
    try {
      final barbers = await remoteDataSource.getAvailableBarbers();
      return Right(barbers);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure.internalError());
    }
  }
  
  @override
  Future<Either<Failure, List<BarberModel>>> getBarbersByService(String serviceId) async {
    try {
      final barbers = await remoteDataSource.getBarbersByService(serviceId);
      return Right(barbers);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure.internalError());
    }
  }
  
  @override
  Future<Either<Failure, BarberModel>> getBarberById(String id) async {
    try {
      final barber = await remoteDataSource.getBarberById(id);
      return Right(barber);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure.internalError());
    }
  }
  
  @override
  Future<Either<Failure, List<String>>> getAvailableTimeSlots({
    required String barberId,
    required DateTime date,
    required int serviceDuration,
  }) async {
    try {
      final timeSlots = await remoteDataSource.getAvailableTimeSlots(
        barberId: barberId,
        date: date,
        serviceDuration: serviceDuration,
      );
      return Right(timeSlots);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure.internalError());
    }
  }  
  @override
  Future<Either<Failure, BookingModel>> createBooking(BookingModel booking) async {
    try {
      final newBooking = await remoteDataSource.createBooking(booking);
      return Right(newBooking);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure.internalError());
    }
  }
  
  @override
  Future<Either<Failure, List<BookingModel>>> getCustomerBookings(String customerId) async {
    try {
      final bookings = await remoteDataSource.getCustomerBookings(customerId);
      return Right(bookings);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure.internalError());
    }
  }
  
  @override
  Future<Either<Failure, BookingModel>> getBookingById(String id) async {
    try {
      final booking = await remoteDataSource.getBookingById(id);
      return Right(booking);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure.internalError());
    }
  }
  
  @override
  Future<Either<Failure, BookingModel>> updateBooking(BookingModel booking) async {
    try {
      final updatedBooking = await remoteDataSource.updateBooking(booking);
      return Right(updatedBooking);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure.internalError());
    }
  }
  
  @override
  Future<Either<Failure, void>> cancelBooking(String bookingId, String reason) async {
    try {
      await remoteDataSource.cancelBooking(bookingId, reason);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure.internalError());
    }
  }
  
  @override
  Stream<List<BookingModel>> getCustomerBookingsStream(String customerId) {
    return remoteDataSource.getCustomerBookingsStream(customerId);
  }
  
  @override
  Stream<BookingModel> getBookingStream(String bookingId) {
    return remoteDataSource.getBookingStream(bookingId);
  }
}