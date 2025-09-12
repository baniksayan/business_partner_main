import 'package:flutter/material.dart';
import '../../core/base/base_view_model.dart';
import '../../core/enums/view_state.dart';

class ProfileViewModel extends BaseViewModel {
  // User data - you can modify this to fetch from your actual data source
  String _userName = 'Sayan Banik';
  String _userEmail = 'sayan.banik@email.com';
  String _userPhone = '8768412832'; // Store without +91
  String _userRole = 'Business Owner';
  String _companyName = 'Tech Solutions Inc.';
  String _companyCategory = 'Technology';
  String _profileImagePath = 'assets/images/profile.png';

  // Getters
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userPhone => _userPhone;
  String get formattedPhone => '+91 $_userPhone'; // Format for display
  String get userRole => _userRole;
  String get companyName => _companyName;
  String get companyCategory => _companyCategory;
  String get profileImagePath => _profileImagePath;

  // Initialize profile data
  Future<void> loadProfileData() async {
    setState(ViewState.busy);
    
    try {
      // Simulate API call or local storage fetch
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Here you would typically fetch from SharedPreferences, API, etc.
      // For now, using static data matching your screenshot
      
      setState(ViewState.idle);
    } catch (e) {
      setError('Failed to load profile data');
    }
  }

  // Update profile data
  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
  }) async {
    setState(ViewState.busy);
    
    try {
      if (name != null && name.isNotEmpty) _userName = name;
      if (email != null && email.isNotEmpty) _userEmail = email;
      if (phone != null && phone.isNotEmpty) _userPhone = phone;
      
      // Here you would save to SharedPreferences, API, etc.
      await Future.delayed(const Duration(milliseconds: 800));
      
      setState(ViewState.idle);
    } catch (e) {
      setError('Failed to update profile');
    }
  }

  // Update profile image
  Future<void> updateProfileImage(String imagePath) async {
    setState(ViewState.busy);
    
    try {
      _profileImagePath = imagePath;
      // Here you would upload to server/storage
      await Future.delayed(const Duration(milliseconds: 500));
      setState(ViewState.idle);
    } catch (e) {
      setError('Failed to update profile image');
    }
  }

  // Handle logout
  Future<void> logout() async {
    setState(ViewState.busy);
    
    try {
      // Clear user data, tokens, etc.
      await Future.delayed(const Duration(milliseconds: 500));
      setState(ViewState.idle);
    } catch (e) {
      setError('Failed to logout');
    }
  }

  // Validate phone number
  bool isValidPhone(String phone) {
    if (phone.length != 10) return false;
    final firstDigit = phone[0];
    return ['6', '7', '8', '9'].contains(firstDigit);
  }

  // Validate email
  bool isValidEmail(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }
}
