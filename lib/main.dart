// lib/main.dart - FIXED VERSION WITH CUSTOMER SCREEN METHODS
import 'package:business_partner_main/providers/business_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart'; 

// Updated imports for API integration
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/customer_provider.dart';
import 'viewmodels/auth/login_viewmodel.dart';

// Core screens
import 'views/splash/splash_screen.dart';
import 'views/auth/login_screen.dart';
import 'views/auth/forgot_password_screen.dart';
import 'views/auth/reset_password_screen.dart';

// Main app screens
import 'views/dashboard/dashboard_screen.dart';
import 'views/profile/profile_screen.dart';
import 'views/bookings/bookings_screen.dart';
import 'views/bookings/booking_details_screen.dart';
import 'views/bookings/reschedule_booking_screen.dart';
import 'views/products/products_screen.dart';
import 'views/products/search_suggestion_screen.dart';
import 'views/notifications/notifications_screen.dart';

//business screens
import 'views/business/business_dashboard_screen.dart';
import 'views/business/business_info_screen.dart';
import 'views/business/business_analytics_screen.dart';
import 'views/business/business_settings_screen.dart';
import 'views/business/business_performance_screen.dart';
import 'views/business/business_reports_screen.dart';



// Settings screens
import 'views/settings/settings_screen.dart'; 
import 'views/settings/business_hours_screen.dart';
import 'views/settings/privacy_policy_screen.dart';
import 'views/settings/terms_conditions_screen.dart';
import 'views/settings/help_support_screen.dart';
import 'views/settings/troubleshooting_screen.dart';
import 'views/settings/contact_us_screen.dart';
import 'views/settings/about_app_screen.dart';

// Customer screens - ✅ FIXED: Uncommented and added proper imports
import 'views/customers/customers_list_screen.dart';
import 'views/customers/customer_detail_screen.dart';
import 'views/customers/customer_wishlist_screen.dart';
import 'models/customer.dart'; // ✅ ADDED: Import Customer model

