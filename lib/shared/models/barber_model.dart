import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'barber_model.g.dart';

@JsonSerializable()
class BarberModel extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String? photoUrl;
  final String? profileImage; // For backward compatibility
  final String? bio;
  final double rating;
  final int totalReviews;
  final int experienceYears;
  final bool isActive;
  final bool isAvailable;
  final Map<String, BarberShift> weeklyShifts;
  final List<String> specialties;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const BarberModel({
    required this.id,
    required this.userId,
    required this.name,
    this.photoUrl,
    this.profileImage,
    this.bio,
    required this.rating,
    required this.totalReviews,
    this.experienceYears = 0,
    required this.isActive,
    this.isAvailable = true,
    required this.weeklyShifts,
    required this.specialties,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory BarberModel.fromJson(Map<String, dynamic> json) => 
      _$BarberModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$BarberModelToJson(this);
  
  BarberModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? photoUrl,
    String? profileImage,
    String? bio,
    double? rating,
    int? totalReviews,
    int? experienceYears,
    bool? isActive,
    bool? isAvailable,
    Map<String, BarberShift>? weeklyShifts,
    List<String>? specialties,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BarberModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      profileImage: profileImage ?? this.profileImage,
      bio: bio ?? this.bio,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      experienceYears: experienceYears ?? this.experienceYears,
      isActive: isActive ?? this.isActive,
      isAvailable: isAvailable ?? this.isAvailable,
      weeklyShifts: weeklyShifts ?? this.weeklyShifts,
      specialties: specialties ?? this.specialties,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }  
  bool isAvailableOnDay(String day) {
    return weeklyShifts.containsKey(day) && 
           weeklyShifts[day]!.isWorking;
  }
  
  BarberShift? getShiftForDay(String day) {
    return weeklyShifts[day];
  }
  
  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        photoUrl,
        profileImage,
        bio,
        rating,
        totalReviews,
        experienceYears,
        isActive,
        isAvailable,
        weeklyShifts,
        specialties,
        createdAt,
        updatedAt,
      ];
}

@JsonSerializable()
class BarberShift extends Equatable {
  final bool isWorking;
  final String? startTime; // Format: "09:00"
  final String? endTime;   // Format: "17:00"
  final List<String> breakTimes; // Format: ["12:00-13:00"]
  
  const BarberShift({
    required this.isWorking,
    this.startTime,
    this.endTime,
    required this.breakTimes,
  });
  
  factory BarberShift.fromJson(Map<String, dynamic> json) => 
      _$BarberShiftFromJson(json);
  
  Map<String, dynamic> toJson() => _$BarberShiftToJson(this);
  
  BarberShift copyWith({
    bool? isWorking,
    String? startTime,
    String? endTime,
    List<String>? breakTimes,
  }) {
    return BarberShift(
      isWorking: isWorking ?? this.isWorking,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      breakTimes: breakTimes ?? this.breakTimes,
    );
  }
  
  @override
  List<Object?> get props => [isWorking, startTime, endTime, breakTimes];
}