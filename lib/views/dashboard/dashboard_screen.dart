import 'package:flutter/material.dart';
import '../../widgets/cards/dashboard_stats_card.dart';
import '../../widgets/charts/stock_line_chart.dart';
import '../../widgets/cards/dashboard_extra_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Sample weekly revenue data (could be dynamic from your ViewModel)
  final List<double> _weeklyRevenue = [1200, 1600, 1350, 1700, 2100, 1900, 2500];
  int _selectedDay = 6;

  @override
  Widget build(BuildContext context) {
    // List of KPI cards data
    final stats = [
      DashboardStatData('Today\'s Bookings', '12', '+10%', Colors.green),
      DashboardStatData('Total Products', '50', '+5%', Colors.green),
      DashboardStatData('Revenue', '₹2,500', '+8%', Colors.green),
      DashboardStatData('Cancellations', '2', '-2%', Colors.red),
      DashboardStatData('Reviews', '4.8', '+1%', Colors.green),
    ];

    // Additional dashboard feature cards
    final extraCards = [
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/customers');
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

      // Body wrapped in SafeArea to avoid overlapping status bar
      body: SafeArea(
        child: Column(
          children: [

            // --- HEADER: Profile, Title, Notification ---
            Container(
              height: 65,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  // Profile icon, tappable for profile screen navigation
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/profile'),
                    child: const CircleAvatar(
                      radius: 22,
                      backgroundImage: AssetImage('assets/images/profile.png'),
                    ),
                  ),

                  const Spacer(),

                  // Dashboard title at center
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

                  // Notification icon, tappable for notifications screen
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

            // --- MAIN CONTENT AREA (scrollable) ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(height: 10),

                    // Greeting text
                    Text(
                      'Hello, Priya!',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: const Color(0xFF2C3E50),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // KPI cards in a wrap for responsive grid layout
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

                    // Interactive Revenue & Bookings chart section
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

                    // Section title for extra cards
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

                    // Extra dashboard cards stacked vertically
                    Column(
                      children: extraCards,
                    ),

                    const SizedBox(height: 20),

                    // You can add more scrollable widgets/cards here as needed
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // --- FIXED BOTTOM NAVIGATION WITH WORKING NAVIGATION ---
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
  }

  // Bottom navigation button widget with navigation functionality
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
              Navigator.pushReplacementNamed(context, '/bookings');
              break;
            case "Profile":
              Navigator.pushReplacementNamed(context, '/profile');
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
