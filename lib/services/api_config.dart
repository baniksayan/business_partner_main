// lib/services/api_config.dart
class ApiConfig {
  // Base URL for your Django server
  static const String baseUrl = 'http://127.0.0.1:8000';
  
  // API Base Paths
  static const String apiV1 = '/api/v1';
  
  // Auth endpoints (from auth_app.urls)
  static const String authBasePath = '/auth';
  static const String sendOtpEndpoint = '$authBasePath/send-otp/';
  static const String verifyOtpEndpoint = '$authBasePath/verify-otp/';
  static const String logoutEndpoint = '$authBasePath/logout/';
  static const String signupEndpoint = '$authBasePath/signup-api/';
  
  // Shopping Assistant endpoints
  static const String shoppingAssistantBasePath = '$apiV1/shopping-assistant';
  static const String shoppingAssistantDemo = '$shoppingAssistantBasePath/demo/';
  
  // Business Partner endpoints
  static const String businessPartnerBasePath = '$apiV1/business-partner';
  
  // Control Panel endpoints
  static const String controlPanelBasePath = '/control-panel';
  
  // Documentation endpoints
  static const String swaggerDocs = '/docs/';
  static const String redocDocs = '/redoc/';
  
  // Complete URLs
  static String get sendOtpUrl => '$baseUrl$sendOtpEndpoint';
  static String get verifyOtpUrl => '$baseUrl$verifyOtpEndpoint';
  static String get logoutUrl => '$baseUrl$logoutEndpoint';
  static String get signupUrl => '$baseUrl$signupEndpoint';
  
  // Headers
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
  
  // Environment-specific configuration
  static String getBaseUrl() {
    // For Android Emulator
    // return 'http://10.0.2.2:8000';
    
    // For Physical Device (replace with your actual IP)
    // return 'http://192.168.1.100:8000';
    
    // For Local Development
    return 'http://127.0.0.1:8000';
    
    // For Production
    // return 'https://your-production-domain.com';
  }
}
