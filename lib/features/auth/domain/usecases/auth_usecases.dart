import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/models/user_model.dart';
import '../repositories/auth_repository.dart';

class SignInWithGoogle {
  final AuthRepository repository;
  
  SignInWithGoogle(this.repository);
  
  Future<Either<Failure, UserModel>> call() async {
    return await repository.signInWithGoogle();
  }
}

class SignOut {
  final AuthRepository repository;
  
  SignOut(this.repository);
  
  Future<Either<Failure, void>> call() async {
    return await repository.signOut();
  }
}

class GetCurrentUser {
  final AuthRepository repository;
  
  GetCurrentUser(this.repository);
  
  Future<Either<Failure, UserModel?>> call() async {
    return await repository.getCurrentUser();
  }
}

class SendPasswordResetEmail {
  final AuthRepository repository;
  
  SendPasswordResetEmail(this.repository);
  
  Future<Either<Failure, void>> call(String email) async {
    return await repository.sendPasswordResetEmail(email: email);
  }
}