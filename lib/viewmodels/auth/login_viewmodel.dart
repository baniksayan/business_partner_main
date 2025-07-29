import 'package:flutter/material.dart';
import '../../core/base/base_view_model.dart';
import '../../core/enums/view_state.dart';
import '../../data/models/request/login_request.dart';
import '../../services/navigation_service.dart';

class LoginViewModel extends BaseViewModel {
  final NavigationService _navigationService;

  LoginViewModel(this._navigationService);

  Future<void> login(String emailOrPhone, String password) async {
    setState(ViewState.busy);

    try {
      final loginRequest = LoginRequest(
        emailOrPhone: emailOrPhone,
        password: password,
      );

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // If successful, navigate to dashboard
      await _navigationService.navigateToAndClearStack('/dashboard');
      
      setState(ViewState.idle);
    } catch (e) {
      setError('Login failed: ${e.toString()}');
    }
  }

  void navigateToForgotPassword() {
    _navigationService.navigateTo('/forgot-password');
  }
}
