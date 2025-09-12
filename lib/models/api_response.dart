// lib/models/api_response.dart
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final String? error;
  final int? statusCode;
  

  ApiResponse._({
    required this.success,
    this.data,
    this.message,
    this.error,
    this.statusCode,
  });

  factory ApiResponse.success(T data, {String? message, int? statusCode}) {
    return ApiResponse._(
      success: true,
      data: data,
      message: message,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error(String error, {int? statusCode}) {
    return ApiResponse._(
      success: false,
      error: error,
      statusCode: statusCode,
    );
  }
}