// Resources and services
import 'resources/themes/app_theme.dart';
import 'services/navigation_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  print('🚀 [Main] Starting Business Partner App...');
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
        // ✅ Auth Provider - handles authentication
        ChangeNotifierProvider(
          create: (context) {
            print('🔐 [Main] Creating AuthProvider...');
            return AuthProvider()..loadAuthData();
          },
        ),
        
        // ✅ Login ViewModel
        ChangeNotifierProvider(
          create: (context) {
            print('🔑 [Main] Creating LoginViewModel...');
            return LoginViewModel(NavigationService());
          },
        ),
        
        // ✅ Customer Provider - handles customers
        ChangeNotifierProvider(
          create: (context) {
            print('👥 [Main] Creating CustomerProvider...');
            return CustomerProvider();
          },
        ),
        
        // ✅ Product Provider - handles products
        ChangeNotifierProvider(
          create: (context) {
            print('📦 [Main] Creating ProductProvider...');
            return ProductProvider();
          },
        ),
        
        // ✅ Booking Provider - handles bookings
        ChangeNotifierProvider(
          create: (context) {
            print('📅 [Main] Creating BookingProvider...');
            return BookingProvider();
          },
        ),
        ChangeNotifierProvider(
        create: (context) {
          print('🏢 [Main] Creating BusinessProvider...');
          return BusinessProvider();
        },
      ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            title: 'Business Partner',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            navigatorKey: NavigationService.navigatorKey,
            
            home: const AuthWrapper(),
            
            routes: _buildAllRoutes(),
            
            onUnknownRoute: (settings) {
              print('❓ [Main] Unknown route: ${settings.name}');
              return MaterialPageRoute(
                builder: (context) => const SplashScreen(),
              );
            },
          );
        },
      ),
    );
  }

  // ✅ Complete route configuration with error handling
  Map<String, WidgetBuilder> _buildAllRoutes() {
    return {
      // ============ AUTHENTICATION ROUTES ============
      '/splash': (context) => const SplashScreen(),
      '/login': (context) => const LoginScreen(),
      '/forgot-password': (context) => const ForgotPasswordScreen(),
      '/reset-password': (context) => const ResetPasswordScreen(),
      
      // ============ MAIN APP ROUTES ============
      '/dashboard': (context) => const AuthenticatedRoute(
        child: DashboardScreen(),
      ),
      
      // ============ PRODUCT ROUTES ============
      '/products': (context) => const AuthenticatedRoute(
        child: ProductsScreen(),
      ),
      '/search': (context) => const AuthenticatedRoute(
        child: SearchSuggestionScreen(),
      ),
      
      // ============ BOOKING ROUTES ============
      '/bookings': (context) => AuthenticatedRoute(
        child: BookingsScreen(),
      ),
      '/booking-details': (context) => AuthenticatedRoute(
        child: _buildBookingDetailsScreen(context),
      ),
      '/reschedule-booking': (context) => AuthenticatedRoute(
        child: _buildRescheduleBookingScreen(context),
      ),
      
      // ============ PROFILE ROUTES ============
      '/profile': (context) => const AuthenticatedRoute(
        child: ProfileScreen(),
      ),
      
      // ============ NOTIFICATION ROUTES ============
      // '/notifications': (context) => const AuthenticatedRoute(
      //   child: NotificationsScreen(),
      // ),
      
      // ============ SETTINGS ROUTES ============
      '/settings': (context) => const AuthenticatedRoute(
        child: SettingsScreen(),
      ),
      '/settings/business-hours': (context) => const AuthenticatedRoute(
        child: BusinessHoursScreen(),
      ),
      '/settings/privacy-policy': (context) => const AuthenticatedRoute(
        child: PrivacyPolicyScreen(),
      ),
      '/settings/terms-conditions': (context) => const AuthenticatedRoute(
        child: TermsConditionsScreen(),
      ),
      '/settings/help-support': (context) => const AuthenticatedRoute(
        child: HelpSupportScreen(),
      ),
      '/settings/troubleshooting': (context) => const AuthenticatedRoute(
        child: TroubleshootingScreen(),
      ),
      '/settings/contact-us': (context) => const AuthenticatedRoute(
        child: ContactUsScreen(),
      ),
      '/settings/about-app': (context) => const AuthenticatedRoute(
        child: AboutAppScreen(),
      ),
      
      // ============ CUSTOMER ROUTES ============
      '/customers': (context) => const AuthenticatedRoute(
        child: CustomersListScreen(),
      ),
      '/customer-details': (context) => AuthenticatedRoute(
        child: _buildCustomerDetailsScreen(context),
      ),
      '/customer-wishlist': (context) => AuthenticatedRoute(
        child: _buildCustomerWishlistScreen(context),
      ),

      '/business-dashboard': (context) => const AuthenticatedRoute(  // ✅ ADD THIS ROUTE
          child: BusinessDashboardScreen(),
        ),
      '/business-info': (context) => const AuthenticatedRoute(
        child: BusinessInfoScreen(),
      ),
      // Add these to your routes in main.dart
      '/business-analytics': (context) => const AuthenticatedRoute(
        child: BusinessAnalyticsScreen(),
      ),
      '/business-settings': (context) => const AuthenticatedRoute(
        child: BusinessSettingsScreen(),
      ),
      // Add this to your routes in _buildAllRoutes()
    '/business-performance': (context) => const AuthenticatedRoute(
      child: BusinessPerformanceScreen(),
    ),

    '/business-reports': (context) => const AuthenticatedRoute(
        child: BusinessReportsScreen(),
      ),


    };
  }

  // ✅ Enhanced helper methods with better error handling
  Widget _buildBookingDetailsScreen(BuildContext context) {
    try {
      final args = ModalRoute.of(context)?.settings.arguments;
      
      if (args != null && args is Map<String, dynamic>) {
        print('📅 [Main] Building BookingDetailsScreen with args: ${args['id']}');
        return BookingDetailsScreen(booking: args);
      } else {
        print('⚠️ [Main] No valid arguments for BookingDetailsScreen, redirecting to BookingsScreen');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Booking details not found'),
              backgroundColor: Colors.red,
            ),
          );
        });
        return BookingsScreen();
      }
    } catch (e) {
      print('❌ [Main] Error building BookingDetailsScreen: $e');
      return BookingsScreen();
    }
  }

  Widget _buildRescheduleBookingScreen(BuildContext context) {
    try {
      final args = ModalRoute.of(context)?.settings.arguments;
      
      if (args != null && args is Map<String, dynamic>) {
        print('📅 [Main] Building RescheduleBookingScreen with args: ${args['id']}');
        return RescheduleBookingScreen(booking: args);
      } else {
        print('⚠️ [Main] No valid arguments for RescheduleBookingScreen, redirecting to BookingsScreen');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Booking not found for rescheduling'),
              backgroundColor: Colors.red,
            ),
          );
        });
        return BookingsScreen();
      }
    } catch (e) {
      print('❌ [Main] Error building RescheduleBookingScreen: $e');
      return BookingsScreen();
    }
  }

  // ✅ ADDED: Customer Details Screen Builder
  Widget _buildCustomerDetailsScreen(BuildContext context) {
    try {
      final args = ModalRoute.of(context)?.settings.arguments;
      
      if (args != null && args is Customer) {
        print('👤 [Main] Building CustomerDetailScreen with customer: ${args.id}');
        return CustomerDetailScreen(customer: args);
      } else {
        print('⚠️ [Main] No valid Customer arguments for CustomerDetailScreen, redirecting to CustomersListScreen');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Customer details not found'),
              backgroundColor: Colors.red,
            ),
          );
        });
        return const CustomersListScreen();
      }
    } catch (e) {
      print('❌ [Main] Error building CustomerDetailScreen: $e');
      return const CustomersListScreen();
    }
  }

  // ✅ ADDED: Customer Wishlist Screen Builder
  Widget _buildCustomerWishlistScreen(BuildContext context) {
    try {
      final args = ModalRoute.of(context)?.settings.arguments;
      
      if (args != null && args is Customer) {
        print('💝 [Main] Building CustomerWishlistScreen with customer: ${args.id}');
        return CustomerWishlistScreen(customer: args);
      } else {
        print('⚠️ [Main] No valid Customer arguments for CustomerWishlistScreen, redirecting to CustomersListScreen');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Customer not found for wishlist'),
              backgroundColor: Colors.red,
            ),
          );
        });
        return const CustomersListScreen();
      }
    } catch (e) {
      print('❌ [Main] Error building CustomerWishlistScreen: $e');
      return const CustomersListScreen();
    }
  }
}

