import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../styles/app_colors.dart';
import '../styles/app_text_styles.dart';
import '../../widgets/customer-widgets/custom_app_bar.dart';
import 'customer_wishlist_screen.dart';

class CustomerDetailScreen extends StatefulWidget {
  final Map<String, dynamic> customerData;

  const CustomerDetailScreen({
    Key? key,
    required this.customerData,
  }) : super(key: key);

  @override
  _CustomerDetailScreenState createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Customer Profile',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: 'SF Pro Display',
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Customer Profile Header Card
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    spreadRadius: 0,
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFE8C5A0),
                        Color(0xFFD2A679),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        // Profile Image
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 20,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: widget.customerData['avatar'] != null
                                ? Image.network(
                                    widget.customerData['avatar'],
                                    fit: BoxFit.cover,
                                    width: 120,
                                    height: 120,
                                    errorBuilder: (context, error, stackTrace) {
                                      return _buildAvatarPlaceholder();
                                    },
                                  )
                                : _buildAvatarPlaceholder(),
                          ),
                        ),
                        SizedBox(height: 24.0),
                        
                        // Customer Tag
                        if (widget.customerData['tag'] != null)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                            margin: EdgeInsets.only(bottom: 12.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              widget.customerData['tag'] ?? 'Customer',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'SF Pro Display',
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        
                        // Customer Name
                        Text(
                          widget.customerData['name'] ?? 'Customer Name',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'SF Pro Display',
                            letterSpacing: -0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8.0),
                        
                        // Phone number
                        Text(
                          widget.customerData['phone'] ?? '+91 76534 xxxxx',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'SF Pro Display',
                          ),
                        ),
                        
                        // Email
                        if (widget.customerData['email'] != null) ...[
                          SizedBox(height: 4.0),
                          Text(
                            widget.customerData['email'],
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'SF Pro Display',
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            // Stats Grid
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  // First Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Total Bookings',
                          '${widget.customerData['totalBookings'] ?? '12'}',
                          Colors.black87,
                        ),
                      ),
                      SizedBox(width: 12.0),
                      Expanded(
                        child: _buildStatCard(
                          'Total Spend',
                          '₹${widget.customerData['totalSpend'] ?? '1,500'}',
                          Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.0),
                  
                  // Second Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Last Seen',
                          widget.customerData['lastSeen'] ?? '2 days ago',
                          Colors.black87,
                        ),
                      ),
                      SizedBox(width: 12.0),
                      Expanded(
                        child: _buildStatCard(
                          'Tags',
                          widget.customerData['customerType'] ?? 'Frequent VIP',
                          Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24.0),
            
            // Action Buttons
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _showNotificationDialog();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF007AFF),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                      child: Text(
                        'Send Notification',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'SF Pro Display',
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.0),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomerWishlistScreen(
                              customerData: widget.customerData,
                            ),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        side: BorderSide(color: Colors.grey[400]!, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
                        'View Wishlist',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          fontFamily: 'SF Pro Display',
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 32.0),
            
            // Booking History Section
            _buildBookingHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarPlaceholder() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFD2A679).withOpacity(0.3),
            Color(0xFFE8C5A0).withOpacity(0.3),
          ],
        ),
      ),
      child: Center(
        child: Text(
          _getInitials(widget.customerData['name'] ?? 'Customer'),
          style: TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.w700,
            fontFamily: 'SF Pro Display',
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color valueColor) {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF007AFF),
              fontFamily: 'SF Pro Display',
              letterSpacing: -0.2,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: valueColor,
              fontFamily: 'SF Pro Display',
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingHistory() {
    final bookingHistory = [
      {
        'title': 'Appointment with Dr. Kishore B',
        'date': '2023-11-15',
        'status': 'Completed',
        'amount': '₹500',
      },
      {
        'title': 'Consultation with Dr. Kishore B',
        'date': '2023-10-20',
        'status': 'Completed',
        'amount': '₹300',
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Booking History',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  fontFamily: 'SF Pro Display',
                  letterSpacing: -0.5,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Show reviews
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                ),
                child: Text(
                  'Reviews',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF007AFF),
                    fontFamily: 'SF Pro Display',
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          
          ...bookingHistory.map((booking) => Container(
            margin: EdgeInsets.only(bottom: 12.0),
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  spreadRadius: 0,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking['title']!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          fontFamily: 'SF Pro Display',
                          letterSpacing: -0.2,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        booking['date']!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600],
                          fontFamily: 'SF Pro Display',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )).toList(),
          
          SizedBox(height: 32.0),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    List<String> nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else if (nameParts.isNotEmpty) {
      return nameParts[0][0].toUpperCase();
    }
    return 'U';
  }

  void _showNotificationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        contentPadding: EdgeInsets.all(24),
        title: Text(
          'Send Notification',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: 'SF Pro Display',
            color: Colors.black87,
            letterSpacing: -0.5,
          ),
        ),
        content: Text(
          'Send a notification to ${widget.customerData['name'] ?? 'this customer'}?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            fontFamily: 'SF Pro Display',
            color: Colors.black54,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
                fontFamily: 'SF Pro Display',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessSnackBar();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF007AFF),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 2,
            ),
            child: Text(
              'Send',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontFamily: 'SF Pro Display',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              'Notification sent successfully!',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                fontFamily: 'SF Pro Display',
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF34C759),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 3),
      ),
    );
  }
}