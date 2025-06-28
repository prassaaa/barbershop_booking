import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;
  
  const Failure(this.message, {this.code});
  
  @override
  List<Object?> get props => [message, code];
}

// Auth Failures
class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code});
  
  factory AuthFailure.invalidCredentials() => 
    const AuthFailure('Invalid email or password', code: 'invalid-credentials');
    
  factory AuthFailure.userNotFound() => 
    const AuthFailure('User not found', code: 'user-not-found');
    
  factory AuthFailure.weakPassword() => 
    const AuthFailure('Password is too weak', code: 'weak-password');
    
  factory AuthFailure.emailAlreadyInUse() => 
    const AuthFailure('Email is already in use', code: 'email-already-in-use');
    
  factory AuthFailure.networkError() => 
    const AuthFailure('Network error. Please check your connection', code: 'network-error');
    
  factory AuthFailure.unknown() => 
    const AuthFailure('An unknown error occurred', code: 'unknown');
}

// Server Failures
class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.code});
  
  factory ServerFailure.connectionTimeout() => 
    const ServerFailure('Connection timeout', code: 'connection-timeout');
    
  factory ServerFailure.badRequest() => 
    const ServerFailure('Bad request', code: 'bad-request');
    
  factory ServerFailure.unauthorized() => 
    const ServerFailure('Unauthorized access', code: 'unauthorized');
    
  factory ServerFailure.forbidden() => 
    const ServerFailure('Access forbidden', code: 'forbidden');
    
  factory ServerFailure.notFound() => 
    const ServerFailure('Resource not found', code: 'not-found');
    
  factory ServerFailure.internalError() => 
    const ServerFailure('Internal server error', code: 'internal-error');
}