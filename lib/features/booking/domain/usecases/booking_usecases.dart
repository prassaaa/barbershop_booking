import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/models/booking_model.dart';
import '../repositories/booking_repository.dart';

class CreateBooking {
  final BookingRepository repository;
  
  CreateBooking(this.repository);
  
  Future<Either<Failure, BookingModel>> call(CreateBookingParams params) async {
    return await repository.createBooking(params.booking);
  }
}

class CreateBookingParams extends Equatable {
  final BookingModel booking;
  
  const CreateBookingParams({required this.booking});
  
  @override
  List<Object> get props => [booking];
}

class GetCustomerBookings {
  final BookingRepository repository;
  
  GetCustomerBookings(this.repository);
  
  Future<Either<Failure, List<BookingModel>>> call(String customerId) async {
    return await repository.getCustomerBookings(customerId);
  }
}

class CancelBooking {
  final BookingRepository repository;
  
  CancelBooking(this.repository);
  
  Future<Either<Failure, void>> call(CancelBookingParams params) async {
    return await repository.cancelBooking(params.bookingId, params.reason);
  }
}

class CancelBookingParams extends Equatable {
  final String bookingId;
  final String reason;
  
  const CancelBookingParams({
    required this.bookingId,
    required this.reason,
  });
  
  @override
  List<Object> get props => [bookingId, reason];
}

class GetAvailableTimeSlots {
  final BookingRepository repository;
  
  GetAvailableTimeSlots(this.repository);
  
  Future<Either<Failure, List<String>>> call(TimeSlotParams params) async {
    return await repository.getAvailableTimeSlots(
      barberId: params.barberId,
      date: params.date,
      serviceDuration: params.serviceDuration,
    );
  }
}

class TimeSlotParams extends Equatable {
  final String barberId;
  final DateTime date;
  final int serviceDuration;
  
  const TimeSlotParams({
    required this.barberId,
    required this.date,
    required this.serviceDuration,
  });
  
  @override
  List<Object> get props => [barberId, date, serviceDuration];
}