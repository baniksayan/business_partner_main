// lib/views/profile/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart'; // Add this import
import '../settings/settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'Profile',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Profile Image with real user data
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8C5A0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: authProvider.userProfilePicture != null
                              ? Image.network(
                                  authProvider.userProfilePicture!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildDefaultAvatar();
                                  },
                                )
                              : _buildDefaultAvatar(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Business Role
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          authProvider.isBusinessPartner 
                              ? 'Business Partner' 
                              : authProvider.isAdmin 
                                  ? 'Admin' 
                                  : 'End User',
                          style: const TextStyle(
                            color: Color(0xFF9C7CE8),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Real Name
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          authProvider.userName,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      
                      // Real Email
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          authProvider.userEmail ?? 'No email available',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      
                      // Real Phone
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          authProvider.userPhone.isNotEmpty 
                              ? authProvider.userPhone 
                              : 'No phone number',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      // Business Info Card (you may want to add business info to your user model)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.business,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    authProvider.currentUser?['business_name'] ?? 'Business Name',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    authProvider.currentUser?['business_category'] ?? 'Business Category',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      // Edit Profile Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/edit-profile');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9C7CE8),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Change Password Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: TextButton(
                          onPressed: () {
                            // Handle change password
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF9C7CE8),
                          ),
                          child: const Text(
                            'Change Password',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Keep existing bottom navigation
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildBottomNavItem(Icons.dashboard, 'Dashboard', false),
                    _buildBottomNavItem(Icons.grid_view, 'Products', false),
                    _buildBottomNavItem(Icons.calendar_today, 'Bookings', false),
                    _buildBottomNavItem(Icons.person, 'Profile', true),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE8C5A0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(
          Icons.person,
          size: 80,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isSelected ? const Color(0xFF9C7CE8) : Colors.grey,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF9C7CE8) : Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
