// lib/services/customer_api_service.dart - ENHANCED ERROR HANDLING
import 'package:dio/dio.dart';
import '../models/api_response.dart';

class CustomerApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/v1/business-partner';
  
  // ✅ FIXED: Enhanced customer details with better error handling
  static Future<ApiResponse> getCustomerDetails(String token, String customerId) async {
    print('👤 [CustomerAPI] Getting customer details: $customerId');
    print('🔗 [CustomerAPI] URL: $baseUrl/users/$customerId/');
    
    try {
      final dio = Dio();
      
      // Add debugging interceptor
      dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          print('📤 [CustomerAPI] Request: ${options.method} ${options.path}');
          print('📤 [CustomerAPI] Headers: ${options.headers}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          print('📥 [CustomerAPI] Response: ${response.statusCode}');
          handler.next(response);
        },
        onError: (error, handler) {
          print('❌ [CustomerAPI] Error: ${error.response?.statusCode} - ${error.message}');
          handler.next(error);
        },
      ));
      
      // Get customer basic info with enhanced error handling
      final customerResponse = await dio.get(
        '$baseUrl/users/$customerId/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) {
            // Accept all status codes to handle them manually
            return status != null && status < 500;
          },
        ),
      );

      print('📥 [CustomerAPI] Customer response status: ${customerResponse.statusCode}');
      
      if (customerResponse.statusCode == 200) {
        final customerData = customerResponse.data['data'] ?? customerResponse.data;
        print('✅ [CustomerAPI] Customer data retrieved successfully');
        
        // Try to get customer's bookings (optional)
        try {
          final bookingsResponse = await dio.get(
            '$baseUrl/bookings/?user_id=$customerId',
            options: Options(
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
              },
              validateStatus: (status) => status != null && status < 500,
            ),
          );
          
          if (bookingsResponse.statusCode == 200) {
            final bookingsData = bookingsResponse.data['data'] ?? bookingsResponse.data ?? [];
            customerData['bookings'] = bookingsData;
            print('📅 [CustomerAPI] Found ${bookingsData.length} bookings for customer');
          } else {
            print('⚠️ [CustomerAPI] Bookings API returned: ${bookingsResponse.statusCode}');
            customerData['bookings'] = [];
          }
        } catch (e) {
          print('⚠️ [CustomerAPI] Could not fetch bookings: $e');
          customerData['bookings'] = [];
        }
        
        return ApiResponse.success(customerData);
      } else if (customerResponse.statusCode == 404) {
        print('🔍 [CustomerAPI] Customer not found (404)');
        return ApiResponse.error('Customer not found. This customer may have been deleted or the ID is incorrect.');
      } else if (customerResponse.statusCode == 401) {
        print('🔐 [CustomerAPI] Unauthorized (401)');
        return ApiResponse.error('Authentication failed. Please login again.');
      } else if (customerResponse.statusCode == 403) {
        print('🚫 [CustomerAPI] Forbidden (403)');
        return ApiResponse.error('Access denied. You don\'t have permission to view this customer.');
      } else {
        print('⚠️ [CustomerAPI] Unexpected status: ${customerResponse.statusCode}');
        return ApiResponse.error('Failed to load customer details. Server returned ${customerResponse.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ [CustomerAPI] DioException: ${e.type}');
      
      if (e.type == DioExceptionType.connectionTimeout) {
        return ApiResponse.error('Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.connectionError) {
        return ApiResponse.error('Cannot connect to server. Please check if the server is running.');
      } else if (e.response?.statusCode == 404) {
        return ApiResponse.error('Customer not found. This customer may no longer exist.');
      } else if (e.response?.statusCode == 401) {
        return ApiResponse.error('Authentication expired. Please login again.');
      } else {
        return ApiResponse.error('Network error: ${e.message}');
      }
    } catch (e) {
      print('❌ [CustomerAPI] Unexpected error: $e');
      return ApiResponse.error('Unexpected error occurred: $e');
    }
  }

  // ✅ ENHANCED: Get all customers with better error handling
  static Future<ApiResponse> getAllCustomers(String token) async {
    print('👥 [CustomerAPI] Getting all users (customers)...');
    print('🔗 [CustomerAPI] URL: $baseUrl/users/');
    
    try {
      final dio = Dio();
      
      dio.options.connectTimeout = const Duration(seconds: 10);
      dio.options.receiveTimeout = const Duration(seconds: 10);
      
      final response = await dio.get(
        '$baseUrl/users/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      print('📥 [CustomerAPI] Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        return ApiResponse.success(response.data);
      } else if (response.statusCode == 401) {
        return ApiResponse.error('Authentication expired. Please login again.');
      } else {
        return ApiResponse.error('Failed to load customers: HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('❌ [CustomerAPI] Error: $e');
      return ApiResponse.error('Network error: $e');
    }
  }
}
