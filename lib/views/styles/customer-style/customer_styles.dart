import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../app_text_styles.dart';

class CustomerStyles {
  // Enhanced customer card styling with better shadows and modern appearance
  static BoxDecoration customerCardDecoration = BoxDecoration(
    color: AppColors.cardColor,
    borderRadius: BorderRadius.circular(20.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 12,
        offset: Offset(0, 4),
        spreadRadius: 1,
      ),
      BoxShadow(
        color: Colors.black.withOpacity(0.02),
        blurRadius: 6,
        offset: Offset(0, 2),
      ),
    ],
  );

  // Modern avatar styling with enhanced shadows
  static BoxDecoration avatarDecoration = BoxDecoration(
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(
        color: AppColors.primaryColor.withOpacity(0.15),
        blurRadius: 12,
        offset: Offset(0, 4),
        spreadRadius: 2,
      ),
    ],
  );

  // Enhanced customer status colors with better contrast
  static const Color frequentCustomerColor = Color(0xFF9C7CE8);
  static const Color vipCustomerColor = Color(0xFFFFB020);
  static const Color regularCustomerColor = Color(0xFF8E8E93);
  static const Color premiumCustomerColor = Color(0xFF34C759);

  // Modern search bar styling
  static InputDecoration searchInputDecoration = InputDecoration(
    hintText: 'Search customers by name, phone...',
    hintStyle: AppTextStyles.captionText.copyWith(
      fontSize: 15,
      fontWeight: FontWeight.w400,
    ),
    prefixIcon: Container(
      padding: EdgeInsets.all(12),
      child: Icon(
        Icons.search_rounded,
        color: AppColors.greyColor,
        size: 22,
      ),
    ),
    filled: true,
    fillColor: AppColors.cardColor,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.0),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.0),
      borderSide: BorderSide(color: AppColors.dividerColor, width: 0.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.0),
      borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
  );

  // Enhanced tab styling with modern appearance
  static BoxDecoration tabDecoration(bool isSelected) {
    return BoxDecoration(
      color: isSelected ? AppColors.primaryColor : Colors.transparent,
      borderRadius: BorderRadius.circular(25.0),
      border: isSelected ? null : Border.all(
        color: AppColors.dividerColor,
        width: 1,
      ),
      boxShadow: isSelected ? [
        BoxShadow(
          color: AppColors.primaryColor.withOpacity(0.25),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ] : null,
    );
  }

  static TextStyle tabTextStyle(bool isSelected) {
    return AppTextStyles.captionText.copyWith(
      color: isSelected ? Colors.white : AppColors.greyColor,
      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
      fontSize: 14,
    );
  }

  // Enhanced section header styling
  static TextStyle sectionHeaderStyle = AppTextStyles.captionText.copyWith(
    fontWeight: FontWeight.w700,
    color: AppColors.textColor.withOpacity(0.7),
    fontSize: 13,
    letterSpacing: 0.5,
  );
}
