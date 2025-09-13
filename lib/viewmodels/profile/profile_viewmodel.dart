// lib/viewmodels/profile/profile_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ProfileViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  // User data
  String _userName = '';
  String _userEmail = '';
  String _userPhone = '';
  String _userRole = '';
  String? _userProfilePicture;
  String _businessName = '';
  String _businessCategory = '';

  // Getters
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userPhone => _userPhone;
  String get userRole => _userRole;
  String? get userProfilePicture => _userProfilePicture;
  String get businessName => _businessName;
  String get businessCategory => _businessCategory;

  void loadProfileData() {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      // Simulate loading delay
      Future.delayed(const Duration(seconds: 1), () {
        // Mock user data - replace with actual data from AuthProvider
        _userName = 'John Doe';
        _userEmail = 'john.doe@example.com';
        _userPhone = '+1 234 567 8900';
        _userRole = 'Business Partner';
        _userProfilePicture = null;
        _businessName = 'Doe Enterprises';
        _businessCategory = 'Technology Solutions';

        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _errorMessage = 'Failed to load profile data';
      notifyListeners();
    }
  }

  void updateProfile({
    String? name,
    String? phone,
    String? businessName,
    String? businessCategory,
  }) {
    if (name != null) _userName = name;
    if (phone != null) _userPhone = phone;
    if (businessName != null) _businessName = businessName;
    if (businessCategory != null) _businessCategory = businessCategory;
    notifyListeners();
  }
}
