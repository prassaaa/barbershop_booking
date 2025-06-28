import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'service_model.g.dart';

@JsonSerializable()
class ServiceModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final int durationMinutes;
  final String category;
  final String? imageUrl;
  final bool isActive;
  final List<String> availableFor; // barber IDs
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationMinutes,
    required this.category,
    this.imageUrl,
    required this.isActive,
    required this.availableFor,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory ServiceModel.fromJson(Map<String, dynamic> json) => 
      _$ServiceModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$ServiceModelToJson(this);
  
  ServiceModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    int? durationMinutes,
    String? category,
    String? imageUrl,
    bool? isActive,
    List<String>? availableFor,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      availableFor: availableFor ?? this.availableFor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }  
  String get formattedPrice => 'Rp ${price.toStringAsFixed(0)}';
  
  String get formattedDuration {
    if (durationMinutes < 60) {
      return '${durationMinutes}m';
    } else {
      final hours = durationMinutes ~/ 60;
      final minutes = durationMinutes % 60;
      if (minutes == 0) {
        return '${hours}h';
      } else {
        return '${hours}h ${minutes}m';
      }
    }
  }
  
  bool isAvailableForBarber(String barberId) {
    return availableFor.isEmpty || availableFor.contains(barberId);
  }
  
  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        durationMinutes,
        category,
        imageUrl,
        isActive,
        availableFor,
        createdAt,
        updatedAt,
      ];
}