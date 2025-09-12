// lib/services/api_exceptions.dart
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class TimeoutException extends ApiException {
  TimeoutException() : super('Request timeout. Please try again.');
}

class NetworkException extends ApiException {
  NetworkException() : super('No internet connection. Please check your network.');
}

class ServerException extends ApiException {
  ServerException({int? statusCode}) 
    : super('Server error occurred. Please try again later.', statusCode: statusCode);
}
