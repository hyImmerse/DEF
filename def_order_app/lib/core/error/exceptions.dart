class ServerException implements Exception {
  final String message;
  final String? code;
  
  ServerException({required this.message, this.code});
}

class CacheException implements Exception {
  final String message;
  
  CacheException({required this.message});
}

class NetworkException implements Exception {
  final String message;
  
  NetworkException({required this.message});
}

class AppAuthException implements Exception {
  final String message;
  final String? code;
  
  AppAuthException({required this.message, this.code});
}

class ValidationException implements Exception {
  final String message;
  final String? code;
  final Map<String, String>? errors;
  
  ValidationException({required this.message, this.code, this.errors});
}

class BusinessRuleException implements Exception {
  final String message;
  final String? code;
  
  BusinessRuleException({required this.message, this.code});
}

class AuthException implements Exception {
  final String message;
  final String? code;
  
  const AuthException(this.message, {this.code});
}