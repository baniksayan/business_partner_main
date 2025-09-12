import 'package:flutter/material.dart';
import '../../viewmodels/profile/profile_viewmodel.dart';
import '../../resources/styles/text_styles.dart';

class ProfileInfoWidget extends StatelessWidget {
  final ProfileViewModel viewModel;

  const ProfileInfoWidget({Key? key, required this.viewModel})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            'Personal Information',
            style: AppTextStyles.heading3.copyWith(fontSize: 16),
          ),

          const SizedBox(height: 20),

          // Email
          _buildInfoItem(
            icon: Icons.email_outlined,
            iconColor: const Color(0xFF4CAF50),
            label: 'Email Address',
            value: viewModel.userEmail,
            backgroundColor: const Color(0xFF4CAF50).withOpacity(0.1),
          ),

          const SizedBox(height: 20),

          // Phone (showing formatted with +91)
          _buildInfoItem(
            icon: Icons.phone_outlined,
            iconColor: const Color(0xFF2196F3),
            label: 'Phone Number',
            value: viewModel.formattedPhone,
            backgroundColor: const Color(0xFF2196F3).withOpacity(0.1),
          ),

          const SizedBox(height: 20),

          // Company
          _buildInfoItem(
            icon: Icons.business_outlined,
            iconColor: const Color(0xFF9C27B0),
            label: 'Company',
            value: viewModel.companyName,
            subtitle: viewModel.companyCategory,
            backgroundColor: const Color(0xFF9C27B0).withOpacity(0.1),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String label,
    required String value,
    String? subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: iconColor.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: iconColor.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),

          const SizedBox(width: 16),

          // Label and Value
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: Colors.grey[600],
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2C3E50),
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Edit indicator
          // Icon(
          //   Icons.edit_outlined,
          //   color: Colors.grey[400],
          //   size: 18,
          // ),
        ],
      ),
    );
  }
}
