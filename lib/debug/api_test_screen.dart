// lib/debug/api_test_screen.dart
import 'package:flutter/material.dart';
import '../services/product_api_service.dart';
import '../services/token_helper.dart';
import '../config/api_config.dart';

class ApiTestScreen extends StatefulWidget {
  const ApiTestScreen({Key? key}) : super(key: key);

  @override
  State<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  String _testResults = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _runAllTests();
  }

  Future<void> _runAllTests() async {
    setState(() {
      _isLoading = true;
      _testResults = 'Running comprehensive API tests...\n\n';
    });

    String results = '';

    // Test 1: Basic Configuration
    results += '🔧 CONFIGURATION TEST\n';
    results += 'Base URL: ${ApiConfig.baseUrl}\n';
    results += 'Products Endpoint: ${ApiConfig.baseUrl}/api/v1/business-partner/products/\n';
    results += 'Debug Mode: ${ApiConfig.isDebugMode}\n\n';

    // Test 2: Authentication
    results += '🔑 AUTHENTICATION TEST\n';
    final token = await TokenHelper.getToken();
    final isAuth = await TokenHelper.isAuthenticated();
    results += 'Has Token: ${token != null}\n';
    results += 'Is Authenticated: $isAuth\n';
    if (token != null) {
      results += 'Token Preview: ${token.substring(0, 20)}...\n';
    }
    results += '\n';

    // Test 3: API Endpoint Test
    results += '🌐 API ENDPOINT TEST\n';
    try {
      final endpointTest = await ProductApiService.testEndpoint();
      results += 'Endpoint Exists: ${endpointTest['endpoint_exists']}\n';
      results += 'No Auth Status: ${endpointTest['no_auth_status']}\n';
      results += 'Auth Status: ${endpointTest['auth_status']}\n';
      results += 'Requires Auth: ${endpointTest['requires_auth']}\n';
      if (endpointTest['auth_response'] != null) {
        results += 'Auth Response: ${endpointTest['auth_response']}\n';
      }
    } catch (e) {
      results += 'Endpoint Test Error: $e\n';
    }
    results += '\n';

    // Test 4: Products API Call
    results += '📦 PRODUCTS API TEST\n';
    try {
      final products = await ProductApiService.getAllProducts();
      results += 'API Call: SUCCESS ✅\n';
      results += 'Products Found: ${products.length}\n';
      if (products.isNotEmpty) {
        results += 'First Product: ${products.first.name}\n';
      }
    } catch (e) {
      results += 'API Call Error: $e\n';
    }
    results += '\n';

    // Test 5: Dummy Token Test
    results += '🧪 DUMMY TOKEN TEST\n';
    await TokenHelper.saveToken('test_token_123');
    try {
      await ProductApiService.getAllProducts();
      results += 'Dummy Token Test: Unexpectedly succeeded\n';
    } catch (e) {
      results += 'Dummy Token Test: Failed as expected - $e\n';
    }
    
    // Restore original token if it existed
    if (token != null) {
      await TokenHelper.saveToken(token);
    } else {
      await TokenHelper.clearAllTokens();
    }

    setState(() {
      _testResults = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Test Suite'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _runAllTests,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_isLoading)
              const LinearProgressIndicator(color: Colors.orange),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _testResults,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _setValidToken,
                    child: const Text('Set Valid Token'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _clearTokens,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Clear Tokens'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _setValidToken() async {
    // You'll need to replace this with a real token from your login
    const validToken = 'your_actual_jwt_token_here';
    await TokenHelper.saveToken(validToken);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Token set - please get real token from login')),
    );
    await _runAllTests();
  }

  Future<void> _clearTokens() async {
    await TokenHelper.clearAllTokens();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All tokens cleared')),
    );
    await _runAllTests();
  }
} 