// ============ AUTH WRAPPER ============
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    print('🔄 [AuthWrapper] Initializing authentication check...');
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        print('📱 [AuthWrapper] Loading auth data...');
        authProvider.loadAuthData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        print('🔍 [AuthWrapper] Auth state - Loading: ${authProvider.isLoading}, Authenticated: ${authProvider.isAuthenticated}');
        
        if (authProvider.isLoading) {
          print('⏳ [AuthWrapper] Showing splash screen (loading)');
          return const SplashScreen();
        }
        
        if (authProvider.isAuthenticated) {
          print('✅ [AuthWrapper] User authenticated - showing dashboard');
          return const DashboardScreen();
        } else {
          print('❌ [AuthWrapper] User not authenticated - showing login');
          return const LoginScreen();
        }
      },
    );
  }
}

// ============ AUTHENTICATED ROUTE WRAPPER ============
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
          print('🚫 [AuthenticatedRoute] User not authenticated - redirecting to login');
          
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (Navigator.canPop(context)) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login', 
                (route) => false,
              );
            } else {
              Navigator.of(context).pushReplacementNamed('/login');
            }
          });
          
          return const SplashScreen();
        }
        
        print('✅ [AuthenticatedRoute] User authenticated - showing ${child.runtimeType}');
        return child;
      },
    );
  }
}

// ============ ENHANCED NAVIGATION EXTENSIONS ============
extension NavigationExtension on BuildContext {
  void pushAuthenticatedRoute(String routeName, {Object? arguments}) {
    final authProvider = Provider.of<AuthProvider>(this, listen: false);
    
    print('🧭 [Navigation] Attempting to navigate to: $routeName');
    
    if (authProvider.isAuthenticated) {
      print('✅ [Navigation] User authenticated - navigating to $routeName');
      Navigator.of(this).pushNamed(routeName, arguments: arguments);
    } else {
      print('❌ [Navigation] User not authenticated - redirecting to login');
      Navigator.of(this).pushReplacementNamed('/login');
    }
  }
  
  void pushReplacementAuthenticatedRoute(String routeName, {Object? arguments}) {
    final authProvider = Provider.of<AuthProvider>(this, listen: false);
    
    print('🔄 [Navigation] Attempting to replace with: $routeName');
    
    if (authProvider.isAuthenticated) {
      print('✅ [Navigation] User authenticated - replacing with $routeName');
      Navigator.of(this).pushReplacementNamed(routeName, arguments: arguments);
    } else {
      print('❌ [Navigation] User not authenticated - redirecting to login');
      Navigator.of(this).pushReplacementNamed('/login');
    }
  }

  // ✅ Safe navigation methods
  void safeNavigate(String routeName, {Object? arguments}) {
    if (mounted) {
      pushAuthenticatedRoute(routeName, arguments: arguments);
    } else {
      print('⚠️ [Navigation] Context not mounted - skipping navigation to $routeName');
    }
  }

