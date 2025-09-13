// lib/widgets/profile/profile_header_widget.dart
import 'package:flutter/material.dart';
import '../../providers/auth_provider.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final AuthProvider authProvider;

  const ProfileHeaderWidget({Key? key, required this.authProvider}) : super(key: key);

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
        children: [
          // Profile Image
          Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF4FC3F7).withOpacity(0.2),
                      const Color(0xFF4FC3F7).withOpacity(0.1),
                    ],
                  ),
                ),
                child: authProvider.userProfilePicture != null
                    ? ClipOval(
                        child: Image.network(
                          authProvider.userProfilePicture!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildDefaultAvatar();
                          },
                        ),
                      )
                    : _buildDefaultAvatar(),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF4FC3F7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // User Role Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF4FC3F7).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _getUserRole(),
              style: const TextStyle(
                color: Color(0xFF4FC3F7),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                fontFamily: "Inter",
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // User Name
          Text(
            authProvider.userName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
              fontFamily: "Poppins",
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 6),
          
          // User Email
          Text(
            authProvider.userEmail,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontFamily: "Inter",
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 4),
          
          // User Phone
          if (authProvider.userPhone.isNotEmpty)
            Text(
              authProvider.userPhone,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontFamily: "Inter",
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF4FC3F7).withOpacity(0.1),
      ),
      child: Icon(
        Icons.person,
        size: 60,
        color: const Color(0xFF4FC3F7),
      ),
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
