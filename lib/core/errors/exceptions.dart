// Custom Exceptions
class ServerException implements Exception {
  final String message;
  final String? code;
  
  const ServerException(this.message, {this.code});
  
  @override
  String toString() => 'ServerException: $message';
}

class AuthException implements Exception {
  final String message;
  final String? code;
  
  const AuthException(this.message, {this.code});
  
  @override
  String toString() => 'AuthException: $message';
}

class CacheException implements Exception {
  final String message;
  
  const CacheException(this.message);
  
  @override
  String toString() => 'CacheException: $message';
}

class ValidationException implements Exception {
  final String message;
  final Map<String, String>? errors;
  
  const ValidationException(this.message, {this.errors});
  
  @override
  String toString() => 'ValidationException: $message';
}

class NetworkException implements Exception {
  final String message;
  
  const NetworkException(this.message);
  
  @override
  String toString() => 'NetworkException: $message';
}