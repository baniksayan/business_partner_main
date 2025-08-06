import 'package:flutter/material.dart';
import '../styles/app_colors.dart';
import '../styles/app_text_styles.dart';
import '../../widgets/settings-widgets/custom_app_bar.dart';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedCategory = 'General';

  final List<String> _categories = [
    'General',
    'Technical Support',
    'Billing',
    'Feature Request',
    'Bug Report',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: 'Contact Us',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Customer Service Images Section
            Container(
              height: 180,
              child: PageView(
                children: [
                  _buildServiceImage(
                    color: Color(0xFFE8C5A0),
                    icon: Icons.headset_mic_outlined,
                    title: 'Customer Support',
                  ),
                  _buildServiceImage(
                    color: Color(0xFFB8E6B8),
                    icon: Icons.chat_bubble_outline,
                    title: 'Live Chat Available',
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.0),
            
            // Contact Form
            Text(
              'Contact Form',
              style: AppTextStyles.heading1,
            ),
            SizedBox(height: 16.0),
            
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Name Field
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardColor,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: AppColors.dividerColor),
                    ),
                    child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Your Name',
                        hintStyle: AppTextStyles.captionText,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16.0),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 16.0),
                  
                  // Email Field
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardColor,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: AppColors.dividerColor),
                    ),
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Your Email',
                        hintStyle: AppTextStyles.captionText,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16.0),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 16.0),
                  
                  // Category Dropdown
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: AppColors.cardColor,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: AppColors.dividerColor),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCategory,
                        hint: Text(
                          'Issue Category',
                          style: AppTextStyles.captionText,
                        ),
                        items: _categories.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(
                              category,
                              style: AppTextStyles.bodyText,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  
                  // Message Field
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardColor,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: AppColors.dividerColor),
                    ),
                    child: TextFormField(
                      controller: _messageController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Your message...',
                        hintStyle: AppTextStyles.captionText,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16.0),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your message';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 24.0),
                  
                  // Send Message Button
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _sendMessage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'Send Message',
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
      ),
    );
  }

  Widget _buildServiceImage({
    required Color color,
    required IconData icon,
    required String title,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 60,
              color: color.withOpacity(0.8),
            ),
            SizedBox(height: 16),
            Text(
              title,
              style: AppTextStyles.heading2.copyWith(
                color: color.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_formKey.currentState!.validate()) {
      // Handle form submission
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Message sent successfully!'),
          backgroundColor: AppColors.successColor,
        ),
      );
      
      // Clear form
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
      setState(() {
        _selectedCategory = 'General';
      });
    }
  }
}
