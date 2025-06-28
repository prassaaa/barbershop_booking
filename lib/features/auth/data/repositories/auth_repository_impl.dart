import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  
  AuthRepositoryImpl({required this.remoteDataSource});
  
  @override
  Future<Either<Failure, UserModel>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } catch (e) {
      return Left(AuthFailure.unknown());
    }
  }
  
  @override
  Future<Either<Failure, UserModel>> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    try {
      final user = await remoteDataSource.registerWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
        phoneNumber: phoneNumber,
      );
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } catch (e) {
      return Left(AuthFailure.unknown());
    }
  }
  
  @override
  Future<Either<Failure, UserModel>> signInWithGoogle() async {
    try {
      final user = await remoteDataSource.signInWithGoogle();
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } catch (e) {
      return Left(AuthFailure.unknown());
    }
  }
  
  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } catch (e) {
      return Left(AuthFailure.unknown());
    }
  }  
  @override
  Future<Either<Failure, void>> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await remoteDataSource.sendPasswordResetEmail(email: email);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } catch (e) {
      return Left(AuthFailure.unknown());
    }
  }
  
  @override
  Future<Either<Failure, UserModel?>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } catch (e) {
      return Left(AuthFailure.unknown());
    }
  }
  
  @override
  Future<Either<Failure, UserModel>> updateUserProfile({
    required String userId,
    String? name,
    String? phoneNumber,
    String? photoUrl,
  }) async {
    try {
      final user = await remoteDataSource.updateUserProfile(
        userId: userId,
        name: name,
        phoneNumber: phoneNumber,
        photoUrl: photoUrl,
      );
      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } catch (e) {
      return Left(AuthFailure.unknown());
    }
  }
  
  @override
  Stream<UserModel?> get authStateChanges => remoteDataSource.authStateChanges;
  
  @override
  bool get isLoggedIn => remoteDataSource.isLoggedIn;
}