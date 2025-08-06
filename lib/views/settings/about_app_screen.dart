import 'package:flutter/material.dart';
import '../styles/app_colors.dart';
import '../styles/app_text_styles.dart';
import '../../widgets/settings-widgets/custom_app_bar.dart';

class AboutAppScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: 'About',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App Logo/Brand Section
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.0),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryColor.withOpacity(0.2),
                    AppColors.accentBeige.withOpacity(0.3),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'BP',
                        style: AppTextStyles.heading1.copyWith(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'MNITURAL',
                    style: AppTextStyles.heading2.copyWith(
                      color: AppColors.primaryColor,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.0),
            
            // App Version Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.accentGreen.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Icon(
                          Icons.info_outline,
                          color: Colors.green[600],
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'v1.0.3 Stable',
                              style: AppTextStyles.bodyTextMedium.copyWith(
                                color: AppColors.successColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'PartnerPro',
                              style: AppTextStyles.heading3,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Built for Business Partners to manage services, customers, and analytics in one place.',
                    style: AppTextStyles.bodyText.copyWith(
                      color: AppColors.greyColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.0),
            
            // Credits Section
            _buildInfoSection(
              title: 'Credits',
              content: 'Powered by Innovate Solutions',
              icon: Icons.business_outlined,
              iconColor: AppColors.primaryColor,
            ),
            
            // Release History Section
            _buildReleaseHistorySection(),
            
            SizedBox(height: 24.0),
            
            // Action Buttons
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showRateUsDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 18.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 2,
                  shadowColor: AppColors.primaryColor.withOpacity(0.3),
                ),
                child: Text(
                  'Rate Us on Play Store',
                  style: AppTextStyles.buttonText.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  _showShareDialog(context);
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 18.0),
                  side: BorderSide(color: AppColors.primaryColor, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                child: Text(
                  'Share This App',
                  style: AppTextStyles.buttonText.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
            SizedBox(height: 32.0),
            
            // Terms & Privacy Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    // Navigate to Terms & Privacy
                  },
                  child: Text(
                    'Terms & Privacy',
                    style: AppTextStyles.captionText.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection({
    required String title,
    required String content,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.0),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyTextMedium,
                ),
                SizedBox(height: 4.0),
                Text(
                  content,
                  style: AppTextStyles.captionText,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReleaseHistorySection() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.0),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
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
                  color: AppColors.accentOrange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Icon(
                  Icons.history,
                  color: Colors.orange[600],
                  size: 20,
                ),
              ),
              SizedBox(width: 16.0),
              Text(
                'Release History',
                style: AppTextStyles.bodyTextMedium,
              ),
            ],
          ),
          SizedBox(height: 16.0),
          
          // Version History
          _buildVersionItem(
            version: 'Version 1.0.3',
            date: 'Latest Update',
            features: [
              'Bug fixes and performance improvements',
              'Added new analytics dashboard',
              'Improved customer management features',
            ],
            isLatest: true,
          ),
          
          SizedBox(height: 12.0),
          
          _buildVersionItem(
            version: 'Version 1.0.2',
            date: '2024-01-15',
            features: [
              'Enhanced booking system',
              'New notification settings',
              'UI/UX improvements',
            ],
            isLatest: false,
          ),
        ],
      ),
    );
  }

  Widget _buildVersionItem({
    required String version,
    required String date,
    required List<String> features,
    required bool isLatest,
  }) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isLatest ? AppColors.primaryColor.withOpacity(0.05) : AppColors.lightGreyColor,
        borderRadius: BorderRadius.circular(12.0),
        border: isLatest ? Border.all(color: AppColors.primaryColor.withOpacity(0.2)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                version,
                style: AppTextStyles.bodyTextMedium.copyWith(
                  color: isLatest ? AppColors.primaryColor : AppColors.textColor,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: isLatest ? AppColors.primaryColor : AppColors.greyColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  date,
                  style: AppTextStyles.smallText.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          ...features.map((feature) => Padding(
            padding: EdgeInsets.only(bottom: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: AppTextStyles.captionText),
                Expanded(
                  child: Text(
                    feature,
                    style: AppTextStyles.captionText,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  void _showRateUsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: Row(
          children: [
            Icon(
              Icons.star,
              color: Colors.amber,
              size: 28,
            ),
            SizedBox(width: 8),
            Text(
              'Rate Our App',
              style: AppTextStyles.heading3,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'If you enjoy using our app, please take a moment to rate it. Your feedback helps us improve!',
              style: AppTextStyles.bodyText,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) => 
                Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 32,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Later',
              style: AppTextStyles.buttonText.copyWith(
                color: AppColors.greyColor,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Thank you for your rating!'),
                  backgroundColor: AppColors.successColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: Text(
              'Rate Now',
              style: AppTextStyles.buttonText.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showShareDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: Row(
          children: [
            Icon(
              Icons.share,
              color: AppColors.primaryColor,
              size: 28,
            ),
            SizedBox(width: 8),
            Text(
              'Share App',
              style: AppTextStyles.heading3,
            ),
          ],
        ),
        content: Text(
          'Share this amazing business partner app with your friends and colleagues!',
          style: AppTextStyles.bodyText,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTextStyles.buttonText.copyWith(
                color: AppColors.greyColor,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Share link copied to clipboard!'),
                  backgroundColor: AppColors.successColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: Text(
              'Share',
              style: AppTextStyles.buttonText.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
