// lib/services/booking_api_service.dart
import 'package:dio/dio.dart';
import '../models/api_response.dart';

class BookingApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/v1/business-partner';
  
  // Get all bookings
  static Future<ApiResponse> getAllBookings(String token) async {
    print('📅 [BookingAPI] Getting all bookings...');
    
    try {
      final dio = Dio();
      final response = await dio.get(
        '$baseUrl/service-bookings/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      print('📥 [BookingAPI] Bookings response: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        return ApiResponse.success(response.data);
      } else {
        return ApiResponse.error('Failed to load bookings');
      }
    } catch (e) {
      print('❌ [BookingAPI] Error getting bookings: $e');
      return ApiResponse.error('Network error: $e');
    }
  }

  // Get booking by ID
  static Future<ApiResponse> getBookingById(String token, String bookingId) async {
    print('📅 [BookingAPI] Getting booking: $bookingId');
    
    try {
      final dio = Dio();
      final response = await dio.get(
        '$baseUrl/service-bookings/$bookingId/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      print('📥 [BookingAPI] Booking response: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        return ApiResponse.success(response.data);
      } else {
        return ApiResponse.error('Booking not found');
      }
    } catch (e) {
      print('❌ [BookingAPI] Error getting booking: $e');
      return ApiResponse.error('Network error: $e');
    }
  }

  // Create new booking
  static Future<ApiResponse> createBooking(String token, Map<String, dynamic> bookingData) async {
    print('📅 [BookingAPI] Creating booking...');
    print('📦 [BookingAPI] Data: $bookingData');
    
    try {
      final dio = Dio();
      final response = await dio.post(
        '$baseUrl/service-bookings/',
        data: bookingData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      print('📥 [BookingAPI] Create response: ${response.statusCode}');
      
      if (response.statusCode == 201) {
        return ApiResponse.success(response.data);
      } else {
        return ApiResponse.error('Failed to create booking');
      }
    } catch (e) {
      print('❌ [BookingAPI] Error creating booking: $e');
      return ApiResponse.error('Network error: $e');
    }
  }

  // Update booking
  static Future<ApiResponse> updateBooking(String token, String bookingId, Map<String, dynamic> bookingData) async {
    print('📅 [BookingAPI] Updating booking: $bookingId');
    
    try {
      final dio = Dio();
      final response = await dio.put(
        '$baseUrl/service-bookings/$bookingId/',
        data: bookingData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      print('📥 [BookingAPI] Update response: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        return ApiResponse.success(response.data);
      } else {
        return ApiResponse.error('Failed to update booking');
      }
    } catch (e) {
      print('❌ [BookingAPI] Error updating booking: $e');
      return ApiResponse.error('Network error: $e');
    }
  }

  // Cancel booking
  static Future<ApiResponse> cancelBooking(String token, String bookingId) async {
    print('📅 [BookingAPI] Cancelling booking: $bookingId');
    
    try {
      final dio = Dio();
      final response = await dio.delete(
        '$baseUrl/service-bookings/$bookingId/',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      print('📥 [BookingAPI] Cancel response: ${response.statusCode}');
      
      if (response.statusCode == 204 || response.statusCode == 200) {
        return ApiResponse.success({'message': 'Booking cancelled successfully'});
      } else {
        return ApiResponse.error('Failed to cancel booking');
      }
    } catch (e) {
      print('❌ [BookingAPI] Error cancelling booking: $e');
      return ApiResponse.error('Network error: $e');
    }
  }
}
