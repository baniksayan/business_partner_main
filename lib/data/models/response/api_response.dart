class ApiResponse {
  final String status;
  final String statusCode;
  final dynamic data;
  final String? message;

  ApiResponse({
    required this.status,
    required this.statusCode,
    this.data,
    this.message,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'] ?? '',
      statusCode: json['status_code'] ?? '',
      data: json['data'],
      message: json['message'],
    );
  }

  bool get isSuccess => status == 'success';
}
