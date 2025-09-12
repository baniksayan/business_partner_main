// lib/services/auth_api_service.dart
import 'dart:convert';
import 'dart:io';
import 'dart:async'; // Add this import for TimeoutException
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/api_response.dart';

class AuthApiService {
  static const int timeoutDuration = 30;

  /// **AUTHENTICATION METHODS**
  
  // Send OTP method
  static Future<ApiResponse<Map<String, dynamic>>> sendOtp(String emailOrPhone) async {
    try {
      final uri = Uri.parse(ApiConfig.sendOtpUrl);
      
      final response = await http.post(
        uri,
        headers: ApiConfig.defaultHeaders,
        body: jsonEncode({'email': emailOrPhone}),
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } on TimeoutException {
      return ApiResponse.error('Request timeout. Please try again.');
    } on SocketException {
      return ApiResponse.error('No internet connection.');
    } catch (e) {
      return ApiResponse.error('Failed to send OTP: ${e.toString()}');
    }
  }

  // Verify OTP method
  static Future<ApiResponse<Map<String, dynamic>>> verifyOtp(String emailOrPhone, String otp) async {
    try {
      final uri = Uri.parse(ApiConfig.verifyOtpUrl);
      
      final response = await http.post(
        uri,
        headers: ApiConfig.defaultHeaders,
        body: jsonEncode({
          'email': emailOrPhone,
          'otp': otp,
        }),
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } on TimeoutException {
      return ApiResponse.error('Request timeout. Please try again.');
    } on SocketException {
      return ApiResponse.error('No internet connection.');
    } catch (e) {
      return ApiResponse.error('Failed to verify OTP: ${e.toString()}');
    }
  }

  // Logout method
  static Future<ApiResponse<Map<String, dynamic>>> logout(String token) async {
    try {
      final uri = Uri.parse(ApiConfig.logoutUrl);
      
      final response = await http.post(
        uri,
        headers: ApiConfig.authHeaders(token),
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } on TimeoutException {
      return ApiResponse.error('Request timeout. Please try again.');
    } on SocketException {
      return ApiResponse.error('No internet connection.');
    } catch (e) {
      return ApiResponse.error('Failed to logout: ${e.toString()}');
    }
  }

  // Refresh token method
  static Future<ApiResponse<Map<String, dynamic>>> refreshToken(String refreshToken) async {
    try {
      final uri = Uri.parse(ApiConfig.refreshTokenUrl);
      
      final response = await http.post(
        uri,
        headers: ApiConfig.defaultHeaders,
        body: jsonEncode({'refresh': refreshToken}),
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } on TimeoutException {
      return ApiResponse.error('Request timeout. Please try again.');
    } on SocketException {
      return ApiResponse.error('No internet connection.');
    } catch (e) {
      return ApiResponse.error('Failed to refresh token: ${e.toString()}');
    }
  }

  /// **USER PROFILE METHODS**
  
  // Get user profile
  static Future<ApiResponse<Map<String, dynamic>>> getUserProfile(String token) async {
    try {
      final uri = Uri.parse(ApiConfig.userProfileUrl);
      
      final response = await http.get(
        uri,
        headers: ApiConfig.authHeaders(token),
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } on TimeoutException {
      return ApiResponse.error('Request timeout. Please try again.');
    } on SocketException {
      return ApiResponse.error('No internet connection.');
    } catch (e) {
      return ApiResponse.error('Failed to get user profile: ${e.toString()}');
    }
  }

  // Update user profile
  static Future<ApiResponse<Map<String, dynamic>>> updateUserProfile(
    String token,
    Map<String, dynamic> userData,
  ) async {
    try {
      final uri = Uri.parse(ApiConfig.updateUserProfileUrl);
      
      final response = await http.put(
        uri,
        headers: ApiConfig.authHeaders(token),
        body: jsonEncode(userData),
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } on TimeoutException {
      return ApiResponse.error('Request timeout. Please try again.');
    } on SocketException {
      return ApiResponse.error('No internet connection.');
    } catch (e) {
      return ApiResponse.error('Failed to update profile: ${e.toString()}');
    }
  }

  // Upload profile image
  static Future<ApiResponse<Map<String, dynamic>>> uploadProfileImage(
    String token,
    File imageFile,
  ) async {
    try {
      final uri = Uri.parse(ApiConfig.uploadProfileImageUrl);
      
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll(ApiConfig.authHeaders(token));
      
      // Remove Content-Type header as it will be set automatically for multipart
      request.headers.remove('Content-Type');
      
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      final streamedResponse = await request.send()
          .timeout(Duration(seconds: timeoutDuration * 2)); // Longer timeout for file upload
      
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } on TimeoutException {
      return ApiResponse.error('Upload timeout. Please try again.');
    } on SocketException {
      return ApiResponse.error('No internet connection.');
    } catch (e) {
      return ApiResponse.error('Failed to upload image: ${e.toString()}');
    }
  }

  /// **BUSINESS PARTNER SPECIFIC METHODS**
  
  // Get business partner stores
  static Future<ApiResponse<Map<String, dynamic>>> getBusinessPartnerStores(String token) async {
    try {
      final uri = Uri.parse(ApiConfig.businessPartnerStoresUrl);
      
      final response = await http.get(
        uri,
        headers: ApiConfig.authHeaders(token),
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } on TimeoutException {
      return ApiResponse.error('Request timeout. Please try again.');
    } on SocketException {
      return ApiResponse.error('No internet connection.');
    } catch (e) {
      return ApiResponse.error('Failed to get stores: ${e.toString()}');
    }
  }

  // Get store by ID
  static Future<ApiResponse<Map<String, dynamic>>> getStoreById(String token, String storeId) async {
    try {
      final uri = Uri.parse('${ApiConfig.businessPartnerStoresUrl}$storeId/');
      
      final response = await http.get(
        uri,
        headers: ApiConfig.authHeaders(token),
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } on TimeoutException {
      return ApiResponse.error('Request timeout. Please try again.');
    } on SocketException {
      return ApiResponse.error('No internet connection.');
    } catch (e) {
      return ApiResponse.error('Failed to get store: ${e.toString()}');
    }
  }

  // Create new store
  static Future<ApiResponse<Map<String, dynamic>>> createStore(
    String token,
    Map<String, dynamic> storeData,
  ) async {
    try {
      final uri = Uri.parse(ApiConfig.businessPartnerStoresUrl);
      
      final response = await http.post(
        uri,
        headers: ApiConfig.authHeaders(token),
        body: jsonEncode(storeData),
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } on TimeoutException {
      return ApiResponse.error('Request timeout. Please try again.');
    } on SocketException {
      return ApiResponse.error('No internet connection.');
    } catch (e) {
      return ApiResponse.error('Failed to create store: ${e.toString()}');
    }
  }

  // Update store
  static Future<ApiResponse<Map<String, dynamic>>> updateStore(
    String token,
    String storeId,
    Map<String, dynamic> storeData,
  ) async {
    try {
      final uri = Uri.parse('${ApiConfig.businessPartnerStoresUrl}$storeId/');
      
      final response = await http.put(
        uri,
        headers: ApiConfig.authHeaders(token),
        body: jsonEncode(storeData),
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } on TimeoutException {
      return ApiResponse.error('Request timeout. Please try again.');
    } on SocketException {
      return ApiResponse.error('No internet connection.');
    } catch (e) {
      return ApiResponse.error('Failed to update store: ${e.toString()}');
    }
  }

  // Partially update store
  static Future<ApiResponse<Map<String, dynamic>>> partialUpdateStore(
    String token,
    String storeId,
    Map<String, dynamic> storeData,
  ) async {
    try {
      final uri = Uri.parse('${ApiConfig.businessPartnerStoresUrl}$storeId/');
      
      final response = await http.patch(
        uri,
        headers: ApiConfig.authHeaders(token),
        body: jsonEncode(storeData),
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } on TimeoutException {
      return ApiResponse.error('Request timeout. Please try again.');
    } on SocketException {
      return ApiResponse.error('No internet connection.');
    } catch (e) {
      return ApiResponse.error('Failed to update store: ${e.toString()}');
    }
  }

  // Delete store
  static Future<ApiResponse<Map<String, dynamic>>> deleteStore(String token, String storeId) async {
    try {
      final uri = Uri.parse('${ApiConfig.businessPartnerStoresUrl}$storeId/');
      
      final response = await http.delete(
        uri,
        headers: ApiConfig.authHeaders(token),
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } on TimeoutException {
      return ApiResponse.error('Request timeout. Please try again.');
    } on SocketException {
      return ApiResponse.error('No internet connection.');
    } catch (e) {
      return ApiResponse.error('Failed to delete store: ${e.toString()}');
    }
  }

  /// **USER MANAGEMENT METHODS**
  
  // Get users list
  static Future<ApiResponse<Map<String, dynamic>>> getUsersList(String token) async {
    try {
      final uri = Uri.parse(ApiConfig.businessPartnerUsersUrl);
      
      final response = await http.get(
        uri,
        headers: ApiConfig.authHeaders(token),
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } on TimeoutException {
      return ApiResponse.error('Request timeout. Please try again.');
    } on SocketException {
      return ApiResponse.error('No internet connection.');
    } catch (e) {
      return ApiResponse.error('Failed to get users: ${e.toString()}');
    }
  }

  // Create user
  static Future<ApiResponse<Map<String, dynamic>>> createUser(
    String token,
    Map<String, dynamic> userData,
  ) async {
    try {
      final uri = Uri.parse(ApiConfig.businessPartnerUsersUrl);
      
      final response = await http.post(
        uri,
        headers: ApiConfig.authHeaders(token),
        body: jsonEncode(userData),
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } on TimeoutException {
      return ApiResponse.error('Request timeout. Please try again.');
    } on SocketException {
      return ApiResponse.error('No internet connection.');
    } catch (e) {
      return ApiResponse.error('Failed to create user: ${e.toString()}');
    }
  }

  // Get my customers
  static Future<ApiResponse<Map<String, dynamic>>> getMyCustomers(String token) async {
    try {
      final uri = Uri.parse(ApiConfig.businessPartnerMyCustomersUrl);
      
      final response = await http.get(
        uri,
        headers: ApiConfig.authHeaders(token),
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } on TimeoutException {
      return ApiResponse.error('Request timeout. Please try again.');
    } on SocketException {
      return ApiResponse.error('No internet connection.');
    } catch (e) {
      return ApiResponse.error('Failed to get customers: ${e.toString()}');
    }
  }

  // Get user by ID
  static Future<ApiResponse<Map<String, dynamic>>> getUserById(String token, String userId) async {
    try {
      final uri = Uri.parse('${ApiConfig.businessPartnerUsersUrl}$userId/');
      
      final response = await http.get(
        uri,
        headers: ApiConfig.authHeaders(token),
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } on TimeoutException {
      return ApiResponse.error('Request timeout. Please try again.');
    } on SocketException {
      return ApiResponse.error('No internet connection.');
    } catch (e) {
      return ApiResponse.error('Failed to get user: ${e.toString()}');
    }
  }

  // Update user
  static Future<ApiResponse<Map<String, dynamic>>> updateUser(
    String token,
    String userId,
    Map<String, dynamic> userData,
  ) async {
    try {
      final uri = Uri.parse('${ApiConfig.businessPartnerUsersUrl}$userId/');
      
      final response = await http.put(
        uri,
        headers: ApiConfig.authHeaders(token),
        body: jsonEncode(userData),
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } on TimeoutException {
      return ApiResponse.error('Request timeout. Please try again.');
    } on SocketException {
      return ApiResponse.error('No internet connection.');
    } catch (e) {
      return ApiResponse.error('Failed to update user: ${e.toString()}');
    }
  }

  // Partially update user
  static Future<ApiResponse<Map<String, dynamic>>> partialUpdateUser(
    String token,
    String userId,
    Map<String, dynamic> userData,
  ) async {
    try {
      final uri = Uri.parse('${ApiConfig.businessPartnerUsersUrl}$userId/');
      
      final response = await http.patch(
        uri,
        headers: ApiConfig.authHeaders(token),
        body: jsonEncode(userData),
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } on TimeoutException {
      return ApiResponse.error('Request timeout. Please try again.');
    } on SocketException {
      return ApiResponse.error('No internet connection.');
    } catch (e) {
      return ApiResponse.error('Failed to update user: ${e.toString()}');
    }
  }

  // Delete user
  static Future<ApiResponse<Map<String, dynamic>>> deleteUser(String token, String userId) async {
    try {
      final uri = Uri.parse('${ApiConfig.businessPartnerUsersUrl}$userId/');
      
      final response = await http.delete(
        uri,
        headers: ApiConfig.authHeaders(token),
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } on TimeoutException {
      return ApiResponse.error('Request timeout. Please try again.');
    } on SocketException {
      return ApiResponse.error('No internet connection.');
    } catch (e) {
      return ApiResponse.error('Failed to delete user: ${e.toString()}');
    }
  }

  /// **SHOPPING ASSISTANT METHODS**
  
  // Get shopping assistant data (if needed)
  static Future<ApiResponse<Map<String, dynamic>>> getShoppingAssistantData(String token) async {
    try {
      final uri = Uri.parse(ApiConfig.shoppingAssistantUrl);
      
      final response = await http.get(
        uri,
        headers: ApiConfig.authHeaders(token),
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } on TimeoutException {
      return ApiResponse.error('Request timeout. Please try again.');
    } on SocketException {
      return ApiResponse.error('No internet connection.');
    } catch (e) {
      return ApiResponse.error('Failed to get shopping assistant data: ${e.toString()}');
    }
  }

  // Send shopping assistant request
  static Future<ApiResponse<Map<String, dynamic>>> sendShoppingAssistantRequest(
    String token,
    Map<String, dynamic> requestData,
  ) async {
    try {
      final uri = Uri.parse(ApiConfig.shoppingAssistantUrl);
      
      final response = await http.post(
        uri,
        headers: ApiConfig.authHeaders(token),
        body: jsonEncode(requestData),
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } on TimeoutException {
      return ApiResponse.error('Request timeout. Please try again.');
    } on SocketException {
      return ApiResponse.error('No internet connection.');
    } catch (e) {
      return ApiResponse.error('Failed to send request: ${e.toString()}');
    }
  }

  /// **UTILITY METHODS**
  
  // Generic GET request
  static Future<ApiResponse<Map<String, dynamic>>> get(String endpoint, String token) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      
      final response = await http.get(
        uri,
        headers: ApiConfig.authHeaders(token),
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } on TimeoutException {
      return ApiResponse.error('Request timeout. Please try again.');
    } on SocketException {
      return ApiResponse.error('No internet connection.');
    } catch (e) {
      return ApiResponse.error('Request failed: ${e.toString()}');
    }
  }

  // Generic POST request
  static Future<ApiResponse<Map<String, dynamic>>> post(
    String endpoint,
    String token,
    Map<String, dynamic> data,
  ) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      
      final response = await http.post(
        uri,
        headers: ApiConfig.authHeaders(token),
        body: jsonEncode(data),
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } on TimeoutException {
      return ApiResponse.error('Request timeout. Please try again.');
    } on SocketException {
      return ApiResponse.error('No internet connection.');
    } catch (e) {
      return ApiResponse.error('Request failed: ${e.toString()}');
    }
  }

  // Generic PUT request
  static Future<ApiResponse<Map<String, dynamic>>> put(
    String endpoint,
    String token,
    Map<String, dynamic> data,
  ) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      
      final response = await http.put(
        uri,
        headers: ApiConfig.authHeaders(token),
        body: jsonEncode(data),
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } on TimeoutException {
      return ApiResponse.error('Request timeout. Please try again.');
    } on SocketException {
      return ApiResponse.error('No internet connection.');
    } catch (e) {
      return ApiResponse.error('Request failed: ${e.toString()}');
    }
  }

  // Generic PATCH request
  static Future<ApiResponse<Map<String, dynamic>>> patch(
    String endpoint,
    String token,
    Map<String, dynamic> data,
  ) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      
      final response = await http.patch(
        uri,
        headers: ApiConfig.authHeaders(token),
        body: jsonEncode(data),
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } on TimeoutException {
      return ApiResponse.error('Request timeout. Please try again.');
    } on SocketException {
      return ApiResponse.error('No internet connection.');
    } catch (e) {
      return ApiResponse.error('Request failed: ${e.toString()}');
    }
  }

  // Generic DELETE request
  static Future<ApiResponse<Map<String, dynamic>>> delete(String endpoint, String token) async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      
      final response = await http.delete(
        uri,
        headers: ApiConfig.authHeaders(token),
      ).timeout(Duration(seconds: timeoutDuration));

      return _handleResponse(response);
    } on TimeoutException {
      return ApiResponse.error('Request timeout. Please try again.');
    } on SocketException {
      return ApiResponse.error('No internet connection.');
    } catch (e) {
      return ApiResponse.error('Request failed: ${e.toString()}');
    }
  }

  /// **RESPONSE HANDLER**
  
  static ApiResponse<Map<String, dynamic>> _handleResponse(http.Response response) {
    try {
      // Handle empty response body
      if (response.body.isEmpty) {
        switch (response.statusCode) {
          case 200:
          case 201:
          case 204:
            return ApiResponse.success({}, message: 'Success');
          default:
            return ApiResponse.error('Empty response received', statusCode: response.statusCode);
        }
      }

      final Map<String, dynamic> data = jsonDecode(response.body);
      
      switch (response.statusCode) {
        case 200:
        case 201:
        case 204:
          return ApiResponse.success(
            data, 
            message: data['message']?.toString() ?? data['detail']?.toString(),
            statusCode: response.statusCode,
          );
        case 400:
          return ApiResponse.error(
            data['error']?.toString() ?? 
            data['message']?.toString() ?? 
            data['detail']?.toString() ?? 
            'Bad request',
            statusCode: response.statusCode,
          );
        case 401:
          return ApiResponse.error(
            data['error']?.toString() ?? 
            data['message']?.toString() ?? 
            data['detail']?.toString() ?? 
            'Unauthorized - Invalid credentials',
            statusCode: response.statusCode,
          );
        case 403:
          return ApiResponse.error(
            data['error']?.toString() ?? 
            data['message']?.toString() ?? 
            data['detail']?.toString() ?? 
            'Forbidden - Access denied',
            statusCode: response.statusCode,
          );
        case 404:
          return ApiResponse.error(
            data['error']?.toString() ?? 
            data['message']?.toString() ?? 
            data['detail']?.toString() ?? 
            'Resource not found',
            statusCode: response.statusCode,
          );
        case 422:
          return ApiResponse.error(
            data['error']?.toString() ?? 
            data['message']?.toString() ?? 
            data['detail']?.toString() ?? 
            'Validation error',
            statusCode: response.statusCode,
          );
        case 500:
          return ApiResponse.error(
            'Internal server error. Please try again later.',
            statusCode: response.statusCode,
          );
        case 502:
          return ApiResponse.error(
            'Service temporarily unavailable.',
            statusCode: response.statusCode,
          );
        case 503:
          return ApiResponse.error(
            'Service unavailable. Please try again later.',
            statusCode: response.statusCode,
          );
        default:
          return ApiResponse.error(
            data['error']?.toString() ?? 
            data['message']?.toString() ?? 
            data['detail']?.toString() ?? 
            'Unknown error occurred',
            statusCode: response.statusCode,
          );
      }
    } catch (e) {
      return ApiResponse.error(
        'Invalid response format: ${e.toString()}',
        statusCode: response.statusCode,
      );
    }
  }

  /// **DEBUG METHODS**
  
  // Print request details (for debugging)
  static void _logRequest(String method, String url, Map<String, String>? headers, String? body) {
    if (ApiConfig.isDebugMode) {
      print('🌐 API REQUEST: $method $url');
      if (headers != null) {
        print('📋 Headers: $headers');
      }
      if (body != null) {
        print('📦 Body: $body');
      }
    }
  }

  // Print response details (for debugging)
  static void _logResponse(http.Response response) {
    if (ApiConfig.isDebugMode) {
      print('📡 API RESPONSE: ${response.statusCode}');
      print('📄 Body: ${response.body}');
    }
  }
}
