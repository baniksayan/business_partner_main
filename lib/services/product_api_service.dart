// lib/services/product_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../config/api_config.dart';

class ProductApiService {
  static Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    print('🔑 [ProductAPI] Token check: ${token != null ? "Found (${token?.substring(0, 10)}...)" : "Not Found"}');
    return token;
  }

  static Future<Map<String, String>> _getHeaders() async {
    final token = await _getAuthToken();
    if (token == null) {
      print('❌ [ProductAPI] No authentication token found');
      throw Exception('AUTHENTICATION_REQUIRED');
    }
    
    final headers = ApiConfig.authHeaders(token);
    print('📤 [ProductAPI] Request headers prepared with Bearer token');
    return headers;
  }

  static String get _productsBaseUrl => '${ApiConfig.baseUrl}/api/v1/business-partner/products';

  // 1. GET ALL PRODUCTS
  static Future<List<Product>> getAllProducts() async {
    print('\n🚀 [ProductAPI] ========== GET ALL PRODUCTS ==========');
    print('🌐 [ProductAPI] API URL: $_productsBaseUrl/');
    
    try {
      final headers = await _getHeaders();
      print('📡 [ProductAPI] Making HTTP GET request...');
      
      final response = await http.get(
        Uri.parse('$_productsBaseUrl/'),
        headers: headers,
      ).timeout(Duration(seconds: ApiConfig.defaultTimeout));

      print('📥 [ProductAPI] Response received!');
      print('📊 [ProductAPI] Status Code: ${response.statusCode}');
      print('📄 [ProductAPI] Response Headers: ${response.headers}');
      print('📄 [ProductAPI] Raw Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return _parseProductsResponse(response.body);
      } 
      
      else if (response.statusCode == 400) {
        print('❌ [ProductAPI] 400 Bad Request - parsing error details');
        return _handleBadRequestError(response.body);
      }
      
      else if (response.statusCode == 401) {
        print('🔒 [ProductAPI] 401 Unauthorized');
        throw Exception('AUTHENTICATION_EXPIRED');
      } 
      
      else if (response.statusCode == 403) {
        print('🚫 [ProductAPI] 403 Forbidden');
        throw Exception('ACCESS_FORBIDDEN');
      }
      
      else if (response.statusCode == 404) {
        print('🔍 [ProductAPI] 404 Not Found');
        throw Exception('ENDPOINT_NOT_FOUND');
      }
      
      else if (response.statusCode >= 500) {
        print('🖥️ [ProductAPI] Server Error ${response.statusCode}');
        throw Exception('SERVER_ERROR');
      }
      
      else {
        print('❌ [ProductAPI] Unexpected HTTP Error ${response.statusCode}');
        print('📄 [ProductAPI] Error response body: ${response.body}');
        throw Exception('HTTP_ERROR_${response.statusCode}');
      }
    } 
    
    catch (e) {
      print('💥 [ProductAPI] Exception occurred: ${e.runtimeType}');
      print('💥 [ProductAPI] Exception details: $e');
      
      if (e.toString().contains('SocketException')) {
        throw Exception('NETWORK_ERROR');
      }
      
      if (e.toString().contains('TimeoutException')) {
        throw Exception('TIMEOUT_ERROR');
      }
      
      rethrow;
    } 
    
    finally {
      print('🏁 [ProductAPI] ========== END GET ALL PRODUCTS ==========\n');
    }
  }

  // 2. GET SINGLE PRODUCT
  static Future<Product> getProduct(String productId) async {
    print('\n🔍 [ProductAPI] ========== GET PRODUCT BY ID ==========');
    print('🌐 [ProductAPI] API URL: $_productsBaseUrl/$productId/');
    print('🆔 [ProductAPI] Product ID: $productId');
    
    try {
      final headers = await _getHeaders();
      print('📡 [ProductAPI] Making HTTP GET request for single product...');
      
      final response = await http.get(
        Uri.parse('$_productsBaseUrl/$productId/'),
        headers: headers,
      ).timeout(Duration(seconds: ApiConfig.defaultTimeout));

      print('📥 [ProductAPI] Single product response: ${response.statusCode}');
      print('📄 [ProductAPI] Single product body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        if (responseData is Map<String, dynamic>) {
          if (responseData.containsKey('success') && responseData['success'] == true) {
            return Product.fromJson(responseData['data']);
          } else if (responseData.containsKey('data')) {
            return Product.fromJson(responseData['data']);
          } else {
            return Product.fromJson(responseData);
          }
        } else {
          throw Exception('UNEXPECTED_SINGLE_PRODUCT_RESPONSE_FORMAT');
        }
      } else if (response.statusCode == 404) {
        throw Exception('PRODUCT_NOT_FOUND');
      } else if (response.statusCode == 401) {
        throw Exception('AUTHENTICATION_EXPIRED');
      } else {
        throw Exception('GET_PRODUCT_FAILED_${response.statusCode}');
      }
      
    } catch (e) {
      print('❌ [ProductAPI] Get product error: $e');
      rethrow;
    } finally {
      print('🏁 [ProductAPI] ========== END GET PRODUCT BY ID ==========\n');
    }
  }

  // 3. CREATE PRODUCT
  static Future<Product> createProduct(Map<String, dynamic> productData) async {
    print('\n➕ [ProductAPI] ========== CREATE PRODUCT ==========');
    print('📤 [ProductAPI] Product data: $productData');
    
    try {
      final headers = await _getHeaders();
      
      final response = await http.post(
        Uri.parse('$_productsBaseUrl/'),
        headers: headers,
        body: json.encode(productData),
      ).timeout(Duration(seconds: ApiConfig.defaultTimeout));

      print('📥 [ProductAPI] Create response: ${response.statusCode}');
      print('📄 [ProductAPI] Create response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        if (responseData is Map<String, dynamic>) {
          if (responseData.containsKey('success') && responseData['success'] == true) {
            return Product.fromJson(responseData['data']);
          } else if (responseData.containsKey('data')) {
            return Product.fromJson(responseData['data']);
          } else {
            return Product.fromJson(responseData);
          }
        } else {
          throw Exception('UNEXPECTED_CREATE_RESPONSE_FORMAT');
        }
      } else if (response.statusCode == 400) {
        return _handleCreateValidationError(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('AUTHENTICATION_REQUIRED');
      } else {
        throw Exception('CREATE_FAILED_${response.statusCode}: ${response.body}');
      }
      
    } catch (e) {
      print('❌ [ProductAPI] Create product error: $e');
      rethrow;
    } finally {
      print('🏁 [ProductAPI] ========== END CREATE PRODUCT ==========\n');
    }
  }

  // 4. UPDATE PRODUCT (PUT)
  static Future<Product> updateProduct(String productId, Map<String, dynamic> productData) async {
    print('\n✏️ [ProductAPI] ========== UPDATE PRODUCT ==========');
    print('🆔 [ProductAPI] Product ID: $productId');
    print('📤 [ProductAPI] Update data: $productData');
    
    try {
      final headers = await _getHeaders();
      
      final response = await http.put(
        Uri.parse('$_productsBaseUrl/$productId/'),
        headers: headers,
        body: json.encode(productData),
      ).timeout(Duration(seconds: ApiConfig.defaultTimeout));

      print('📥 [ProductAPI] Update response: ${response.statusCode}');
      print('📄 [ProductAPI] Update response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        if (responseData is Map<String, dynamic>) {
          if (responseData.containsKey('success') && responseData['success'] == true) {
            return Product.fromJson(responseData['data']);
          } else if (responseData.containsKey('data')) {
            return Product.fromJson(responseData['data']);
          } else {
            return Product.fromJson(responseData);
          }
        } else {
          throw Exception('UNEXPECTED_UPDATE_RESPONSE_FORMAT');
        }
      } else if (response.statusCode == 404) {
        throw Exception('PRODUCT_NOT_FOUND');
      } else if (response.statusCode == 400) {
        throw Exception('UPDATE_VALIDATION_ERROR: ${response.body}');
      } else if (response.statusCode == 401) {
        throw Exception('AUTHENTICATION_REQUIRED');
      } else {
        throw Exception('UPDATE_FAILED_${response.statusCode}: ${response.body}');
      }
      
    } catch (e) {
      print('❌ [ProductAPI] Update product error: $e');
      rethrow;
    } finally {
      print('🏁 [ProductAPI] ========== END UPDATE PRODUCT ==========\n');
    }
  }

  // 5. PARTIAL UPDATE PRODUCT (PATCH)
  static Future<Product> partialUpdateProduct(String productId, Map<String, dynamic> updateData) async {
    print('\n🔧 [ProductAPI] ========== PARTIAL UPDATE PRODUCT ==========');
    print('🆔 [ProductAPI] Product ID: $productId');
    print('📤 [ProductAPI] Partial update data: $updateData');
    
    try {
      final headers = await _getHeaders();
      
      final response = await http.patch(
        Uri.parse('$_productsBaseUrl/$productId/'),
        headers: headers,
        body: json.encode(updateData),
      ).timeout(Duration(seconds: ApiConfig.defaultTimeout));

      print('📥 [ProductAPI] Partial update response: ${response.statusCode}');
      print('📄 [ProductAPI] Partial update response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        if (responseData is Map<String, dynamic>) {
          if (responseData.containsKey('success') && responseData['success'] == true) {
            return Product.fromJson(responseData['data']);
          } else if (responseData.containsKey('data')) {
            return Product.fromJson(responseData['data']);
          } else {
            return Product.fromJson(responseData);
          }
        } else {
          throw Exception('UNEXPECTED_PATCH_RESPONSE_FORMAT');
        }
      } else if (response.statusCode == 404) {
        throw Exception('PRODUCT_NOT_FOUND');
      } else if (response.statusCode == 400) {
        throw Exception('PATCH_VALIDATION_ERROR: ${response.body}');
      } else if (response.statusCode == 401) {
        throw Exception('AUTHENTICATION_REQUIRED');
      } else {
        throw Exception('PATCH_FAILED_${response.statusCode}: ${response.body}');
      }
      
    } catch (e) {
      print('❌ [ProductAPI] Partial update product error: $e');
      rethrow;
    } finally {
      print('🏁 [ProductAPI] ========== END PARTIAL UPDATE PRODUCT ==========\n');
    }
  }

  // 6. DELETE PRODUCT
  static Future<bool> deleteProduct(String productId) async {
    print('\n🗑️ [ProductAPI] ========== DELETE PRODUCT ==========');
    print('🆔 [ProductAPI] Product ID: $productId');
    
    try {
      final headers = await _getHeaders();
      
      final response = await http.delete(
        Uri.parse('$_productsBaseUrl/$productId/'),
        headers: headers,
      ).timeout(Duration(seconds: ApiConfig.defaultTimeout));

      print('📥 [ProductAPI] Delete response: ${response.statusCode}');
      print('📄 [ProductAPI] Delete response body: ${response.body}');

      if (response.statusCode == 204 || response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 404) {
        throw Exception('PRODUCT_NOT_FOUND');
      } else if (response.statusCode == 401) {
        throw Exception('AUTHENTICATION_REQUIRED');
      } else {
        throw Exception('DELETE_FAILED_${response.statusCode}: ${response.body}');
      }
      
    } catch (e) {
      print('❌ [ProductAPI] Delete product error: $e');
      rethrow;
    } finally {
      print('🏁 [ProductAPI] ========== END DELETE PRODUCT ==========\n');
    }
  }

  // HELPER METHODS
  static List<Product> _parseProductsResponse(String responseBody) {
    try {
      if (responseBody.trim().isEmpty) {
        print('⚠️ [ProductAPI] Empty response body - returning empty list');
        return [];
      }

      final dynamic responseData = json.decode(responseBody);
      print('🔍 [ProductAPI] Parsed JSON type: ${responseData.runtimeType}');
      print('🔍 [ProductAPI] Parsed JSON content: $responseData');

      List<Product> products = [];

      // Handle different response formats
      if (responseData is Map<String, dynamic>) {
        print('📋 [ProductAPI] Response is Map format');
        
        // Case 1: {success: true, data: [...]}
        if (responseData.containsKey('success')) {
          print('✅ [ProductAPI] Found "success" field: ${responseData['success']}');
          
          if (responseData['success'] == true) {
            final data = responseData['data'];
            if (data == null || (data is List && data.isEmpty)) {
              print('📭 [ProductAPI] No products in response - returning empty list');
              return [];
            }
            if (data is List) {
              print('✅ [ProductAPI] Found ${data.length} products');
              products = _parseProductList(data);
            }
          } else {
            // API returned success=false
            final message = responseData['message'] ?? 'API returned unsuccessful response';
            print('❌ [ProductAPI] API returned success=false: $message');
            throw Exception('API_ERROR: $message');
          }
        }
        
        // Case 2: {data: [...]}
        else if (responseData.containsKey('data')) {
          final data = responseData['data'];
          if (data is List) {
            products = data.isEmpty ? [] : _parseProductList(data);
          }
        }
        
        // Case 3: {results: [...]} (Django pagination format)
        else if (responseData.containsKey('results')) {
          final data = responseData['results'];
          if (data is List) {
            products = data.isEmpty ? [] : _parseProductList(data);
          }
        }
        
        // Case 4: Single product object
        else {
          try {
            final product = Product.fromJson(responseData);
            products = [product];
          } catch (e) {
            print('❌ [ProductAPI] Failed to parse single product: $e');
            throw Exception('PARSING_ERROR: Failed to parse product data');
          }
        }
      } 
      
      // Case 5: Direct array response
      else if (responseData is List) {
        print('📋 [ProductAPI] Response is direct List format with ${responseData.length} items');
        products = responseData.isEmpty ? [] : _parseProductList(responseData);
      }
      
      else {
        throw Exception('UNEXPECTED_RESPONSE_FORMAT: ${responseData.runtimeType}');
      }

      print('🎯 [ProductAPI] Successfully parsed ${products.length} products');
      for (int i = 0; i < products.length && i < 3; i++) {
        print('   📦 Product ${i + 1}: ${products[i].name} - ${products[i].priceDisplay}');
      }
      if (products.length > 3) {
        print('   ... and ${products.length - 3} more products');
      }

      return products;

    } catch (e) {
      print('❌ [ProductAPI] JSON Parsing Error: $e');
      throw Exception('PARSING_ERROR: $e');
    }
  }

  static List<Product> _parseProductList(List<dynamic> productsList) {
    final List<Product> products = [];
    
    for (int i = 0; i < productsList.length; i++) {
      try {
        final productJson = productsList[i] as Map<String, dynamic>;
        print('🔍 [ProductAPI] Parsing product ${i + 1}: ${productJson['name']}');
        
        final product = Product.fromJson(productJson);
        products.add(product);
        
      } catch (e) {
        print('⚠️ [ProductAPI] Failed to parse product ${i + 1}: $e');
        print('📄 [ProductAPI] Product data: ${productsList[i]}');
        // Continue parsing other products instead of failing completely
        continue;
      }
    }
    
    return products;
  }

  static List<Product> _handleBadRequestError(String responseBody) {
    try {
      final errorData = json.decode(responseBody);
      print('🔍 [ProductAPI] 400 Error Details: $errorData');
      
      if (errorData is Map<String, dynamic>) {
        // Check for specific error messages
        if (errorData.containsKey('message')) {
          final message = errorData['message'];
          print('❌ [ProductAPI] Error message: $message');
          
          // Handle specific error cases
          if (message.toString().toLowerCase().contains('authentication')) {
            throw Exception('AUTHENTICATION_REQUIRED');
          } else if (message.toString().toLowerCase().contains('permission')) {
            throw Exception('PERMISSION_DENIED');
          } else if (message.toString().toLowerCase().contains('validation')) {
            throw Exception('VALIDATION_ERROR: $message');
          } else {
            throw Exception('BAD_REQUEST: $message');
          }
        }
        
        // Check for Django-style field errors
        if (errorData.containsKey('errors') || errorData.containsKey('detail')) {
          final errors = errorData['errors'] ?? errorData['detail'];
          throw Exception('VALIDATION_ERROR: $errors');
        }
      }
      
      // Generic 400 error
      throw Exception('BAD_REQUEST: Invalid request format or parameters');
      
    } catch (e) {
      if (e.toString().startsWith('Exception:')) {
        rethrow;
      }
      // If we can't parse the error response, return generic error
      print('❌ [ProductAPI] Could not parse 400 error response: $e');
      throw Exception('BAD_REQUEST: Invalid request - check your API configuration');
    }
  }

  static Product _handleCreateValidationError(String responseBody) {
    try {
      final errorData = json.decode(responseBody);
      print('🔍 [ProductAPI] Create validation error: $errorData');
      
      if (errorData is Map<String, dynamic>) {
        final message = errorData['message'] ?? errorData['detail'] ?? 'Validation failed';
        throw Exception('CREATE_VALIDATION_ERROR: $message');
      }
      
      throw Exception('CREATE_VALIDATION_ERROR: Invalid product data');
    } catch (e) {
      if (e.toString().startsWith('Exception:')) {
        rethrow;
      }
      throw Exception('CREATE_VALIDATION_ERROR: Could not parse validation error');
    }
  }

  static Future<bool> isAuthenticated() async {
    final token = await _getAuthToken();
    final isAuth = token != null && token.isNotEmpty;
    print('🔐 [ProductAPI] Authentication status: $isAuth');
    return isAuth;
  }

  // Test method to check if the API endpoint exists
  static Future<Map<String, dynamic>> testEndpoint() async {
    try {
      print('🧪 [ProductAPI] Testing endpoint connectivity...');
      
      // First test without auth
      final noAuthResponse = await http.get(
        Uri.parse(_productsBaseUrl + '/'),
        headers: ApiConfig.defaultHeaders,
      ).timeout(Duration(seconds: 10));
      
      print('🧪 [ProductAPI] No-auth test: ${noAuthResponse.statusCode}');
      
      // Then test with auth if token exists
      final token = await _getAuthToken();
      if (token != null) {
        final authHeaders = ApiConfig.authHeaders(token);
        final authResponse = await http.get(
          Uri.parse(_productsBaseUrl + '/'),
          headers: authHeaders,
        ).timeout(Duration(seconds: 10));
        
        print('🧪 [ProductAPI] Auth test: ${authResponse.statusCode}');
        
        return {
          'endpoint_exists': true,
          'no_auth_status': noAuthResponse.statusCode,
          'auth_status': authResponse.statusCode,
          'auth_response': authResponse.body,
          'requires_auth': authResponse.statusCode != noAuthResponse.statusCode,
        };
      } else {
        return {
          'endpoint_exists': true,
          'no_auth_status': noAuthResponse.statusCode,
          'auth_status': null,
          'auth_response': null,
          'requires_auth': noAuthResponse.statusCode == 401,
        };
      }
      
    } catch (e) {
      print('❌ [ProductAPI] Endpoint test failed: $e');
      return {
        'endpoint_exists': false,
        'error': e.toString(),
      };
    }
  }
}
