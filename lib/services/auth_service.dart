// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'token_helper.dart';

class AuthService {
  // Send OTP
  static Future<Map<String, dynamic>> sendOtp(String phoneNumber) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.sendOtpUrl),
        headers: ApiConfig.defaultHeaders,
        body: json.encode({'phone_number': phoneNumber}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to send OTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Verify OTP and save tokens
  static Future<Map<String, dynamic>> verifyOtp(String phoneNumber, String otp) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.verifyOtpUrl),
        headers: ApiConfig.defaultHeaders,
        body: json.encode({
          'phone_number': phoneNumber,
          'otp': otp,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        // Save tokens after successful verification
        if (responseData['success'] == true && responseData['data'] != null) {
          final data = responseData['data'];
          await TokenHelper.saveAuthData(
            token: data['access_token'] ?? data['token'],
            refreshToken: data['refresh_token'],
            email: data['email'] ?? data['user']['email'],
          );
        }
        
        return responseData;
      } else {
        throw Exception('Failed to verify OTP: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Logout
  static Future<void> logout() async {
    try {
      final token = await TokenHelper.getToken();
      if (token != null) {
        await http.post(
          Uri.parse(ApiConfig.logoutUrl),
          headers: ApiConfig.authHeaders(token),
        );
      }
    } catch (e) {
      // Continue with logout even if API call fails
    } finally {
      await TokenHelper.clearAllTokens();
    }
  }
}
