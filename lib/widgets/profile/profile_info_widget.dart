// lib/widgets/profile/profile_info_widget.dart
import 'package:flutter/material.dart';
import '../../providers/auth_provider.dart';

class ProfileInfoWidget extends StatelessWidget {
  final AuthProvider authProvider;

  const ProfileInfoWidget({Key? key, required this.authProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Account Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
              fontFamily: "Poppins",
            ),
          ),
          
          const SizedBox(height: 20),
          
          // User ID
          _buildInfoTile(
            icon: Icons.badge_outlined,
            title: 'User ID',
            subtitle: authProvider.userId,
          ),
          
          const SizedBox(height: 16),
          
          // Email
          _buildInfoTile(
            icon: Icons.email_outlined,
            title: 'Email Address',
            subtitle: authProvider.userEmail,
          ),
          
          const SizedBox(height: 16),
          
          // Phone
          if (authProvider.userPhone.isNotEmpty) ...[
            _buildInfoTile(
              icon: Icons.phone_outlined,
              title: 'Phone Number',
              subtitle: authProvider.userPhone,
            ),
            const SizedBox(height: 16),
          ],
          
          // Account Type
          _buildInfoTile(
            icon: Icons.person_outline,
            title: 'Account Type',
            subtitle: _getUserRole(),
          ),
          
          const SizedBox(height: 16),
          
          // Account Status
          _buildInfoTile(
            icon: authProvider.isAuthenticated 
                ? Icons.check_circle_outline 
                : Icons.cancel_outlined,
            title: 'Account Status',
            subtitle: authProvider.isAuthenticated ? 'Active' : 'Inactive',
            statusColor: authProvider.isAuthenticated ? Colors.green : Colors.red,
          ),
          
          const SizedBox(height: 16),
          
          // Session Status
          _buildInfoTile(
            icon: authProvider.isSessionExpired 
                ? Icons.schedule_outlined 
                : Icons.verified_outlined,
            title: 'Session Status',
            subtitle: authProvider.isSessionExpired ? 'Expired' : 'Active',
            statusColor: authProvider.isSessionExpired ? Colors.orange : Colors.green,
          ),
          
          const SizedBox(height: 20),
          
          // Business Information
          if (authProvider.businessName.isNotEmpty || authProvider.businessCategory.isNotEmpty) ...[
            const Text(
              'Business Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
                fontFamily: "Poppins",
              ),
            ),
            
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF4FC3F7).withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4FC3F7).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.business,
                      color: Color(0xFF4FC3F7),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          authProvider.businessName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                            fontFamily: "Inter",
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          authProvider.businessCategory,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontFamily: "Inter",
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Color? statusColor,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: (statusColor ?? const Color(0xFF4FC3F7)).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: statusColor ?? const Color(0xFF4FC3F7),
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: statusColor ?? const Color(0xFF2C3E50),
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getUserRole() {
    if (authProvider.isBusinessPartner) {
      return 'Business Partner';
    } else if (authProvider.isAdmin) {
      return 'Administrator';
    } else if (authProvider.isEndUser) {
      return 'End User';
    } else {
      return 'User';
    }
  }
}
