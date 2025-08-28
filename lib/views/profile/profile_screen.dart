import 'package:business_partner_main/views/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/profile/profile_viewmodel.dart';
import '../../widgets/profile/profile_header_widget.dart';
import '../../widgets/profile/profile_info_widget.dart';
import '../../widgets/profile/profile_action_buttons.dart';
import '../../resources/styles/text_styles.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 3; // Profile tab index
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel()..loadProfileData(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: SafeArea(
          child: Column(
            children: [
              // Header with back button and settings
              _buildAppBar(),
              // Profile content
              Expanded(
                child: Consumer<ProfileViewModel>(
                  builder: (context, viewModel, child) {
                    if (viewModel.isLoading) {
                      return Center(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(
                                color: Color(0xFF4FC3F7),
                                strokeWidth: 3,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Loading profile...',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: const Color(0xFF4FC3F7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (viewModel.hasError) {
                      return Center(
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red[400],
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                viewModel.errorMessage,
                                style: AppTextStyles.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => viewModel.loadProfileData(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4FC3F7),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text('Retry'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              // Profile Header (Image, Name, Role)
                              ProfileHeaderWidget(viewModel: viewModel),
                              const SizedBox(height: 30),
                              // Profile Information (Email, Phone, Company)
                              ProfileInfoWidget(viewModel: viewModel),
                              const SizedBox(height: 40),
                              // Action Buttons (Edit Profile, Change Password)
                              ProfileActionButtons(viewModel: viewModel),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // Persistent Bottom Navigation
        bottomNavigationBar: _buildBottomNavigation(),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back button
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Color(0xFF2C3E50),
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const Spacer(),
          // Title
          Text('Profile', style: AppTextStyles.heading3.copyWith(fontSize: 20)),
          const Spacer(),
          // Settings button
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF4FC3F7).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.settings_outlined,
                color: Color(0xFF4FC3F7),
                size: 20,
              ),
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 75, // Increased height to accommodate content
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navButton(Icons.dashboard_outlined, Icons.dashboard, "Dashboard", 0),
          _navButton(
            Icons.shopping_bag_outlined,
            Icons.shopping_bag,
            "Products",
            1,
          ),
          _navButton(
            Icons.book_online_outlined,
            Icons.book_online,
            "Bookings",
            2,
          ),
          _navButton(Icons.person_outline, Icons.person, "Profile", 3),
        ],
      ),
    );
  }

  Widget _navButton(
    IconData outlinedIcon,
    IconData filledIcon,
    String label,
    int index,
  ) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          setState(() {
            _currentIndex = index;
          });
          switch (label) {
            case "Dashboard":
              Navigator.pushReplacementNamed(context, '/dashboard');
              break;
            case "Products":
              Navigator.pushReplacementNamed(context, '/products');
              break;
            case "Bookings":
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Bookings screen coming soon'),
                  backgroundColor: const Color(0xFF4FC3F7),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
              break;
          }
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ), // Reduced padding
        decoration: BoxDecoration(
          color:
              isSelected
                  ? const Color(0xFF4FC3F7).withOpacity(0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? filledIcon : outlinedIcon,
                key: ValueKey(isSelected),
                color: isSelected ? const Color(0xFF4FC3F7) : Colors.grey[500],
                size: 22, // Slightly reduced icon size
              ),
            ),
            const SizedBox(height: 2), // Reduced spacing
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF4FC3F7) : Colors.grey[500],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontFamily: 'Inter',
                fontSize: 10, // Reduced font size
              ),
            ),
          ],
        ),
      ),
    );
  }
}
