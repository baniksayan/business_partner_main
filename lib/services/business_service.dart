// lib/services/business_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/business.dart';
import '../config/api_config.dart';

class BusinessService {
  static const String _tag = 'BusinessService';

  // Get business information
  Future<Business> getBusinessInfo() async {
    print('🌐 [$_tag] Fetching business info...');
    
    try {
      // For now, return dummy data
      await Future.delayed(const Duration(seconds: 1)); // Simulate API delay
      
      final dummyData = _getDummyBusinessData();
      print('✅ [$_tag] Business info fetched successfully');
      return Business.fromJson(dummyData);
      
      // TODO: Uncomment when API is ready
      /*
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.businessInfoEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getToken()}',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Business.fromJson(data['data']);
      } else {
        throw Exception('Failed to load business info: ${response.statusCode}');
      }
      */
    } catch (e) {
      print('❌ [$_tag] Error fetching business info: $e');
      throw Exception('Failed to load business information');
    }
  }

  // Update business information
  Future<bool> updateBusinessInfo(Business business) async {
    print('🌐 [$_tag] Updating business info...');
    
    try {
      // For now, simulate successful update
      await Future.delayed(const Duration(seconds: 1));
      print('✅ [$_tag] Business info updated successfully');
      return true;
      
      // TODO: Uncomment when API is ready
      /*
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.updateBusinessInfoEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getToken()}',
        },
        body: json.encode(business.toJson()),
      );

      if (response.statusCode == 200) {
        print('✅ [$_tag] Business info updated successfully');
        return true;
      } else {
        throw Exception('Failed to update business info: ${response.statusCode}');
      }
      */
    } catch (e) {
      print('❌ [$_tag] Error updating business info: $e');
      throw Exception('Failed to update business information');
    }
  }

  // Update business hours
  Future<bool> updateBusinessHours(BusinessHours businessHours) async {
    print('🌐 [$_tag] Updating business hours...');
    
    try {
      // For now, simulate successful update
      await Future.delayed(const Duration(seconds: 1));
      print('✅ [$_tag] Business hours updated successfully');
      return true;
      
      // TODO: Uncomment when API is ready
      /*
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.businessHoursEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getToken()}',
        },
        body: json.encode(businessHours.toJson()),
      );

      return response.statusCode == 200;
      */
    } catch (e) {
      print('❌ [$_tag] Error updating business hours: $e');
      throw Exception('Failed to update business hours');
    }
  }

  // Get dummy business data
  Map<String, dynamic> _getDummyBusinessData() {
    return {
      'id': 'BUS001',
      'name': 'Elegant Beauty Salon',
      'owner_name': 'Sarah Johnson',
      'email': 'sarah@elegantbeauty.com',
      'phone': '+1 (555) 123-4567',
      'address': '123 Beauty Street, Suite 101',
      'city': 'Los Angeles',
      'state': 'California',
      'zip_code': '90210',
      'country': 'United States',
      'business_type': 'Beauty & Wellness',
      'description': 'Premium beauty salon offering comprehensive hair, nail, and skincare services with expert stylists and modern facilities.',
      'logo': 'https://images.unsplash.com/photo-1560066984-138dadb4c035?w=200',
      'website': 'https://www.elegantbeauty.com',
      'social_media': {
        'instagram': '@elegantbeauty',
        'facebook': 'ElegantBeautySalon',
        'twitter': '@elegant_beauty',
      },
      'business_hours': {
        'monday': {
          'is_open': true,
          'open_time': '09:00',
          'close_time': '18:00',
          'is_24_hours': false,
        },
        'tuesday': {
          'is_open': true,
          'open_time': '09:00',
          'close_time': '18:00',
          'is_24_hours': false,
        },
        'wednesday': {
          'is_open': true,
          'open_time': '09:00',
          'close_time': '18:00',
          'is_24_hours': false,
        },
        'thursday': {
          'is_open': true,
          'open_time': '09:00',
          'close_time': '20:00',
          'is_24_hours': false,
        },
        'friday': {
          'is_open': true,
          'open_time': '09:00',
          'close_time': '20:00',
          'is_24_hours': false,
        },
        'saturday': {
          'is_open': true,
          'open_time': '08:00',
          'close_time': '19:00',
          'is_24_hours': false,
        },
        'sunday': {
          'is_open': false,
          'open_time': '10:00',
          'close_time': '16:00',
          'is_24_hours': false,
        },
      },
      'services': [
        'Hair Cut & Styling',
        'Hair Coloring',
        'Manicure & Pedicure',
        'Facial Treatments',
        'Eyebrow Threading',
        'Hair Extensions',
        'Bridal Makeup',
        'Massage Therapy'
      ],
      'rating': 4.8,
      'total_reviews': 247,
      'is_verified': true,
      'is_active': true,
      'created_at': '2023-01-15T10:00:00Z',
      'updated_at': '2024-09-18T14:22:00Z',
      'stats': {
        'total_bookings': 1247,
        'active_bookings': 23,
        'completed_bookings': 1189,
        'cancelled_bookings': 35,
        'total_customers': 432,
        'active_customers': 186,
        'total_revenue': 125000.50,
        'monthly_revenue': 18750.25,
        'total_products': 45,
        'active_products': 42,
      }
    };
  }

  // Helper method to get auth token (placeholder)
  Future<String> _getToken() async {
    // TODO: Implement actual token retrieval
    return 'dummy_token';
  }
}
