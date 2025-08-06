import 'package:flutter/material.dart';
import '../styles/app_colors.dart';
import '../styles/app_text_styles.dart';
import '../../widgets/settings-widgets/custom_app_bar.dart';

class TroubleshootingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: 'Troubleshooting',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Common Issues',
              style: AppTextStyles.heading1,
            ),
            SizedBox(height: 24.0),
            
            // App Crashing Issue
            _buildIssueCard(
              icon: Icons.warning_amber_outlined,
              iconColor: Colors.orange,
              title: 'App Crashing',
              subtitle: 'Causes & Fixes',
              solutions: [
                '1. Check for updates.',
                '2. Clear cache.',
                '3. Reinstall app.',
              ],
            ),
            
            // Login Issues
            _buildIssueCard(
              icon: Icons.lock_outline,
              iconColor: Colors.blue,
              title: 'Login Issues',
              subtitle: 'Password Reset & Verification',
              solutions: [
                '1. Reset password.',
                '2. Verify email.',
                '3. Contact support.',
              ],
            ),
            
            // Payment Failures
            _buildIssueCard(
              icon: Icons.payment_outlined,
              iconColor: Colors.green,
              title: 'Payment Failures',
              subtitle: 'Retry & Contact',
              solutions: [
                '1. Retry payment.',
                '2. Check card details.',
                '3. Contact support.',
              ],
            ),
            
            SizedBox(height: 32.0),
            
            // Need More Help Button
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showHelpDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Need More Help?',
                  style: AppTextStyles.buttonText.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIssueCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required List<String> solutions,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppColors.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyText.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: AppTextStyles.captionText,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          ...solutions.map((solution) => Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: Text(
              solution,
              style: AppTextStyles.bodyText,
            ),
          )),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Contact Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Still having issues? Contact our support team:'),
            SizedBox(height: 16),
            Text('Email: support@company.com'),
            Text('Phone: +1-800-123-4567'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
