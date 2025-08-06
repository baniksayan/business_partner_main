import 'package:flutter/material.dart';
import '../styles/app_colors.dart';
import '../styles/app_text_styles.dart';
import '../../widgets/settings-widgets/custom_app_bar.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: 'Privacy Policy',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
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
                image: DecorationImage(
                  image: AssetImage('assets/images/privacy_policy_header.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 24.0),
            
            // Data Collection Section
            _buildSection(
              title: 'Data Collection',
              content: 'We collect data to provide and improve our services. This includes personal data you provide when creating an account, using our services, or contacting us. We may also collect technical information about your device and how you use our app.',
            ),
            
            // Data Usage Section
            _buildSection(
              title: 'Data Usage',
              content: 'We use your data to:\n• Provide and maintain our services\n• Process transactions and manage your account\n• Improve our services and develop new features\n• Send you important notifications\n• Respond to your requests and provide customer support',
            ),
            
            // Data Sharing Section
            _buildSection(
              title: 'Data Sharing',
              content: 'We may share your information with:\n• Service providers who help us operate our business\n• Legal authorities if required by law\n• Third parties with your explicit consent\n• Other parties in connection with a merger or acquisition',
            ),
            
            // Data Security Section
            _buildSection(
              title: 'Data Security',
              content: 'We implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction. However, no method of transmission over the internet is 100% secure.',
            ),
            
            // Your Rights Section
            _buildSection(
              title: 'Your Rights',
              content: 'You have the right to:\n• Access your personal data\n• Correct inaccurate information\n• Request deletion of your data\n• Object to certain data processing activities\n• Export your data in a structured format',
            ),
            
            SizedBox(height: 24.0),
            
            // Contact Information
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.lightGreyColor,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Us',
                    style: AppTextStyles.heading2,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'If you have any questions about this Privacy Policy, please contact us at privacy@company.com',
                    style: AppTextStyles.bodyText,
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24.0),
          ],
        ),
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
