import 'package:flutter/material.dart';
import '../colors/app_colors.dart';

class LightTheme {
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    primarySwatch: Colors.pink,
    primaryColor: AppColors.splashPrimary,
    scaffoldBackgroundColor: AppColors.splashBackground,
    fontFamily: 'SF Pro Display',
    
    colorScheme: const ColorScheme.light(
      primary: AppColors.splashPrimary,
      secondary: AppColors.splashSecondary,
      surface: Colors.white,
      background: AppColors.splashBackground,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AppColors.splashText,
      onBackground: AppColors.splashText,
    ),
    
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: AppColors.splashText,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.splashText,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.splashPrimary,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: AppColors.splashText,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: AppColors.splashText,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        color: AppColors.splashText,
        fontSize: 16,
      ),
      bodyMedium: TextStyle(
        color: AppColors.splashSubtext,
        fontSize: 14,
      ),
    ),
  );
}
