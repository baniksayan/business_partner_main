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
