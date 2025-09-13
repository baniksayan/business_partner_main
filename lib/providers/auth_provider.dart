// lib/providers/auth_provider.dart - FIXED TOKEN STORAGE
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_api_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _token;
  String? _refreshToken;
  String? _userEmail;
  String? _errorMessage;
  Map<String, dynamic>? _currentUser;
  DateTime? _loginTime;
  
  static const Duration sessionTimeout = Duration(hours: 24);

  // Getters
  bool get isAuthenticated {
    if (!_isAuthenticated) return false;
    if (_token == null || _token!.isEmpty) return false;
    if (_loginTime == null) return false;
    
    final sessionExpired = DateTime.now().difference(_loginTime!) > sessionTimeout;
    if (sessionExpired) {
      print('⚠️ Session expired, clearing auth state');
      _clearAuthStateInMemory();
      return false;
    }
    
    return true;
  }

  bool get isLoading => _isLoading;
  String? get token => _token;
  String? get refreshTokenValue => _refreshToken;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get currentUser => _currentUser;
  bool get isSessionExpired => _loginTime == null || DateTime.now().difference(_loginTime!) > sessionTimeout;

  // User getters
  String get userEmail => _currentUser?['email']?.toString() ?? _userEmail ?? '';
  String get userName {
    if (_currentUser != null) {
      final firstName = _currentUser!['first_name']?.toString().trim() ?? '';
      final lastName = _currentUser!['last_name']?.toString().trim() ?? '';
      
      if (firstName.isNotEmpty || lastName.isNotEmpty) {
        return '$firstName $lastName'.trim();
      }
      
      final name = _currentUser!['name']?.toString().trim();
      if (name != null && name.isNotEmpty) return name;
      
      final email = _currentUser!['email']?.toString();
      if (email != null && email.contains('@')) {
        return email.split('@')[0];
      }
    }
    return 'User';
  }

  String get userFirstName => _currentUser?['first_name']?.toString().trim() ?? 'User';
  String get userLastName => _currentUser?['last_name']?.toString().trim() ?? '';
  String? get userProfilePicture => _currentUser?['image_url']?.toString();
  String get userPhone => _currentUser?['phone']?.toString() ?? '';
  String get userId => _currentUser?['id']?.toString() ?? '0';
  String get businessName => _currentUser?['business_name']?.toString() ?? 'My Business';
  String get businessCategory => _currentUser?['business_category']?.toString() ?? 'General';

  List<int> get userRoles {
    if (_currentUser != null && _currentUser!['roles'] != null) {
      final roles = _currentUser!['roles'];
      if (roles is List) return List<int>.from(roles);
      if (roles is String) {
        return roles.split(',').map((e) => int.tryParse(e.trim()) ?? 0).where((e) => e != 0).toList();
      }
      if (roles is int) return [roles];
    }
    return [2]; // Default business partner
  }

  bool get isBusinessPartner => userRoles.contains(2);
  bool get isAdmin => userRoles.contains(1);
  bool get isEndUser => userRoles.contains(3);

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // **CRITICAL: Fixed verifyOtp method with proper token storage**
// lib/providers/auth_provider.dart - FIXED verifyOtp method
Future<bool> verifyOtp(String emailOrPhone, String otp) async {
  print('🔄 AuthProvider: Starting OTP verification for $emailOrPhone');
  _setLoading(true);
  _setError(null);

  try {
    final response = await AuthApiService.verifyOtp(emailOrPhone, otp);
    
    if (response.success) {
      print('✅ AuthProvider: OTP verification API successful');
      print('📦 AuthProvider: Full API Response: ${response.data}');
      
      // **CRITICAL FIX: Extract tokens from the nested 'data' field**
      final responseData = response.data?['data']; // <-- This is the key fix!
      
      if (responseData == null) {
        print('❌ AuthProvider: No data field in response');
        _setError('Invalid response format from server');
        _setLoading(false);
        return false;
      }
      
      // Extract tokens from the correct nested location
      final accessToken = responseData['access_token']?.toString();
      final refreshToken = responseData['refresh_token']?.toString();
      
      print('🔍 AuthProvider: Extracted from responseData:');
      print('  - Access Token: ${accessToken != null ? "EXISTS (${accessToken.length} chars)" : "NULL"}');
      print('  - Refresh Token: ${refreshToken != null ? "EXISTS" : "NULL"}');
      
      if (accessToken == null || accessToken.isEmpty) {
        print('❌ AuthProvider: No access token found in response data');
        _setError('Authentication failed - no token received');
        _setLoading(false);
        return false;
      }
      
      // **STEP 1: Set authentication data**
      _token = accessToken;
      _refreshToken = refreshToken;
      _userEmail = emailOrPhone;
      _loginTime = DateTime.now();
      _isAuthenticated = true;
      
      print('✅ AuthProvider: Authentication data set:');
      print('  - Token: ${_token!.substring(0, 30)}...');
      print('  - Email: $_userEmail');
      print('  - Login time: $_loginTime');
      print('  - Authenticated: $_isAuthenticated');
      
      // **STEP 2: Process user data from the correct nested location**
      if (responseData['user'] != null) {
        _currentUser = Map<String, dynamic>.from(responseData['user']);
        print('✅ User data loaded from API:');
        print('  - User ID: ${_currentUser!['id']}');
        print('  - User Email: ${_currentUser!['email']}');
        print('  - User Roles: ${_currentUser!['roles']}');
      } else {
        _currentUser = _createFallbackUserData(emailOrPhone);
        print('✅ User data: Created fallback');
      }

      _ensureUserRoles();
      
      // **STEP 3: Save to persistent storage**
      final saveSuccess = await _saveAuthData();
      if (!saveSuccess) {
        print('❌ AuthProvider: CRITICAL - Failed to save auth data to storage');
        _setError('Failed to save authentication data');
        _setLoading(false);
        return false;
      }
      
      // **STEP 4: Final verification**
      final finalCheck = isAuthenticated;
      print('✅ AuthProvider: Final authentication check: $finalCheck');
      print('✅ AuthProvider: Token ready for API calls: ${_token!.substring(0, 30)}...');
      
      _setLoading(false);
      notifyListeners();
      print('🎉 AuthProvider: OTP verification completed successfully');
      return true;
      
    } else {
      _setError(response.error ?? 'Invalid OTP');
      _setLoading(false);
      print('❌ AuthProvider: OTP verification failed: ${response.error}');
      return false;
    }
  } catch (e) {
    _setError('Network error occurred');
    _setLoading(false);
    print('🚨 AuthProvider: Exception in verifyOtp: $e');
    return false;
  }
}


  // **CRITICAL: Enhanced save method with validation**
  Future<bool> _saveAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      print('💾 AuthProvider: Saving authentication data to local storage...');
      
      if (_token == null || _token!.isEmpty) {
        print('❌ AuthProvider: Cannot save - no token available');
        return false;
      }
      
      // Save all authentication data
      await prefs.setString('auth_token', _token!);
      print('  ✅ Token saved (${_token!.length} chars)');
      
      if (_refreshToken != null) {
        await prefs.setString('refresh_token', _refreshToken!);
        print('  ✅ Refresh token saved');
      }
      
      if (_userEmail != null) {
        await prefs.setString('user_email', _userEmail!);
        print('  ✅ Email saved: $_userEmail');
      }
      
      if (_currentUser != null) {
        await prefs.setString('current_user', jsonEncode(_currentUser!));
        print('  ✅ User data saved');
      }
      
      if (_loginTime != null) {
        await prefs.setString('login_time', _loginTime!.toIso8601String());
        print('  ✅ Login time saved: $_loginTime');
      }
      
      await prefs.setBool('is_authenticated', _isAuthenticated);
      await prefs.setString('last_activity', DateTime.now().toIso8601String());
      
      // **VERIFICATION: Read back to confirm**
      final savedToken = prefs.getString('auth_token');
      if (savedToken == null || savedToken != _token) {
        print('❌ AuthProvider: Token verification failed after save');
        return false;
      }
      
      print('✅ AuthProvider: All auth data saved and verified successfully');
      return true;
      
    } catch (e) {
      print('❌ AuthProvider: CRITICAL - Failed to save auth data: $e');
      return false;
    }
  }

  // Load authentication data on app start
  Future<void> loadAuthData() async {
    print('🔄 AuthProvider: Loading authentication data from local storage...');
    _setLoading(true);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load all data
      _token = prefs.getString('auth_token');
      _refreshToken = prefs.getString('refresh_token');
      _userEmail = prefs.getString('user_email');
      _isAuthenticated = prefs.getBool('is_authenticated') ?? false;
      
      final loginTimeString = prefs.getString('login_time');
      if (loginTimeString != null) {
        _loginTime = DateTime.parse(loginTimeString);
      }
      
      final userDataString = prefs.getString('current_user');
      if (userDataString != null && userDataString.isNotEmpty) {
        _currentUser = jsonDecode(userDataString);
      }
      
      print('📖 AuthProvider: Loaded from storage:');
      print('  - Token exists: ${_token != null && _token!.isNotEmpty}');
      print('  - Email: $_userEmail');
      print('  - Authenticated flag: $_isAuthenticated');
      print('  - Login time: $_loginTime');
      print('  - Session expired: $isSessionExpired');
      
      // Validate loaded data
      if (_isAuthenticated) {
        if (_token == null || _token!.isEmpty || _userEmail == null || isSessionExpired) {
          print('⚠️ AuthProvider: Invalid session data found, clearing...');
          await logout();
        } else {
          print('✅ AuthProvider: Valid session loaded - token ready for API calls');
          print('✅ AuthProvider: Token: ${_token!.substring(0, 20)}...');
          // Update activity
          await prefs.setString('last_activity', DateTime.now().toIso8601String());
        }
      } else {
        print('ℹ️ AuthProvider: No authenticated session found');
      }
      
    } catch (e) {
      print('❌ AuthProvider: Error loading auth data: $e');
      await _clearAuthData();
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Send OTP
  Future<bool> sendOtp(String emailOrPhone) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await AuthApiService.sendOtp(emailOrPhone);
      
      if (response.success) {
        _userEmail = emailOrPhone;
        _setLoading(false);
        return true;
      } else {
        _setError(response.error ?? 'Failed to send OTP');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Network error occurred');
      _setLoading(false);
      return false;
    }
  }

  // **TOKEN-BASED API METHODS**
  
  // Update user profile using stored token
  Future<bool> updateUserProfile(Map<String, dynamic> userData) async {
    if (!isAuthenticated || _token == null) {
      _setError('Not authenticated - please log in');
      return false;
    }

    print('🔄 AuthProvider: Updating profile with token: ${_token!.substring(0, 20)}...');
    _setLoading(true);
    _setError(null);

    try {
      final response = await AuthApiService.updateUserProfile(_token!, userData);
      
      if (response.success) {
        if (_currentUser != null) {
          _currentUser!.addAll(userData);
        }
        await _saveAuthData(); // Save updated user data
        _setLoading(false);
        notifyListeners();
        print('✅ AuthProvider: Profile updated successfully');
        return true;
      } else {
        _setError(response.error ?? 'Failed to update profile');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Network error occurred');
      _setLoading(false);
      return false;
    }
  }

  // Get fresh user data from server using stored token
  Future<bool> refreshUserData() async {
    if (!isAuthenticated || _token == null) return false;

    print('🔄 AuthProvider: Refreshing user data with token: ${_token!.substring(0, 20)}...');

    try {
      final response = await AuthApiService.getUserProfile(_token!);
      
      if (response.success && response.data != null) {
        _currentUser = Map<String, dynamic>.from(response.data!);
        await _saveAuthData();
        notifyListeners();
        print('✅ AuthProvider: User data refreshed successfully');
        return true;
      }
      return false;
    } catch (e) {
      print('❌ AuthProvider: Error refreshing user data: $e');
      return false;
    }
  }

  // Logout and clear all stored data
  Future<void> logout() async {
    print('🔄 AuthProvider: Logging out...');
    
    try {
      if (_token != null) {
        await AuthApiService.logout(_token!);
        print('✅ AuthProvider: Logout API called with token');
      }
    } catch (e) {
      print('⚠️ AuthProvider: Logout API failed: $e');
    }
    
    // Clear all state
    _clearAuthStateInMemory();
    await _clearAuthData();
    
    print('✅ AuthProvider: Logout completed - all data cleared');
    notifyListeners();
  }

  // Helper methods
  void _clearAuthStateInMemory() {
    _isAuthenticated = false;
    _token = null;
    _refreshToken = null;
    _userEmail = null;
    _currentUser = null;
    _errorMessage = null;
    _loginTime = null;
  }

  Future<void> _clearAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('refresh_token');
      await prefs.remove('user_email');
      await prefs.remove('current_user');
      await prefs.remove('is_authenticated');
      await prefs.remove('login_time');
      await prefs.remove('last_activity');
      print('✅ AuthProvider: All storage data cleared');
    } catch (e) {
      print('⚠️ AuthProvider: Error clearing storage: $e');
    }
  }

  void _ensureUserRoles() {
    if (_currentUser != null) {
      final roles = _currentUser!['roles'];
      if (roles == null || (roles is List && roles.isEmpty)) {
        _currentUser!['roles'] = [2]; // Default business partner role
      }
    }
  }

  Map<String, dynamic> _createFallbackUserData(String email) {
    final emailUsername = email.contains('@') ? email.split('@')[0] : 'User';
    final nameParts = emailUsername.split('.');
    
    return {
      'id': DateTime.now().millisecondsSinceEpoch,
      'email': email,
      'first_name': nameParts.isNotEmpty ? _capitalize(nameParts[0]) : 'Business',
      'last_name': nameParts.length > 1 ? _capitalize(nameParts[1]) : 'Partner',
      'roles': [2], // Business partner role
      'is_active': true,
      'phone': '',
      'image_url': null,
      'business_name': 'My Business',
      'business_category': 'General',
      'created_at': DateTime.now().toIso8601String(),
    };
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  Future<void> refreshSession() async {
    if (isAuthenticated) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('last_activity', DateTime.now().toIso8601String());
      } catch (e) {
        print('⚠️ AuthProvider: Session refresh failed: $e');
      }
    }
  }

  void debugAuthState() {
    print('🔍 AuthProvider Debug State:');
    print('  - _isAuthenticated: $_isAuthenticated');
    print('  - _token: ${_token != null ? "EXISTS (${_token!.length})" : "NULL"}');
    print('  - _userEmail: $_userEmail');
    print('  - _loginTime: $_loginTime');
    print('  - isSessionExpired: $isSessionExpired');
    print('  - isAuthenticated (getter): $isAuthenticated');
    print('  - userRoles: $userRoles');
  }
}
