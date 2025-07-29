import '../core/base/base_view_model.dart';
import '../core/enums/view_state.dart';
import '../services/navigation_service.dart';

class SplashViewModel extends BaseViewModel {
  final NavigationService _navigationService;

  SplashViewModel(this._navigationService);

  Future<void> initializeApp() async {
    setState(ViewState.busy);
    
    try {
      // Simulate app initialization
      await Future.delayed(const Duration(milliseconds: 3000));
      
      // Check if user is logged in
      bool isLoggedIn = await _checkLoginStatus();
      
      // Navigate based on login status
      if (isLoggedIn) {
        await _navigationService.navigateToAndClearStack('/dashboard');
      } else {
        await _navigationService.navigateToAndClearStack('/login');
      }
      
      setState(ViewState.idle);
    } catch (e) {
      setError('Failed to initialize app: ${e.toString()}');
    }
  }

  Future<bool> _checkLoginStatus() async {
    // Add your login check logic here
    // Example: check secure storage for auth token
    return false; // Default to not logged in
  }
}
