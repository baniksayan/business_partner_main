import '../../core/base/base_view_model.dart';
import '../../core/enums/view_state.dart';
import '../../data/models/request/login_request.dart';
import '../../services/navigation_service.dart';
import '../../services/api_service.dart';
import '../../services/storage_service.dart';
import '../../data/models/user_model.dart';

class LoginViewModel extends BaseViewModel {
  final NavigationService _navigationService;

  LoginViewModel(this._navigationService);

  // Mock sendOtp method (no real OTP generation)
  Future<void> sendOtp(String emailOrPhone) async {
    if (emailOrPhone.isEmpty) {
      setError('Please enter your email or phone number');
      return;
    }

    // Basic validation for email or phone format
    bool isValidEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailOrPhone);
    bool isValidPhone = RegExp(r'^[+]?[0-9]{10,15}$').hasMatch(emailOrPhone);
    
    if (!isValidEmail && !isValidPhone) {
      setError('Please enter a valid email or phone number');
      return;
    }

    setState(ViewState.busy);

    try {
      // Simulate API delay (no actual OTP generation)
      await Future.delayed(Duration(seconds: 2));
      
      // Mock success response
      setMessage('Ready to verify! Use any 6-digit code.');
      
    } catch (e) {
      setError('An unexpected error occurred: ${e.toString()}');
    } finally {
      setState(ViewState.idle);
    }
  }

  // Mock verifyOtp method (accepts any 6-digit code)
  Future<void> verifyOtp(String emailOrPhone, String otpCode) async {
    if (otpCode.isEmpty || otpCode.length != 6) {
      setError('Please enter a valid 6-digit OTP');
      return;
    }

    setState(ViewState.busy);

    try {
      // Simulate API delay
      await Future.delayed(Duration(seconds: 2));
      
      // Accept any 6-digit OTP (no validation)
      setMessage('Login successful!');
      
      // Navigate to dashboard
      await _navigationService.navigateToAndClearStack('/dashboard');
      
    } catch (e) {
      setError('An unexpected error occurred: ${e.toString()}');
    } finally {
      setState(ViewState.idle);
    }
  }

  // Your existing login method (if needed)
  Future<void> login(String emailOrPhone, String password) async {
    if (emailOrPhone.isEmpty || password.isEmpty) {
      setError('Please enter both email/phone and password');
      return;
    }

    setState(ViewState.busy);

    try {
      final loginRequest = LoginRequest(
        emailOrPhone: emailOrPhone.trim(),
        password: password,
      );

      final response = await ApiService.login(loginRequest);
      
      if (response.isSuccess) {
        if (response.data != null) {
          final user = UserModel.fromJson(response.data);
          await StorageService.saveUser(user);
          await _navigationService.navigateToAndClearStack('/dashboard');
          setMessage('Login successful!');
        } else {
          setError('Login successful but no user data received');
        }
      } else {
        String errorMessage = response.message ?? 'Login failed';
        
        switch (response.statusCode) {
          case 'E-401':
            errorMessage = 'Invalid email/phone or password. Please try again.';
            break;
          case 'E-404':
            errorMessage = 'No account found with this email/phone.';
            break;
          case 'E-NETWORK':
            errorMessage = 'Network error. Please check your internet connection.';
            break;
          default:
            errorMessage = 'Login failed. Please try again later.';
        }
        
        setError(errorMessage);
      }
      
    } catch (e) {
      setError('An unexpected error occurred: ${e.toString()}');
    } finally {
      setState(ViewState.idle);
    }
  }

  void navigateToForgotPassword() {
    _navigationService.navigateTo('/forgot-password');
  }

  void navigateToSignUp() {
    _navigationService.navigateTo('/signup');
  }
}
