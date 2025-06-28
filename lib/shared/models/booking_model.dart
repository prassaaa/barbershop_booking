import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../core/constants/app_constants.dart';

part 'booking_model.g.dart';

@JsonSerializable()
class BookingModel extends Equatable {
  final String id;
  final String customerId;
  final String barberId;
  final String serviceId;
  final DateTime bookingDate;
  final String timeSlot; // Format: "10:00"
  final String status;
  final double totalPrice;
  final String? notes;
  final String? cancelReason;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const BookingModel({
    required this.id,
    required this.customerId,
    required this.barberId,
    required this.serviceId,
    required this.bookingDate,
    required this.timeSlot,
    required this.status,
    required this.totalPrice,
    this.notes,
    this.cancelReason,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory BookingModel.fromJson(Map<String, dynamic> json) => 
      _$BookingModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$BookingModelToJson(this);
  
  BookingModel copyWith({
    String? id,
    String? customerId,
    String? barberId,
    String? serviceId,
    DateTime? bookingDate,
    String? timeSlot,
    String? status,
    double? totalPrice,
    String? notes,
    String? cancelReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BookingModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      barberId: barberId ?? this.barberId,
      serviceId: serviceId ?? this.serviceId,
      bookingDate: bookingDate ?? this.bookingDate,
      timeSlot: timeSlot ?? this.timeSlot,
      status: status ?? this.status,
      totalPrice: totalPrice ?? this.totalPrice,
      notes: notes ?? this.notes,
      cancelReason: cancelReason ?? this.cancelReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }  
  // Status getters
  bool get isWaiting => status == AppConstants.bookingWaiting;
  bool get isConfirmed => status == AppConstants.bookingConfirmed;
  bool get isCompleted => status == AppConstants.bookingCompleted;
  bool get isCancelled => status == AppConstants.bookingCancelled;
  
  // Date/Time helpers
  DateTime get fullDateTime {
    final timeParts = timeSlot.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    
    return DateTime(
      bookingDate.year,
      bookingDate.month,
      bookingDate.day,
      hour,
      minute,
    );
  }
  
  String get formattedPrice => 'Rp ${totalPrice.toStringAsFixed(0)}';
  
  bool get canBeCancelled {
    if (isCancelled || isCompleted) return false;
    
    // Can cancel if booking is at least 1 hour away
    final now = DateTime.now();
    final bookingTime = fullDateTime;
    return bookingTime.difference(now).inHours >= 1;
  }
  
  bool get isUpcoming {
    final now = DateTime.now();
    final bookingTime = fullDateTime;
    return bookingTime.isAfter(now) && (isWaiting || isConfirmed);
  }
  
  @override
  List<Object?> get props => [
        id,
        customerId,
        barberId,
        serviceId,
        bookingDate,
        timeSlot,
        status,
        totalPrice,
        notes,
        cancelReason,
        createdAt,
        updatedAt,
      ];
}