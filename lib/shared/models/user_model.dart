import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../core/constants/app_constants.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? phoneNumber;
  final String? photoUrl;
  final String role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.phoneNumber,
    this.photoUrl,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory UserModel.fromJson(Map<String, dynamic> json) => 
      _$UserModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
  
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phoneNumber,
    String? photoUrl,
    String? role,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  bool get isCustomer => role == AppConstants.roleCustomer;
  bool get isBarber => role == AppConstants.roleBarber;
  bool get isAdmin => role == AppConstants.roleAdmin;
  bool get isSuperAdmin => role == AppConstants.roleSuperAdmin;
  
  @override
  List<Object?> get props => [
        id,
        email,
        name,
        phoneNumber,
        photoUrl,
        role,
        isActive,
        createdAt,
        updatedAt,
      ];
}