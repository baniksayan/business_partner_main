import 'package:flutter/material.dart';
import '../colors/app_colors.dart';
import 'light_theme.dart';

class AppTheme {
  static ThemeData get lightTheme => LightTheme.theme;
  
  static ThemeData get darkTheme => ThemeData.dark().copyWith(
    primaryColor: AppColors.splashPrimary,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.splashPrimary,
      secondary: AppColors.splashSecondary,
    ),
  );
}
