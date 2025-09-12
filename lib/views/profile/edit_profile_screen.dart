// lib/views/profile/edit_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart'; // Add this import

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _businessNameController;
  late TextEditingController _businessCategoryController;

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers with real user data
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    _firstNameController = TextEditingController(text: authProvider.userFirstName);
    _lastNameController = TextEditingController(text: authProvider.userLastName);
    _nameController = TextEditingController(text: authProvider.userName);
    _emailController = TextEditingController(text: authProvider.userEmail ?? '');
    _phoneController = TextEditingController(text: authProvider.userPhone);
    _businessNameController = TextEditingController(
      text: authProvider.currentUser?['business_name'] ?? ''
    );
    _businessCategoryController = TextEditingController(
      text: authProvider.currentUser?['business_category'] ?? ''
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _businessNameController.dispose();
    _businessCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF1A202C)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'Edit Profile',
              style: TextStyle(
                color: Color(0xFF1A202C),
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Image Section
                        Center(
                          child: Container(
                            width: double.infinity,
                            height: 140,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Profile Image container
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: authProvider.userProfilePicture != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(
                                            authProvider.userProfilePicture!,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return _buildDefaultProfileWidget();
                                            },
                                          ),
                                        )
                                      : _buildDefaultProfileWidget(),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  authProvider.userName.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF718096),
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Change Profile Picture Section
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Change Profile Picture',
                                    style: TextStyle(
                                      color: Color(0xFF1A202C),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Tap to upload a new photo',
                                    style: TextStyle(
                                      color: Color(0xFF718096),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // TODO: Implement image picker
                                  _handleImageUpload();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF8B7CF8),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: const Text(
                                  'Upload',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Form Fields
                        _buildTextField('First Name', _firstNameController),
                        const SizedBox(height: 16),
                        
                        _buildTextField('Last Name', _lastNameController),
                        const SizedBox(height: 16),
                        
                        _buildTextField('Email', _emailController, enabled: false), // Email usually not editable
                        const SizedBox(height: 16),
                        
                        _buildTextField('Phone', _phoneController),
                        const SizedBox(height: 16),
                        
                        _buildTextField('Business Name', _businessNameController),
                        const SizedBox(height: 16),
                        
                        _buildTextField('Business Category', _businessCategoryController),
                        
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Bottom Action Buttons
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFFE2E8F0),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF718096),
                            side: const BorderSide(color: Color(0xFFE2E8F0)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: authProvider.isLoading 
                              ? null 
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    _saveProfile(authProvider);
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B7CF8),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: authProvider.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Keep existing bottom navigation
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildBottomNavItem(Icons.dashboard_outlined, 'Dashboard', false),
                    _buildBottomNavItem(Icons.inventory_2_outlined, 'Products', false),
                    _buildBottomNavItem(Icons.book_outlined, 'Bookings', false),
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

  Widget _buildDefaultProfileWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFF718096),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.person,
            color: Color(0xFF718096),
            size: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF1A202C),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: enabled ? const Color(0xFFF3E8FF) : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextFormField(
            controller: controller,
            enabled: enabled,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            ),
            style: TextStyle(
              color: enabled ? const Color(0xFF1A202C) : Colors.grey[600],
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavItem(IconData icon, String label, bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isSelected ? const Color(0xFF8B7CF8) : const Color(0xFF718096),
          size: 22,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF8B7CF8) : const Color(0xFF718096),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _handleImageUpload() {
    // TODO: Implement image picker and upload
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image upload functionality coming soon!'),
        backgroundColor: Color(0xFF8B7CF8),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _saveProfile(AuthProvider authProvider) async {
    try {
      // Update user data
      final updatedUserData = {
        ...authProvider.currentUser ?? {},
        'first_name': _firstNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'business_name': _businessNameController.text.trim(),
        'business_category': _businessCategoryController.text.trim(),
      };

      await authProvider.updateUserData(updatedUserData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Color(0xFF8B7CF8),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
