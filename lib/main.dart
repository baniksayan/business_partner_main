import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'views/splash/splash_screen.dart';
import 'resources/themes/app_theme.dart';
import 'services/navigation_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return MaterialApp(
      title: 'Business Partner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      navigatorKey: NavigationService.navigatorKey,
      home: const SplashScreen(),
      routes: {
        '/splash': (context) => const SplashScreen(),
        // '/login': (context) => const Placeholder(), // Replace with LoginScreen
        // '/dashboard': (context) => const Placeholder(), // Replace with DashboardScreen
      },
    );
  }
}
