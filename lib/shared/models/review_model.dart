import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'review_model.g.dart';

@JsonSerializable()
class ReviewModel extends Equatable {
  final String id;
  final String bookingId;
  final String customerId;
  final String barberId;
  final String serviceId;
  final double rating;
  final String? comment;
  final List<String> photos;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const ReviewModel({
    required this.id,
    required this.bookingId,
    required this.customerId,
    required this.barberId,
    required this.serviceId,
    required this.rating,
    this.comment,
    required this.photos,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory ReviewModel.fromJson(Map<String, dynamic> json) => 
      _$ReviewModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);
  
  ReviewModel copyWith({
    String? id,
    String? bookingId,
    String? customerId,
    String? barberId,
    String? serviceId,
    double? rating,
    String? comment,
    List<String>? photos,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      customerId: customerId ?? this.customerId,
      barberId: barberId ?? this.barberId,
      serviceId: serviceId ?? this.serviceId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      photos: photos ?? this.photos,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  String get ratingText {
    if (rating >= 4.5) return 'Excellent';
    if (rating >= 4.0) return 'Very Good';
    if (rating >= 3.5) return 'Good';
    if (rating >= 3.0) return 'Average';
    if (rating >= 2.0) return 'Poor';
    return 'Very Poor';
  }
  
  @override
  List<Object?> get props => [
        id,
        bookingId,
        customerId,
        barberId,
        serviceId,
        rating,
        comment,
        photos,
        createdAt,
        updatedAt,
      ];
}