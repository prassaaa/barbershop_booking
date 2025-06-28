import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/models/user_model.dart';
import '../repositories/auth_repository.dart';

class SignInWithEmailAndPassword {
  final AuthRepository repository;
  
  SignInWithEmailAndPassword(this.repository);
  
  Future<Either<Failure, UserModel>> call(SignInParams params) async {
    return await repository.signInWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class SignInParams extends Equatable {
  final String email;
  final String password;
  
  const SignInParams({
    required this.email,
    required this.password,
  });
  
  @override
  List<Object> get props => [email, password];
}

class RegisterWithEmailAndPassword {
  final AuthRepository repository;
  
  RegisterWithEmailAndPassword(this.repository);
  
  Future<Either<Failure, UserModel>> call(RegisterParams params) async {
    return await repository.registerWithEmailAndPassword(
      email: params.email,
      password: params.password,
      name: params.name,
      phoneNumber: params.phoneNumber,
    );
  }
}

class RegisterParams extends Equatable {
  final String email;
  final String password;
  final String name;
  final String? phoneNumber;
  
  const RegisterParams({
    required this.email,
    required this.password,
    required this.name,
    this.phoneNumber,
  });
  
  @override
  List<Object?> get props => [email, password, name, phoneNumber];
}