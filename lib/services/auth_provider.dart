// lib/services/auth_provider.dart
import 'package:flutter/material.dart';
import 'token_helper.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _token;
  String? _userEmail;
  String? _errorMessage;

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get token => _token;
  String? get userEmail => _userEmail;
  String? get errorMessage => _errorMessage;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Load authentication data on app start
  Future<void> loadAuthData() async {
    setLoading(true);
    try {
      _token = await TokenHelper.getToken();
      _userEmail = await TokenHelper.getUserEmail();
      _isAuthenticated = await TokenHelper.isAuthenticated();
    } catch (e) {
      await clearAuthData();
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  // Clear all authentication data
  Future<void> clearAuthData() async {
    await TokenHelper.clearAllTokens();
    _isAuthenticated = false;
    _token = null;
    _userEmail = null;
    _errorMessage = null;
    notifyListeners();
  }

  // Logout
  Future<void> logout() async {
    await clearAuthData();
  }

  // Set authentication data (call this after successful login)
  Future<void> setAuthData({
    required String token,
    String? refreshToken,
    required String email,
  }) async {
    await TokenHelper.saveToken(token);
    if (refreshToken != null) {
      await TokenHelper.saveRefreshToken(refreshToken);
    }
    await TokenHelper.saveUserEmail(email);

    _token = token;
    _userEmail = email;
    _isAuthenticated = true;
    _errorMessage = null;
    
    notifyListeners();
  }
}
