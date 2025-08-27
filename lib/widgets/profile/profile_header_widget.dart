import 'package:flutter/material.dart';
import '../../viewmodels/profile/profile_viewmodel.dart';
import '../../resources/styles/text_styles.dart';
import '../../utils/helpers/image_picker_helper.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final ProfileViewModel viewModel;

  const ProfileHeaderWidget({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Profile Image with camera button
        Stack(
          children: [
            Hero(
              tag: 'profile_image',
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF4FC3F7).withOpacity(0.1),
                      const Color(0xFF4FC3F7).withOpacity(0.05),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4FC3F7).withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.asset(
                    viewModel.profileImagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF4FC3F7).withOpacity(0.2),
                              const Color(0xFF4FC3F7).withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 65,
                          color: Color(0xFF4FC3F7),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            
            // Camera button for profile image upload
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => _showImagePickerOptions(context),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF4FC3F7),
                        Color(0xFF29B6F6),
                      ],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4FC3F7).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // User Role Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF4FC3F7).withOpacity(0.15),
                const Color(0xFF4FC3F7).withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF4FC3F7).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            viewModel.userRole,
            style: AppTextStyles.labelMedium.copyWith(
              color: const Color(0xFF4FC3F7),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // User Name with animation
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: AppTextStyles.heading2.copyWith(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
          child: Text(
            viewModel.userName,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            const SizedBox(height: 20),
            
            Text(
              'Change Profile Picture',
              style: AppTextStyles.heading3.copyWith(fontSize: 18),
            ),
            
            const SizedBox(height: 24),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Camera option
                _imagePickerOption(
                  context,
                  Icons.camera_alt,
                  'Camera',
                  () => _pickImage(context, true),
                ),
                
                // Gallery option
                _imagePickerOption(
                  context,
                  Icons.photo_library,
                  'Gallery',
                  () => _pickImage(context, false),
                ),
                
                // Remove option
                _imagePickerOption(
                  context,
                  Icons.delete_outline,
                  'Remove',
                  () => _removeImage(context),
                  isDestructive: true,
                ),
              ],
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _imagePickerOption(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDestructive 
              ? Colors.red.withOpacity(0.1) 
              : const Color(0xFF4FC3F7).withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDestructive 
                ? Colors.red.withOpacity(0.3) 
                : const Color(0xFF4FC3F7).withOpacity(0.3),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isDestructive ? Colors.red : const Color(0xFF4FC3F7),
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: isDestructive ? Colors.red : const Color(0xFF4FC3F7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pickImage(BuildContext context, bool fromCamera) async {
    Navigator.pop(context);
    
    // For now, just show a message since actual implementation would require image_picker
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          fromCamera 
              ? 'Camera functionality will be implemented' 
              : 'Gallery functionality will be implemented'
        ),
        backgroundColor: const Color(0xFF4FC3F7),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
    
    // TODO: Implement actual image picking logic
    // final picker = ImagePicker();
    // final image = await picker.pickImage(
    //   source: fromCamera ? ImageSource.camera : ImageSource.gallery,
    // );
    // if (image != null) {
    //   viewModel.updateProfileImage(image.path);
    // }
  }

  void _removeImage(BuildContext context) {
    Navigator.pop(context);
    
    // Reset to default profile image
    viewModel.updateProfileImage('assets/images/profile.png');
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Profile picture removed'),
        backgroundColor: const Color(0xFF4FC3F7),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
