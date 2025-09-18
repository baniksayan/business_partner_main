// lib/views/business/business_settings_screen.dart - UPDATED WITH APP COLORS & STYLES
import 'package:business_partner_main/resources/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/business_provider.dart';
import '../../resources/colors/app_colors.dart';
// import '../../resources/styles/app_text_styles.dart';

class BusinessSettingsScreen extends StatefulWidget {
  const BusinessSettingsScreen({Key? key}) : super(key: key);

  @override
  State<BusinessSettingsScreen> createState() => _BusinessSettingsScreenState();
}

class _BusinessSettingsScreenState extends State<BusinessSettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailUpdates = true;
  bool _autoBooking = false;
  bool _publicProfile = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      appBar: AppBar(
        title: Text(
          'Business Settings',
          style: AppTextStyles.heading3.copyWith(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.splashDots,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // General Settings
            _buildSettingsSection(
              'General Settings',
              [
                _buildSettingsTile(
                  'Notifications',
                  'Receive booking and business updates',
                  Icons.notifications_outlined,
                  Switch(
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                    },
                    activeColor: AppColors.splashDots,
                  ),
                ),
                _buildSettingsTile(
                  'Email Updates',
                  'Get business reports via email',
                  Icons.email_outlined,
                  Switch(
                    value: _emailUpdates,
                    onChanged: (value) {
                      setState(() {
                        _emailUpdates = value;
                      });
                    },
                    activeColor: AppColors.splashDots,
                  ),
                ),
                _buildSettingsTile(
                  'Auto Booking',
                  'Automatically accept bookings',
                  Icons.auto_mode_outlined,
                  Switch(
                    value: _autoBooking,
                    onChanged: (value) {
                      setState(() {
                        _autoBooking = value;
                      });
                    },
                    activeColor: AppColors.splashDots,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Privacy Settings
            _buildSettingsSection(
              'Privacy Settings',
              [
                _buildSettingsTile(
                  'Public Profile',
                  'Make your business visible to customers',
                  Icons.public_outlined,
                  Switch(
                    value: _publicProfile,
                    onChanged: (value) {
                      setState(() {
                        _publicProfile = value;
                      });
                    },
                    activeColor: AppColors.splashDots,
                  ),
                ),
                _buildSettingsTile(
                  'Data Privacy',
                  'Manage your data and privacy settings',
                  Icons.privacy_tip_outlined,
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.splashSubtext,
                    size: 16,
                  ),
                  onTap: () {
                    // Navigate to privacy settings
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Account Settings
            _buildSettingsSection(
              'Account Settings',
              [
                _buildSettingsTile(
                  'Business Information',
                  'Update your business details',
                  Icons.business_outlined,
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.splashSubtext,
                    size: 16,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/business-info');
                  },
                ),
                _buildSettingsTile(
                  'Business Hours',
                  'Set your operating hours',
                  Icons.access_time_outlined,
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.splashSubtext,
                    size: 16,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/settings/business-hours');
                  },
                ),
                _buildSettingsTile(
                  'Payment Settings',
                  'Manage payment methods and billing',
                  Icons.payment_outlined,
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.splashSubtext,
                    size: 16,
                  ),
                  onTap: () {
                    // Navigate to payment settings
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Support Settings
            _buildSettingsSection(
              'Support & Help',
              [
                _buildSettingsTile(
                  'Help Center',
                  'Get help and support',
                  Icons.help_outline,
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.splashSubtext,
                    size: 16,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/settings/help-support');
                  },
                ),
                _buildSettingsTile(
                  'Contact Support',
                  'Reach out to our support team',
                  Icons.support_agent_outlined,
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.splashSubtext,
                    size: 16,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/settings/contact-us');
                  },
                ),
                _buildSettingsTile(
                  'About',
                  'App version and information',
                  Icons.info_outline,
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.splashSubtext,
                    size: 16,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/settings/about-app');
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Danger Zone
            _buildDangerZone(),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> tiles) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              title,
              style: AppTextStyles.labelLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.splashText,
              ),
            ),
          ),
          const Divider(height: 1),
          ...tiles,
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    String title,
    String subtitle,
    IconData icon,
    Widget trailing, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.splashDots.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: AppColors.splashDots,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.splashText,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.splashSubtext,
        ),
      ),
      trailing: trailing,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    );
  }

  Widget _buildDangerZone() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(Icons.warning_outlined, color: Colors.red, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Danger Zone',
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.red),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.delete_forever_outlined,
                color: Colors.red,
                size: 20,
              ),
            ),
            title: Text(
              'Delete Business Account',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            subtitle: Text(
              'Permanently delete your business account and all data',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.red.withOpacity(0.7),
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.red,
              size: 16,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            onTap: () {
              _showDeleteAccountDialog();
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            const SizedBox(width: 8),
            Text(
              'Delete Account',
              style: AppTextStyles.labelLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to delete your business account? This action cannot be undone and all your data will be permanently lost.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: AppTextStyles.bodyMedium,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Handle account deletion
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(
              'Delete Account',
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
