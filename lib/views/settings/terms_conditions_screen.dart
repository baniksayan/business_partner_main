import 'package:flutter/material.dart';
import '../styles/app_colors.dart';
import '../styles/app_text_styles.dart';
import '../../widgets/settings-widgets/custom_app_bar.dart';

class TermsConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: 'Terms & Conditions',
        showBackButton: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Image Section
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppColors.lightGreyColor,
                      borderRadius: BorderRadius.circular(12.0),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFF5E6D3),
                          Color(0xFFE8C5A0),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.article_outlined,
                            size: 60,
                            color: Colors.brown[600],
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Terms and Conditions',
                            style: AppTextStyles.heading2.copyWith(
                              color: Colors.brown[700],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Last updated: 2024-01-20',
                            style: AppTextStyles.captionText.copyWith(
                              color: Colors.brown[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.0),
                  
                  // Welcome Message
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: AppColors.cardColor,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: AppColors.dividerColor),
                    ),
                    child: Text(
                      'Welcome to our platform. By accessing or using our services, you agree to be bound by these Terms and Conditions. Please read them carefully.',
                      style: AppTextStyles.bodyText.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.0),
                  
                  // 1. User Obligations
                  _buildSection(
                    title: '1. User Obligations',
                    content: 'You agree to use our services responsibly and lawfully. You must not engage in any activity that disrupts or interferes with our services or the experience of other users.',
                  ),
                  
                  // 2. Business Usage Rules
                  _buildSection(
                    title: '2. Business Usage Rules',
                    content: 'If you are using our services for business purposes, you must comply with all applicable laws and regulations. You are responsible for all activities conducted through your account.',
                  ),
                  
                  // 3. Limitation of Liability
                  _buildSection(
                    title: '3. Limitation of Liability',
                    content: 'We are not liable for any indirect, incidental, special, consequential damages arising out of or in connection with your use of our services.',
                  ),
                  
                  // 4. Modifications
                  _buildSection(
                    title: '4. Modifications',
                    content: 'We reserve the right to modify these Terms and Conditions at any time. Your continued use of our services after any such changes constitutes your acceptance of the new Terms.',
                  ),
                  
                  SizedBox(height: 24.0),
                ],
              ),
            ),
          ),
          
          // Bottom Buttons
          Container(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      side: BorderSide(color: AppColors.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Back to Settings',
                      style: AppTextStyles.buttonText.copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle agreement
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Terms accepted')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'I Agree',
                      style: AppTextStyles.buttonText.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.heading2,
        ),
        SizedBox(height: 8.0),
        Text(
          content,
          style: AppTextStyles.bodyText,
        ),
        SizedBox(height: 24.0),
      ],
    );
  }
}
