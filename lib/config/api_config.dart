// lib/config/api_config.dart
class ApiConfig {
  // Debug mode flag
  static const bool isDebugMode = true; // Set to false in production
  
  // Base URL - Update this based on your setup
  static const String baseUrl = 'http://127.0.0.1:8000';
  
  // For Android Emulator, use: 'http://10.0.2.2:8000'
  // For Physical Device, use your computer's IP: 'http://192.168.1.100:8000'
  // For Production, use: 'https://your-domain.com'
  
  /// **AUTHENTICATION ENDPOINTS**
  static const String sendOtpEndpoint = '/auth/send-otp/';
  static const String verifyOtpEndpoint = '/auth/verify-otp/';
  static const String logoutEndpoint = '/auth/logout/';
  static const String refreshTokenEndpoint = '/auth/refresh/';
  
  /// **USER PROFILE ENDPOINTS**
  static const String userProfileEndpoint = '/auth/profile/';
  static const String updateUserProfileEndpoint = '/auth/profile/update/';
  static const String uploadProfileImageEndpoint = '/auth/profile/upload-image/';
  
  /// **BUSINESS PARTNER ENDPOINTS**
  static const String businessPartnerEndpoint = '/api/v1/business-partner/';
  static const String businessPartnerStoresEndpoint = '/api/v1/business-partner/stores/';
  static const String businessPartnerUsersEndpoint = '/api/v1/business-partner/users/';
  static const String businessPartnerMyCustomersEndpoint = '/api/v1/business-partner/users/my-customers/';
  
  /// **SHOPPING ASSISTANT ENDPOINTS**
  static const String shoppingAssistantEndpoint = '/api/v1/shopping-assistant/';
  
  /// **COMPLETE URLS**
  // Auth URLs
  static String get sendOtpUrl => '$baseUrl$sendOtpEndpoint';
  static String get verifyOtpUrl => '$baseUrl$verifyOtpEndpoint';
  static String get logoutUrl => '$baseUrl$logoutEndpoint';
  static String get refreshTokenUrl => '$baseUrl$refreshTokenEndpoint';
  
  // User Profile URLs
  static String get userProfileUrl => '$baseUrl$userProfileEndpoint';
  static String get updateUserProfileUrl => '$baseUrl$updateUserProfileEndpoint';
  static String get uploadProfileImageUrl => '$baseUrl$uploadProfileImageEndpoint';
  
  // Business Partner URLs
  static String get businessPartnerUrl => '$baseUrl$businessPartnerEndpoint';
  static String get businessPartnerStoresUrl => '$baseUrl$businessPartnerStoresEndpoint';
  static String get businessPartnerUsersUrl => '$baseUrl$businessPartnerUsersEndpoint';
  static String get businessPartnerMyCustomersUrl => '$baseUrl$businessPartnerMyCustomersEndpoint';
  
  // Shopping Assistant URLs
  static String get shoppingAssistantUrl => '$baseUrl$shoppingAssistantEndpoint';
  
  /// **HEADERS**
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  static Map<String, String> authHeaders(String? token) {
    return {
      ...defaultHeaders,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Map<String, String> multipartHeaders(String? token) {
    return {
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      // Don't set Content-Type for multipart requests - it's set automatically
    };
  }
  
  /// **CONFIGURATION METHODS**
  
  // Check if running in debug mode
  static bool get isDebug => isDebugMode;
  
  // Get timeout duration
  static const int defaultTimeout = 30;
  static const int uploadTimeout = 60;
  
  // API Version
  static const String apiVersion = 'v1';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  static Future getAuthToken() async {}
}
