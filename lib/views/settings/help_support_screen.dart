import 'package:flutter/material.dart';
import '../styles/app_colors.dart';
import '../styles/app_text_styles.dart';
import '../../widgets/settings-widgets/custom_app_bar.dart';

class HelpSupportScreen extends StatelessWidget {
  final List<Map<String, String>> _faqs = [
    {
      'question': 'How to add services?',
      'answer': 'To add services, navigate to the "Services" tab in your dashboard. Click the "Add Service" button and fill in the required details, including service name, description, pricing, and duration. Save the service to make it available for booking.',
    },
    {
      'question': 'How to reset password?',
      'answer': 'Go to the login screen and click "Forgot Password". Enter your registered email address and follow the instructions sent to your email to reset your password.',
    },
    {
      'question': 'How to manage bookings?',
      'answer': 'Navigate to the "Bookings" section to view all your appointments. You can accept, decline, or reschedule bookings as needed. Customers will be notified automatically of any changes.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: 'Help Center',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FAQs Section
            Text(
              'FAQs',
              style: AppTextStyles.heading1,
            ),
            SizedBox(height: 16.0),
            
            // FAQ Items
            ..._faqs.map((faq) => _buildFAQItem(faq['question']!, faq['answer']!)),
            
            SizedBox(height: 32.0),
            
            // Quick Tips Section
            Text(
              'Quick Tips',
              style: AppTextStyles.heading1,
            ),
            SizedBox(height: 16.0),
            
            // Tips Grid
            Row(
              children: [
                Expanded(
                  child: _buildTipCard(
                    icon: Icons.person_add,
                    title: 'Tip: Use the quick add feature to add services faster',
                    color: Color(0xFFE8C5A0),
                  ),
                ),
                SizedBox(width: 12.0),
                Expanded(
                  child: _buildTipCard(
                    icon: Icons.notifications,
                    title: 'Tip: Set up notifications to stay updated on bookings',
                    color: Color(0xFFB8E6B8),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.0),
            Row(
              children: [
                Expanded(
                  child: _buildTipCard(
                    icon: Icons.calendar_today,
                    title: 'Tip: Keep your calendar up to date for better management',
                    color: Color(0xFFFFD1B3),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 32.0),
            
            // Action Buttons
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showTicketDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Submit a Ticket',
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
                  _showLiveChatDialog(context);
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  side: BorderSide(color: AppColors.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Live Chat',
                  style: AppTextStyles.buttonText.copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: AppColors.dividerColor),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: AppTextStyles.bodyText.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              answer,
              style: AppTextStyles.bodyText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 32,
            color: color.withOpacity(0.8),
          ),
          SizedBox(height: 12.0),
          Text(
            title,
            style: AppTextStyles.captionText.copyWith(
              color: AppColors.textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showTicketDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Submit a Ticket'),
        content: Text('This will open the ticket submission form.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLiveChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Live Chat'),
        content: Text('Connecting to customer support...'),
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
