// lib/providers/auth_provider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_api_service.dart';
import '../services/api_exceptions.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _token;
  String? _refreshToken;
  String? _userEmail;
  String? _errorMessage;
  Map<String, dynamic>? _currentUser;

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get token => _token;
  String? get refreshTokenValue => _refreshToken; // **RENAMED: from refreshToken to refreshTokenValue**
  String? get userEmail => _userEmail;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get currentUser => _currentUser;

  /// **USER ROLES MANAGEMENT**
  
  List<int> get userRoles {
    if (_currentUser != null && _currentUser!['roles'] != null) {
      final roles = _currentUser!['roles'];
      
      if (roles is List) {
        return List<int>.from(roles);
      } else if (roles is String) {
        return roles
            .split(',')
            .map((e) => int.tryParse(e.trim()) ?? 0)
            .where((e) => e != 0)
            .toList();
      } else if (roles is int) {
        return [roles];
      }
    }
    
    if (_userEmail != null) {
      final email = _userEmail!.toLowerCase();
      if (email.contains('business') || 
          email.contains('partner') || 
          email.contains('admin')) {
        return [2];
      }
    }
    
    return [];
  }

  bool get isBusinessPartner {
    return userRoles.contains(2);
  }

  bool get isAdmin {
    return userRoles.contains(1);
  }

  bool get isEndUser {
    return userRoles.contains(3);
  }

  bool hasRole(int roleId) {
    return userRoles.contains(roleId);
  }

  bool hasAnyRole(List<int> roleIds) {
    return roleIds.any((roleId) => userRoles.contains(roleId));
  }

  /// **USER PROFILE INFORMATION**

  String get userName {
    if (_currentUser != null) {
      final firstName = _currentUser!['first_name']?.toString().trim() ?? '';
      final lastName = _currentUser!['last_name']?.toString().trim() ?? '';
      
      if (firstName.isNotEmpty || lastName.isNotEmpty) {
        return '$firstName $lastName'.trim();
      }
      
      final name = _currentUser!['name']?.toString().trim();
      if (name != null && name.isNotEmpty) {
        return name;
      }
      
      final email = _currentUser!['email']?.toString();
      if (email != null && email.contains('@')) {
        return email.split('@')[0];
      }
    }
    
    return 'User';
  }

  String get userFirstName {
    return _currentUser?['first_name']?.toString().trim() ?? 'User';
  }

  String get userLastName {
    return _currentUser?['last_name']?.toString().trim() ?? '';
  }

  String? get userProfilePicture {
    final imageUrl = _currentUser?['image_url']?.toString();
    if (imageUrl != null && imageUrl.isNotEmpty && imageUrl != 'null') {
      return imageUrl;
    }
    
    final profilePic = _currentUser?['profile_picture']?.toString();
    if (profilePic != null && profilePic.isNotEmpty && profilePic != 'null') {
      return profilePic;
    }
    
    final avatar = _currentUser?['avatar']?.toString();
    if (avatar != null && avatar.isNotEmpty && avatar != 'null') {
      return avatar;
    }
    
    return null;
  }

  String get userPhone {
    final phone = _currentUser?['phone']?.toString() ?? 
                 _currentUser?['phone_number']?.toString() ?? 
                 _currentUser?['mobile']?.toString();
    
    if (phone != null && phone.isNotEmpty && phone != 'null') {
      return phone;
    }
    
    return '';
  }

  String get userId {
    return _currentUser?['id']?.toString() ?? '0';
  }

  bool get isUserActive {
    return _currentUser?['is_active'] == true;
  }

  /// **STATE MANAGEMENT**

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

  /// **AUTHENTICATION METHODS**

  Future<bool> sendOtp(String emailOrPhone) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await AuthApiService.sendOtp(emailOrPhone);
      
      if (response.success) {
        _userEmail = emailOrPhone;
        _setLoading(false);
        print('✅ OTP sent successfully to $emailOrPhone');
        return true;
      } else {
        _setError(response.error ?? 'Failed to send OTP');
        _setLoading(false);
        print('❌ Failed to send OTP: ${response.error}');
        return false;
      }
    } catch (e) {
      _setError('Network error occurred. Please try again.');
      _setLoading(false);
      print('🚨 Exception in sendOtp: $e');
      return false;
    }
  }

  Future<bool> verifyOtp(String emailOrPhone, String otp) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await AuthApiService.verifyOtp(emailOrPhone, otp);
      
      if (response.success) {
        _token = response.data?['access_token']?.toString() ?? 
                response.data?['token']?.toString();
        _refreshToken = response.data?['refresh_token']?.toString();
        _userEmail = emailOrPhone;
        _isAuthenticated = true;
        
        if (response.data?['user'] != null) {
          _currentUser = Map<String, dynamic>.from(response.data!['user']);
        } else {
          print('⚠️ No user data from API, creating fallback user data');
          _currentUser = _createFallbackUserData(emailOrPhone);
        }

        _ensureUserRoles();
        
        print('✅ User authenticated successfully');
        print('🔍 User data: $_currentUser');
        print('🔍 User roles: $userRoles');
        print('🔍 Is business partner: $isBusinessPartner');
        print('🔍 User name: $userName');
        
        await _saveAuthData();
        _setLoading(false);
        return true;
      } else {
        _setError(response.error ?? 'Invalid OTP. Please try again.');
        _setLoading(false);
        print('❌ OTP verification failed: ${response.error}');
        return false;
      }
    } catch (e) {
      _setError('Network error occurred. Please try again.');
      _setLoading(false);
      print('🚨 Exception in verifyOtp: $e');
      return false;
    }
  }

  void _ensureUserRoles() {
    if (_currentUser != null) {
      final roles = _currentUser!['roles'];
      
      if (roles == null || 
          (roles is List && roles.isEmpty) ||
          (roles is String && roles.trim().isEmpty)) {
        
        print('⚠️ No roles found in user data, assigning default business partner role');
        _currentUser!['roles'] = [2];
      }
    }
  }

  Map<String, dynamic> _createFallbackUserData(String email) {
    final emailUsername = email.contains('@') ? email.split('@')[0] : 'User';
    final nameParts = emailUsername.split('.');
    
    return {
      'id': DateTime.now().millisecondsSinceEpoch,
      'email': email,
      'first_name': nameParts.isNotEmpty 
          ? _capitalize(nameParts[0]) 
          : 'Business',
      'last_name': nameParts.length > 1 
          ? _capitalize(nameParts[1]) 
          : 'Partner',
      'roles': [2],
      'is_active': true,
      'phone': '',
      'image_url': null,
      'created_at': DateTime.now().toIso8601String(),
    };
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  Future<void> logout() async {
    try {
      if (_token != null) {
        await AuthApiService.logout(_token!);
        print('✅ Logout API called successfully');
      }
    } catch (e) {
      print('⚠️ Logout API call failed: $e');
    }
    
    _isAuthenticated = false;
    _token = null;
    _refreshToken = null;
    _userEmail = null;
    _currentUser = null;
    _errorMessage = null;
    
    await _clearAuthData();
    
    print('✅ User logged out successfully');
    notifyListeners();
  }

  /// **DATA PERSISTENCE**

  Future<void> _saveAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      if (_token != null) {
        await prefs.setString('auth_token', _token!);
      }
      
      if (_refreshToken != null) {
        await prefs.setString('refresh_token', _refreshToken!);
      }
      
      if (_userEmail != null) {
        await prefs.setString('user_email', _userEmail!);
      }
      
      if (_currentUser != null) {
        await prefs.setString('current_user', jsonEncode(_currentUser!));
      }
      
      await prefs.setBool('is_authenticated', _isAuthenticated);
      await prefs.setString('last_login', DateTime.now().toIso8601String());
      
      print('✅ Auth data saved to local storage');
    } catch (e) {
      print('⚠️ Failed to save auth data: $e');
    }
  }

  Future<void> loadAuthData() async {
    _setLoading(true);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      _token = prefs.getString('auth_token');
      _refreshToken = prefs.getString('refresh_token');
      _userEmail = prefs.getString('user_email');
      _isAuthenticated = prefs.getBool('is_authenticated') ?? false;
      
      final userDataString = prefs.getString('current_user');
      if (userDataString != null && userDataString.isNotEmpty) {
        _currentUser = jsonDecode(userDataString);
      }
      
      if (_isAuthenticated && (_token == null || _userEmail == null)) {
        print('⚠️ Invalid auth data found, clearing...');
        await logout();
      } else if (_isAuthenticated) {
        print('✅ Auth data loaded successfully for ${_userEmail}');
        print('🔍 User roles: $userRoles');
        print('🔍 Is business partner: $isBusinessPartner');
      }
      
    } catch (e) {
      print('⚠️ Error loading auth data: $e');
      await _clearAuthData();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _clearAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.remove('auth_token');
      await prefs.remove('refresh_token');
      await prefs.remove('user_email');
      await prefs.remove('current_user');
      await prefs.remove('is_authenticated');
      await prefs.remove('last_login');
      
      print('✅ Auth data cleared from local storage');
    } catch (e) {
      print('⚠️ Error clearing auth data: $e');
    }
  }

  /// **USER DATA MANAGEMENT**

  Future<void> updateUserData(Map<String, dynamic> userData) async {
    _currentUser = Map<String, dynamic>.from(userData);
    await _saveAuthData();
    notifyListeners();
    print('✅ User data updated');
  }

  Future<void> updateUserField(String key, dynamic value) async {
    if (_currentUser != null) {
      _currentUser![key] = value;
      await _saveAuthData();
      notifyListeners();
      print('✅ User field $key updated');
    }
  }

  Future<bool> refreshUserData() async {
    if (!_isAuthenticated || _token == null) {
      return false;
    }

    try {
      // You can implement this if you have a user profile API endpoint
      // final response = await AuthApiService.getUserProfile(_token!);
      // if (response.success) {
      //   _currentUser = response.data;
      //   await _saveAuthData();
      //   notifyListeners();
      //   return true;
      // }
    } catch (e) {
      print('⚠️ Error refreshing user data: $e');
    }
    
    return false;
  }

  /// **TOKEN MANAGEMENT**

  bool get isTokenExpired {
    return _token == null;
  }

  // **RENAMED: from refreshToken() to refreshAuthToken()**
  Future<bool> refreshAuthToken() async {
    if (_refreshToken == null) {
      return false;
    }

    try {
      // Implement token refresh API call
      // final response = await AuthApiService.refreshToken(_refreshToken!);
      // if (response.success) {
      //   _token = response.data['access_token'];
      //   await _saveAuthData();
      //   return true;
      // }
    } catch (e) {
      print('⚠️ Error refreshing token: $e');
    }
    
    return false;
  }

  /// **UTILITY METHODS**

  String getUserDebugInfo() {
    return '''
==========================================
🔍 USER DEBUG INFORMATION
==========================================
User ID: $userId
Name: $userName
First Name: $userFirstName
Last Name: $userLastName
Email: ${_userEmail ?? 'N/A'}
Phone: ${userPhone.isNotEmpty ? userPhone : 'N/A'}
Profile Picture: ${userProfilePicture ?? 'N/A'}
Roles: $userRoles
Is Business Partner: $isBusinessPartner
Is Admin: $isAdmin
Is End User: $isEndUser
Is Active: $isUserActive
Is Authenticated: $isAuthenticated
Token Exists: ${_token != null}
==========================================
''';
  }

  void printDebugInfo() {
    print(getUserDebugInfo());
  }
}
