import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/models/user_model.dart';

abstract class AuthRepository {
  // Authentication methods
  Future<Either<Failure, UserModel>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  
  Future<Either<Failure, UserModel>> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  });
  
  Future<Either<Failure, UserModel>> signInWithGoogle();
  
  Future<Either<Failure, void>> signOut();
  
  Future<Either<Failure, void>> sendPasswordResetEmail({
    required String email,
  });
  
  // User management
  Future<Either<Failure, UserModel?>> getCurrentUser();
  
  Future<Either<Failure, UserModel>> updateUserProfile({
    required String userId,
    String? name,
    String? phoneNumber,
    String? photoUrl,
  });
  
  // Stream for auth state changes
  Stream<UserModel?> get authStateChanges;
  
  // Check if user is logged in
  bool get isLoggedIn;
}