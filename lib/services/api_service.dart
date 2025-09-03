import 'dart:convert';
import 'package:http/http.dart' as http;
import '../data/models/request/login_request.dart';
import '../data/models/response/api_response.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/v1';
  
  static Future<ApiResponse> login(LoginRequest loginRequest) async {
    try {
      final url = Uri.parse('$baseUrl/business-partner/users/login/');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(loginRequest.toJson()),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      final jsonData = json.decode(response.body);
      
      if (response.statusCode == 200) {
        return ApiResponse.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        // Unauthorized - Invalid credentials
        return ApiResponse(
          status: 'error',
          statusCode: 'E-401',
          message: 'Invalid email/phone or password',
        );
      } else if (response.statusCode == 404) {
        // User not found
        return ApiResponse(
          status: 'error',
          statusCode: 'E-404',
          message: 'User not found',
        );
      } else {
        return ApiResponse(
          status: 'error',
          statusCode: 'E-${response.statusCode}',
          message: 'Login failed. Please try again.',
        );
      }
    } catch (e) {
      print('API Error: $e');
      return ApiResponse(
        status: 'error',
        statusCode: 'E-NETWORK',
        message: 'Network error. Please check your connection.',
      );
    }
  }
}
