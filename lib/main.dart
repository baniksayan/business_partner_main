import 'package:business_partner_main/views/dashboard/dashboard_screen.dart';
import 'package:business_partner_main/views/products/products_screen.dart';
import 'package:business_partner_main/views/products/search_suggestion_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart'; 
 
import 'viewmodels/auth/login_viewmodel.dart';

import 'views/splash/splash_screen.dart';
import 'views/auth/login_screen.dart';
import 'views/auth/forgot_password_screen.dart';
import 'views/auth/reset_password_screen.dart';
import 'resources/themes/app_theme.dart';
import 'services/navigation_service.dart';

import 'package:business_partner_main/views/profile/profile_screen.dart';
import 'package:business_partner_main/views/profile/edit_profile_screen.dart';
import 'views/settings/settings_screen.dart';
import 'views/settings/language_selection_screen.dart';
import 'views/settings/business_hours_screen.dart';
import 'views/settings/privacy_policy_screen.dart';
import 'views/settings/terms_conditions_screen.dart';
import 'views/settings/help_support_screen.dart';
import 'views/settings/troubleshooting_screen.dart';
import 'views/settings/contact_us_screen.dart';
import 'views/settings/about_app_screen.dart';
import 'views/customers/customers_list_screen.dart';
import 'views/customers/customer_detail_screen.dart';
import 'views/customers/customer_wishlist_screen.dart';

void main() {
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

    return MultiProvider( // Wrap with MultiProvider
      providers: [
        // Add your providers here
        ChangeNotifierProvider(
          create: (context) => LoginViewModel(NavigationService()),
        ),
        // Add more providers as needed
        // ChangeNotifierProvider(
        //   create: (context) => DashboardViewModel(),
        // ),
        // ChangeNotifierProvider(
        //   create: (context) => ProfileViewModel(),
        // ),
      ],
      child: MaterialApp(
        title: 'Business Partner',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        navigatorKey: NavigationService.navigatorKey, // Make sure this is static
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/login': (context) =>  LoginScreen(), // Add const here
          '/forgot-password': (context) => const ForgotPasswordScreen(),
          '/reset-password': (context) => const ResetPasswordScreen(),
          '/dashboard': (context) => const DashboardScreen(),
          '/products': (context) => const ProductsScreen(),
          '/search': (context) => const SearchSuggestionScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/edit-profile': (context) => const EditProfileScreen(),
          '/settings': (context) => SettingsScreen(),
          '/settings/language': (context) => LanguageSelectionScreen(),
          '/settings/business-hours': (context) => BusinessHoursScreen(),
          '/settings/privacy-policy': (context) => PrivacyPolicyScreen(),
          '/settings/terms-conditions': (context) => TermsConditionsScreen(),
          '/settings/help-support': (context) => HelpSupportScreen(),
          '/settings/troubleshooting': (context) => TroubleshootingScreen(),
          '/settings/contact-us': (context) => ContactUsScreen(),
          '/settings/about-app': (context) => AboutAppScreen(),
          '/customers': (context) => CustomersListScreen(),
          '/customers/detail': (context) => CustomerDetailScreen(customerData: {}),
          '/customers/wishlist': (context) => CustomerWishlistScreen(customerData: {}),
        },
      ),
    );
  }
}