  void popAndPush(String routeName, {Object? arguments}) {
    if (mounted && Navigator.canPop(this)) {
      Navigator.of(this).pop();
      pushAuthenticatedRoute(routeName, arguments: arguments);
    }
  }
}

// ============ ENHANCED NAVIGATION HELPER CLASS ============
class AppNavigator {
  static final GlobalKey<NavigatorState> navigatorKey = NavigationService.navigatorKey;
  
  static BuildContext? get currentContext => navigatorKey.currentContext;
  
  // ✅ Safe navigation methods with null checks
  static void _safeNavigate(String routeName, {Object? arguments}) {
    final context = currentContext;
    if (context != null) {
      context.pushAuthenticatedRoute(routeName, arguments: arguments);
    } else {
      print('⚠️ [AppNavigator] No current context available for navigation to $routeName');
    }
  }

  static void _safeReplace(String routeName, {Object? arguments}) {
    final context = currentContext;
    if (context != null) {
      context.pushReplacementAuthenticatedRoute(routeName, arguments: arguments);
    } else {
      print('⚠️ [AppNavigator] No current context available for replacement to $routeName');
    }
  }

  /// Navigate to dashboard
  static void toDashboard() {
    print('🏠 [AppNavigator] Navigating to dashboard');
    _safeReplace('/dashboard');
  }

  static void toBusinessInfo() {
  print('🏢 [AppNavigator] Navigating to business info');
  _safeNavigate('/business-info');
}
  
// Add these to your AppNavigator class
static void toBusinessAnalytics() {
  print('📊 [AppNavigator] Navigating to business analytics');
  _safeNavigate('/business-analytics');
}

static void toBusinessDashboard() {
  print('📊 [AppNavigator] Navigating to business dashboard');
  _safeNavigate('/business-dashboard');
}
  static void toBusinessReports() {
    print('📋 [AppNavigator] Navigating to business reports');
    _safeNavigate('/business-reports');
  }
static void toBusinessSettings() {
  print('⚙️ [AppNavigator] Navigating to business settings');
  _safeNavigate('/business-settings');
}
// Add this to your AppNavigator class
static void toBusinessPerformance() {
  print('📊 [AppNavigator] Navigating to business performance');
  _safeNavigate('/business-performance');
}

  /// Navigate to products
  static void toProducts() {
    print('📦 [AppNavigator] Navigating to products');
    _safeNavigate('/products');
  }
  
  /// Navigate to bookings
  static void toBookings() {
    print('📅 [AppNavigator] Navigating to bookings');
    _safeNavigate('/bookings');
  }
  
  /// Navigate to booking details
  static void toBookingDetails(Map<String, dynamic> booking) {
    print('📅 [AppNavigator] Navigating to booking details: ${booking['id']}');
    _safeNavigate('/booking-details', arguments: booking);
  }
  
  /// Navigate to reschedule booking
  static void toRescheduleBooking(Map<String, dynamic> booking) {
    print('📅 [AppNavigator] Navigating to reschedule booking: ${booking['id']}');
    _safeNavigate('/reschedule-booking', arguments: booking);
  }
  
  /// Navigate to profile
  static void toProfile() {
    print('👤 [AppNavigator] Navigating to profile');
    _safeNavigate('/profile');
  }
  
  /// Navigate to settings
  static void toSettings() {
    print('⚙️ [AppNavigator] Navigating to settings');
    _safeNavigate('/settings');
  }
  
  /// Navigate to customers
  static void toCustomers() {
    print('👥 [AppNavigator] Navigating to customers');
    _safeNavigate('/customers');
  }
  
  /// Navigate to customer details
  static void toCustomerDetails(Customer customer) {
    print('👤 [AppNavigator] Navigating to customer details: ${customer.id}');
    _safeNavigate('/customer-details', arguments: customer);
  }
  
  /// Navigate to customer wishlist
  static void toCustomerWishlist(Customer customer) {
    print('💝 [AppNavigator] Navigating to customer wishlist: ${customer.id}');
    _safeNavigate('/customer-wishlist', arguments: customer);
  }
  
  /// Navigate to notifications
  static void toNotifications() {
    print('🔔 [AppNavigator] Navigating to notifications');
    _safeNavigate('/notifications');
  }
  
  /// Logout and go to login
  static void toLogin() {
    print('🚪 [AppNavigator] Logging out and going to login');
    final navigator = navigatorKey.currentState;
    if (navigator != null) {
      navigator.pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }
}
