import 'package:business_partner_main/views/dashboard/dashboard_screen.dart';
import 'package:business_partner_main/views/products/products_screen.dart';
import 'package:business_partner_main/views/products/search_suggestion_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart'; 

// Updated imports for API integration
import 'providers/auth_provider.dart';
import 'viewmodels/auth/login_viewmodel.dart';

// Core screens
import 'views/splash/splash_screen.dart';
import 'views/auth/login_screen.dart';
import 'views/auth/forgot_password_screen.dart';
import 'views/auth/reset_password_screen.dart';

// Resources and services
import 'resources/themes/app_theme.dart';
import 'services/navigation_service.dart';

// Profile screens
import 'package:business_partner_main/views/profile/profile_screen.dart';
import 'package:business_partner_main/views/profile/edit_profile_screen.dart';

// Settings screens
import 'views/settings/settings_screen.dart';
import 'views/settings/language_selection_screen.dart';
import 'views/settings/business_hours_screen.dart';
import 'views/settings/privacy_policy_screen.dart';
import 'views/settings/terms_conditions_screen.dart';
import 'views/settings/help_support_screen.dart';
import 'views/settings/troubleshooting_screen.dart';
import 'views/settings/contact_us_screen.dart';
import 'views/settings/about_app_screen.dart';

// Customer screens
import 'views/customers/customers_list_screen.dart';
import 'views/customers/customer_detail_screen.dart';
import 'views/customers/customer_wishlist_screen.dart';

void main() {
  // Ensure Flutter framework is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return MultiProvider(
      providers: [
        // Auth Provider for API authentication
        ChangeNotifierProvider(
          create: (context) => AuthProvider()..loadAuthData(),
        ),
        
        // Login ViewModel with dependency injection
        ChangeNotifierProvider(
          create: (context) => LoginViewModel(NavigationService()),
        ),
        
        // Add more providers as your app grows
        // ChangeNotifierProvider(
        //   create: (context) => ProductsProvider(),
        // ),
        // ChangeNotifierProvider(
        //   create: (context) => CustomersProvider(),
        // ),
        // ChangeNotifierProvider(
        //   create: (context) => ProfileProvider(),
        // ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            title: 'Business Partner',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            navigatorKey: NavigationService.navigatorKey,
            
            // Dynamic initial route based on authentication state
            home: AuthWrapper(),
            
            routes: {
              // Authentication routes
              '/splash': (context) => const SplashScreen(),
              '/login': (context) => const LoginScreen(),
              '/forgot-password': (context) => const ForgotPasswordScreen(),
              '/reset-password': (context) => const ResetPasswordScreen(),
              
              // Main app routes (require authentication)
              '/dashboard': (context) => const AuthenticatedRoute(
                child: DashboardScreen(),
              ),
              '/products': (context) => const AuthenticatedRoute(
                child: ProductsScreen(),
              ),
              '/search': (context) => const AuthenticatedRoute(
                child: SearchSuggestionScreen(),
              ),
              
              // Profile routes
              '/profile': (context) => const AuthenticatedRoute(
                child: ProfileScreen(),
              ),
              '/edit-profile': (context) => const AuthenticatedRoute(
                child: EditProfileScreen(),
              ),
              
              // Settings routes
              '/settings': (context) => AuthenticatedRoute(
                child: SettingsScreen(),
              ),
              '/settings/language': (context) => AuthenticatedRoute(
                child: LanguageSelectionScreen(),
              ),
              '/settings/business-hours': (context) => AuthenticatedRoute(
                child: BusinessHoursScreen(),
              ),
              '/settings/privacy-policy': (context) => AuthenticatedRoute(
                child: PrivacyPolicyScreen(),
              ),
              '/settings/terms-conditions': (context) => AuthenticatedRoute(
                child: TermsConditionsScreen(),
              ),
              '/settings/help-support': (context) => AuthenticatedRoute(
                child: HelpSupportScreen(),
              ),
              '/settings/troubleshooting': (context) => AuthenticatedRoute(
                child: TroubleshootingScreen(),
              ),
              '/settings/contact-us': (context) => AuthenticatedRoute(
                child: ContactUsScreen(),
              ),
              '/settings/about-app': (context) => AuthenticatedRoute(
                child: AboutAppScreen(),
              ),
              
              // Customer routes
              '/customers': (context) => AuthenticatedRoute(
                child: CustomersListScreen(),
              ),
              '/customers/detail': (context) => AuthenticatedRoute(
                child: CustomerDetailScreen(customerData: {}),
              ),
              '/customers/wishlist': (context) => AuthenticatedRoute(
                child: CustomerWishlistScreen(customerData: {}),
              ),
            },
            
            // Handle unknown routes
            onUnknownRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => const SplashScreen(),
              );
            },
          );
        },
      ),
    );
  }
}

// Auth Wrapper to handle initial routing
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    
    // Load authentication data when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.loadAuthData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Show splash screen while loading
        if (authProvider.isLoading) {
          return const SplashScreen();
        }
        
        // Navigate based on authentication state
        if (authProvider.isAuthenticated) {
          return const DashboardScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}

// Wrapper for authenticated routes
class AuthenticatedRoute extends StatelessWidget {
  final Widget child;
  
  const AuthenticatedRoute({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (!authProvider.isAuthenticated) {
          // Redirect to login if not authenticated
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed('/login');
          });
          return const SplashScreen(); // Show loading while redirecting
        }
        
        return child;
      },
    );
  }
}

// Extension for easy navigation with authentication check
extension NavigationExtension on BuildContext {
  void pushAuthenticatedRoute(String routeName, {Object? arguments}) {
    final authProvider = Provider.of<AuthProvider>(this, listen: false);
    
    if (authProvider.isAuthenticated) {
      Navigator.of(this).pushNamed(routeName, arguments: arguments);
    } else {
      Navigator.of(this).pushReplacementNamed('/login');
    }
  }
  
  void pushReplacementAuthenticatedRoute(String routeName, {Object? arguments}) {
    final authProvider = Provider.of<AuthProvider>(this, listen: false);
    
    if (authProvider.isAuthenticated) {
      Navigator.of(this).pushReplacementNamed(routeName, arguments: arguments);
    } else {
      Navigator.of(this).pushReplacementNamed('/login');
    }
  }
}
