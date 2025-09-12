// lib/services/user_api_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/api_response.dart';

class UserApiService {
  static const String baseUrl = 'http://127.0.0.1:8000'; // Your API base URL

  // **UPDATE USER PROFILE - Uses your PUT /api/v1/business-partner/users/{id} endpoint**
  static Future<ApiResponse> updateUserProfile({
    required String userId,
    required Map<String, dynamic> userData,
    required String token,
    File? profileImage,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/api/v1/business-partner/users/$userId');
      
      // Create multipart request for image upload
      final request = http.MultipartRequest('PUT', url);
      
      // Add authorization header
      request.headers['Authorization'] = 'Bearer $token';
      
      // Add user data fields
      userData.forEach((key, value) {
        request.fields[key] = value.toString();
      });
      
      // Add profile image if selected
      if (profileImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image_url',
            profileImage.path,
          ),
        );
      }
      
      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return ApiResponse.success(responseData['data']);
      } else {
        return ApiResponse.error(responseData['message'] ?? 'Update failed');
      }
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }

  // **GET USER DETAILS - Uses your GET /api/v1/business-partner/users/{id} endpoint**
  static Future<ApiResponse> getUserDetails({
    required String userId,
    required String token,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/business-partner/users/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      
      final responseData = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return ApiResponse.success(responseData['data']);
      } else {
        return ApiResponse.error(responseData['message'] ?? 'Failed to get user details');
      }
    } catch (e) {
      return ApiResponse.error('Network error: ${e.toString()}');
    }
  }
} 