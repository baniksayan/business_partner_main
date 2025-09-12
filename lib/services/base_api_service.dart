// lib/services/base_api_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/api_response.dart';
import 'api_exceptions.dart';

class BaseApiService {
  static const int timeoutDuration = 30;

  static Future<ApiResponse<Map<String, dynamic>>> get(
    String endpoint, {
    Map<String, String>? headers,
    String? token,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      
      final response = await http.get(
        uri,
        headers: headers ?? ApiConfig.authHeaders(token),
      ).timeout(
        Duration(seconds: timeoutDuration),
        onTimeout: () => throw TimeoutException(),
      );

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Unexpected error: ${e.toString()}');
    }
  }

  static Future<ApiResponse<Map<String, dynamic>>> post(
    String endpoint,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
    String? token,
  }) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      
      print('POST Request to: $uri'); // Debug log
      print('Request body: ${jsonEncode(body)}'); // Debug log
      
      final response = await http.post(
        uri,
        headers: headers ?? ApiConfig.authHeaders(token),
        body: jsonEncode(body),
      ).timeout(
        Duration(seconds: timeoutDuration),
        onTimeout: () => throw TimeoutException(),
      );

      print('Response status: ${response.statusCode}'); // Debug log
      print('Response body: ${response.body}'); // Debug log

      return _handleResponse(response);
    } on SocketException {
      throw NetworkException();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Unexpected error: ${e.toString()}');
    }
  }

  static ApiResponse<Map<String, dynamic>> _handleResponse(http.Response response) {
    try {
      final Map<String, dynamic> data = jsonDecode(response.body);
      
      switch (response.statusCode) {
        case 200:
        case 201:
          return ApiResponse.success(
            data,
            message: data['message'],
            statusCode: response.statusCode,
          );
        case 400:
          throw ApiException(
            data['error'] ?? data['message'] ?? 'Bad request',
            statusCode: response.statusCode,
          );
        case 401:
          throw ApiException('Invalid credentials', statusCode: response.statusCode);
        case 403:
          throw ApiException('Access forbidden', statusCode: response.statusCode);
        case 404:
          throw ApiException('Service not found', statusCode: response.statusCode);
        case 429:
          throw ApiException('Too many requests. Please try again later.', 
                           statusCode: response.statusCode);
        case 500:
          throw ServerException(statusCode: response.statusCode);
        default:
          throw ApiException(
            data['error'] ?? data['message'] ?? 'Unknown error occurred',
            statusCode: response.statusCode,
          );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Invalid response format');
    }
  }
}
