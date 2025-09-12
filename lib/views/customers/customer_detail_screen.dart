import 'package:business_partner_main/views/customers/customer_wishlist_screen.dart';
import 'package:business_partner_main/views/notifications/send_notification_screen.dart';
import 'package:flutter/material.dart';
import '../../resources/colors/app_colors.dart';
import 'customers_list_screen.dart'; // For Customer class

class CustomerDetailScreen extends StatelessWidget {
  final Customer customer;
  const CustomerDetailScreen({Key? key, required this.customer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example static data for other fields
    final int totalBookings = 12;
    final String totalSpend = '₹1,500';
    final String lastSeen = '2 days ago';
    final String tags = 'Frequent, VIP';
    final List<Map<String, String>> bookingHistory = [
      {
        'title': 'Appointment with Dr. Kishore B',
        'date': '2023-11-15',
      },
      {
        'title': 'Consultation with Dr. Anjali S',
        'date': '2023-10-20',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.splashText),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Customer Profile',
          style: TextStyle(
            color: AppColors.splashText,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        children: [
          // Avatar and name
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    customer.avatar,
                    width: double.infinity,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: double.infinity,
                      height: 120,
                      color: AppColors.splashSecondary.withOpacity(0.08),
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: AppColors.splashSecondary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Customer',
                  style: TextStyle(
                    color: AppColors.splashSubtext,
                    fontFamily: 'Inter',
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  customer.name,
                  style: TextStyle(
                    color: AppColors.splashText,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  customer.phone,
                  style: TextStyle(
                    color: AppColors.splashDots,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'divya.kapoor@email.com', // Static for now
                  style: TextStyle(
                    color: AppColors.splashSubtext,
                    fontFamily: 'Inter',
                    fontSize: 13.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          // Stats
          Row(
            children: [
              Expanded(
                child: _statTile('Total Bookings', '$totalBookings'),
              ),
              Container(
                width: 1,
                height: 38,
                color: Colors.grey[200],
              ),
              Expanded(
                child: _statTile('Total Spend', totalSpend),
              ),
            ],
          ),
          const SizedBox(height: 18),
          // Last seen and tags
          Row(
            children: [
              Expanded(
                child: _statTile('Last Seen', lastSeen),
              ),
              Container(
                width: 1,
                height: 38,
                color: Colors.grey[200],
              ),
              Expanded(
                child: _statTile('Tags', tags),
              ),
            ],
          ),
          const SizedBox(height: 18),
          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.splashDots,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SendNotificationScreen(),
                      ),
                    );
                  },
                  child: Text('Send Notification'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.splashDots,
                    side: BorderSide(color: AppColors.splashDots, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerWishlistScreen(customer: customer),
                      ),
                    );
                  },
                  child: Text('View Wishlist'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          // Tabs (static for now)
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.splashDots,
                        width: 2.5,
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Booking History',
                      style: TextStyle(
                        color: AppColors.splashDots,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      'Reviews',
                      style: TextStyle(
                        color: AppColors.splashSubtext,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Booking History List
          ...List.generate(
            bookingHistory.length,
            (i) {
              final booking = bookingHistory[i];
              return Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.splashDots.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Icon(Icons.calendar_today, color: AppColors.splashDots, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking['title']!,
                            style: TextStyle(
                              color: AppColors.splashText,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Inter',
                              fontSize: 15.5,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            booking['date']!,
                            style: TextStyle(
                              color: AppColors.splashSubtext,
                              fontSize: 13.5,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _statTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.splashSubtext,
            fontFamily: 'Inter',
            fontSize: 13.5,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            color: AppColors.splashText,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
            fontSize: 15.5,
          ),
        ),
      ],
    );
  }
}