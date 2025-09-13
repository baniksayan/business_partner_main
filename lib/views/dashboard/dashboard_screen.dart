// lib/views/dashboard/dashboard_screen.dart - ENHANCED VERSION
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/cards/dashboard_stats_card.dart';
import '../../widgets/charts/stock_line_chart.dart';
import '../../widgets/cards/dashboard_extra_card.dart';
import '../customers/customers_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<double> _weeklyRevenue = [1200, 1600, 1350, 1700, 2100, 1900, 2500];
  int _selectedDay = 6;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final userName = authProvider.userName;
        final userProfilePicture = authProvider.userProfilePicture;
        
        final stats = [
          DashboardStatData('Today\'s Bookings', '12', '+10%', Colors.green),
          DashboardStatData('Total Products', '50', '+5%', Colors.green),
          DashboardStatData('Revenue', '₹2,500', '+8%', Colors.green),
          DashboardStatData('Cancellations', '2', '-2%', Colors.red),
          DashboardStatData('Reviews', '4.8', '+1%', Colors.green),
        ];

        final extraCards = [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomersListScreen(),
                ),
              );
            },
            child: DashboardExtraCard(
              icon: Icons.people_outline,
              title: 'Customers',
              value: '1,032',
              subtext: 'Total customers',
              background: Colors.indigo[50]!,
            ),
          ),
          DashboardExtraCard(
            icon: Icons.star_half,
            title: 'Feedbacks',
            value: '98',
            subtext: 'New this week',
            background: Colors.amber[50]!,
          ),
          DashboardExtraCard(
            icon: Icons.payment_outlined,
            title: 'Pending Payments',
            value: '₹8,200',
            subtext: 'Due this month',
            background: Colors.pink[50]!,
          ),
        ];

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          body: SafeArea(
            child: Column(
              children: [
                // ENHANCED HEADER with better profile image handling
                Container(
                  height: 65,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    children: [
                      // **ENHANCED PROFILE IMAGE WIDGET**
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/profile'),
                        child: _buildProfileAvatar(
                          authProvider: authProvider,
                          size: 44, // diameter = radius * 2
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Dashboard',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: const Color(0xFF2C3E50),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.notifications_none_rounded,
                          color: Color(0xFF4FC3F7),
                          size: 28,
                        ),
                        onPressed: () => Navigator.pushNamed(context, '/notifications'),
                      ),
                    ],
                  ),
                ),

                // MAIN CONTENT AREA
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        
                        // **ENHANCED GREETING with profile image**
                        Row(
                          children: [
                            
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hello, ${authProvider.userFirstName}!',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                      color: const Color(0xFF2C3E50),
                                    ),
                                  ),
                                  Text(
                                    'Welcome back to your dashboard',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Stats cards
                        Wrap(
                          runSpacing: 18,
                          spacing: 14,
                          children: List.generate(
                            stats.length,
                            (i) => SizedBox(
                              width: (MediaQuery.of(context).size.width - 40) / 2,
                              child: DashboardStatsCard(data: stats[i]),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Revenue chart section
                        Card(
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)),
                          color: Colors.white,
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Revenue & Bookings",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF2C3E50),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                StockLineChart(
                                  data: _weeklyRevenue,
                                  selectedIndex: _selectedDay,
                                  onChanged: (index) {
                                    setState(() {
                                      _selectedDay = index;
                                    });
                                  },
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  '₹${_weeklyRevenue[_selectedDay].toStringAsFixed(0)} on ${["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][_selectedDay]}',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: const Color(0xFF4FC3F7),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                  ),
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 28),
                        
                        Text(
                          "Your Business",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2C3E50),
                          ),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        Column(
                          children: extraCards,
                        ),
                        
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          bottomNavigationBar: Container(
            height: 65,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _navButton(Icons.dashboard, "Dashboard", selected: true),
                _navButton(Icons.shopping_bag_outlined, "Products"),
                _navButton(Icons.book_online_outlined, "Bookings"),
                _navButton(Icons.person_outline, "Profile"),
              ],
            ),
          ),
        );
      },
    );
  }

  // **ENHANCED PROFILE AVATAR WIDGET**
  Widget _buildProfileAvatar({
    required AuthProvider authProvider,
    required double size,
    bool showBorder = false,
  }) {
    final userProfilePicture = authProvider.userProfilePicture;
    final userName = authProvider.userName;
    final userEmail = authProvider.userEmail;
    
    // Get initials from name or email
    String getInitials() {
      if (userName.isNotEmpty && userName != 'User') {
        final parts = userName.trim().split(' ');
        if (parts.length >= 2) {
          return '${parts[0][0].toUpperCase()}${parts[1][0].toUpperCase()}';
        } else {
          return parts[0][0].toUpperCase();
        }
      } else if (userEmail.isNotEmpty) {
        return userEmail[0].toUpperCase();
      }
      return 'U';
    }

    // Generate consistent color based on user name/email
    Color getAvatarColor() {
      final String seed = userName.isNotEmpty ? userName : userEmail;
      final int hash = seed.hashCode;
      final List<Color> colors = [
        const Color(0xFF4FC3F7), // Primary blue
        const Color(0xFF66BB6A), // Green
        const Color(0xFFFF7043), // Orange
        const Color(0xFFAB47BC), // Purple
        const Color(0xFF42A5F5), // Light blue
        const Color(0xFFEF5350), // Red
        const Color(0xFFFFCA28), // Amber
        const Color(0xFF26A69A), // Teal
      ];
      return colors[hash.abs() % colors.length];
    }

    return Container(
      width: size,
      height: size,
      decoration: showBorder
          ? BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF4FC3F7),
                width: 2,
              ),
            )
          : null,
      child: CircleAvatar(
        radius: size / 2,
        backgroundColor: getAvatarColor(),
        backgroundImage: (userProfilePicture != null && 
                         userProfilePicture.isNotEmpty && 
                         userProfilePicture != 'null')
            ? NetworkImage(userProfilePicture)
            : null,
        onBackgroundImageError: (userProfilePicture != null && 
                                 userProfilePicture.isNotEmpty && 
                                 userProfilePicture != 'null')
            ? (exception, stackTrace) {
                print('❌ Profile image load error: $exception');
              }
            : null,
        child: (userProfilePicture == null || 
                userProfilePicture.isEmpty || 
                userProfilePicture == 'null')
            ? Text(
                getInitials(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size / 2.5,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              )
            : null,
      ),
    );
  }

  Widget _navButton(IconData icon, String label, {bool selected = false}) {
    return GestureDetector(
      onTap: () {
        if (!selected) {
          switch (label) {
            case "Dashboard":
              Navigator.pushReplacementNamed(context, '/dashboard');
              break;
            case "Products":
              Navigator.pushReplacementNamed(context, '/products');
              break;
            case "Bookings":
              Navigator.pushNamed(context, '/bookings');
              break;
            case "Profile":
              Navigator.pushNamed(context, '/profile');
              break;
          }
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: selected ? const Color(0xFF4FC3F7) : Colors.grey[500],
            size: 26,
          ),
          Text(
            label,
            style: TextStyle(
              color: selected ? const Color(0xFF4FC3F7) : Colors.grey[500],
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}
