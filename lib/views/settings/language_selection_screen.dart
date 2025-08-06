import 'package:flutter/material.dart';
import '../styles/app_colors.dart';
import '../styles/app_text_styles.dart';
import '../../widgets/settings-widgets/custom_app_bar.dart';

class LanguageSelectionScreen extends StatefulWidget {
  @override
  _LanguageSelectionScreenState createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selectedLanguage = 'English';

  final List<Map<String, dynamic>> _languages = [
    {
      'name': 'English',
      'nativeName': 'English',
      'flag': '🇺🇸',
      'isPopular': true,
    },
    {
      'name': 'Hindi',
      'nativeName': 'हिंदी',
      'flag': '🇮🇳',
      'isPopular': true,
    },
    {
      'name': 'Bengali',
      'nativeName': 'বাংলা',
      'flag': '🇧🇩',
      'isPopular': false,
    },
    {
      'name': 'Spanish',
      'nativeName': 'Español',
      'flag': '🇪🇸',
      'isPopular': true,
    },
    {
      'name': 'French',
      'nativeName': 'Français',
      'flag': '🇫🇷',
      'isPopular': false,
    },
    {
      'name': 'German',
      'nativeName': 'Deutsch',
      'flag': '🇩🇪',
      'isPopular': false,
    },
    {
      'name': 'Japanese',
      'nativeName': '日本語',
      'flag': '🇯🇵',
      'isPopular': false,
    },
    {
      'name': 'Korean',
      'nativeName': '한국어',
      'flag': '🇰🇷',
      'isPopular': false,
    },
    {
      'name': 'Chinese',
      'nativeName': '中文',
      'flag': '🇨🇳',
      'isPopular': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final popularLanguages = _languages.where((lang) => lang['isPopular']).toList();
    final otherLanguages = _languages.where((lang) => !lang['isPopular']).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: 'Language',
        showBackButton: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              children: [
                // Popular Languages Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  child: Text(
                    'Popular Languages',
                    style: AppTextStyles.captionText.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.greyColor,
                    ),
                  ),
                ),
                ...popularLanguages.map((language) => _buildLanguageTile(language)),
                
                SizedBox(height: 16.0),
                
                // Other Languages Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  child: Text(
                    'Other Languages',
                    style: AppTextStyles.captionText.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.greyColor,
                    ),
                  ),
                ),
                ...otherLanguages.map((language) => _buildLanguageTile(language)),
                
                SizedBox(height: 24.0),
              ],
            ),
          ),
          
          // Bottom Buttons
          Container(
            padding: EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 18.0),
                      side: BorderSide(color: AppColors.primaryColor, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    child: Text(
                      'Cancel',
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
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Language changed to $_selectedLanguage'),
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
                      padding: EdgeInsets.symmetric(vertical: 18.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 2,
                      shadowColor: AppColors.primaryColor.withOpacity(0.3),
                    ),
                    child: Text(
                      'Save Language',
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

  Widget _buildLanguageTile(Map<String, dynamic> language) {
    final isSelected = _selectedLanguage == language['name'];
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(16.0),
        border: isSelected
            ? Border.all(color: AppColors.primaryColor, width: 2.0)
            : null,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.0),
          onTap: () {
            setState(() {
              _selectedLanguage = language['name'];
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Row(
              children: [
                Text(
                  language['flag'],
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        language['name'],
                        style: AppTextStyles.bodyTextMedium.copyWith(
                          color: isSelected ? AppColors.primaryColor : AppColors.textColor,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 2.0),
                      Text(
                        language['nativeName'],
                        style: AppTextStyles.captionText.copyWith(
                          color: isSelected ? AppColors.primaryColor : AppColors.greyColor,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
