// lib/views/customers/customer_detail_screen.dart - FIXED WITH FALLBACK DATA
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../resources/colors/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../services/customer_api_service.dart';
import '../../models/customer_detail.dart';
import '../../models/customer.dart';
import 'customer_wishlist_screen.dart';
import '../notifications/send_notification_screen.dart';

class CustomerDetailScreen extends StatefulWidget {
  final Customer customer;
  const CustomerDetailScreen({Key? key, required this.customer}) : super(key: key);

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  CustomerDetail? customerDetail;
  bool isLoading = true;
  String? errorMessage;
  bool usesFallbackData = false;

  @override
  void initState() {
    super.initState();
    _loadCustomerDetails();
  }

  Future<void> _loadCustomerDetails() async {
    print('👤 [CustomerDetailScreen] Loading details for customer: ${widget.customer.id}');
    
    setState(() {
      isLoading = true;
      errorMessage = null;
      usesFallbackData = false;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      if (!authProvider.isAuthenticated || authProvider.token == null) {
        _useFallbackData();
        return;
      }

      final response = await CustomerApiService.getCustomerDetails(
        authProvider.token!,
        widget.customer.id,
      );

      if (response.success && response.data != null) {
        setState(() {
          customerDetail = CustomerDetail.fromJson(response.data);
          isLoading = false;
          usesFallbackData = false;
        });
        print('✅ [CustomerDetailScreen] Customer details loaded from API');
      } else {
        print('⚠️ [CustomerDetailScreen] API failed, using fallback data: ${response.error}');
        _useFallbackData();
      }
    } catch (e) {
      print('❌ [CustomerDetailScreen] Error: $e, using fallback data');
      _useFallbackData();
    }
  }

  // ✅ NEW: Use customer data from list as fallback
  void _useFallbackData() {
    print('📋 [CustomerDetailScreen] Creating fallback CustomerDetail from list data');
    
    setState(() {
      customerDetail = CustomerDetail(
        id: widget.customer.id,
        name: widget.customer.name,
        phone: widget.customer.phone,
        email: widget.customer.email,
        avatar: widget.customer.avatar,
        roles: widget.customer.roles,
        isActive: widget.customer.isActive,
        designation: widget.customer.designation,
        bio: widget.customer.bio,
        city: widget.customer.city,
        address: widget.customer.address,
        totalBookings: widget.customer.totalBookings,
        totalSpend: 0.0, // Calculate if needed
        lastSeen: null,
        tags: widget.customer.totalBookings > 5 ? ['Regular'] : ['New'],
        bookingHistory: [], // Empty for now
      );
      isLoading = false;
      usesFallbackData = true;
      errorMessage = null;
    });
    
    print('✅ [CustomerDetailScreen] Fallback CustomerDetail created successfully');
  }

  @override
  Widget build(BuildContext context) {
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
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: AppColors.splashDots),
            onPressed: _loadCustomerDetails,
          ),
        ],
      ),
      body: isLoading 
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.splashDots),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading customer details...',
                    style: TextStyle(
                      color: AppColors.splashSubtext,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            )
          : _buildCustomerDetails(), // ✅ Always show customer details now
    );
  }

  Widget _buildCustomerDetails() {
    if (customerDetail == null) return const SizedBox.shrink();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      children: [
        // ✅ Show notification if using fallback data
        if (usesFallbackData)
          Container(
            margin: const EdgeInsets.only(bottom: 18),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.orange[700], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Showing cached customer data. Some details may be limited.',
                    style: TextStyle(
                      color: Colors.orange[700],
                      fontSize: 12,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ],
            ),
          ),
        
        // ✅ Customer Profile Card - Your Original Design
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            children: [
              // Avatar with fallback
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: customerDetail!.avatar.isNotEmpty && customerDetail!.avatar.startsWith('http')
                    ? Image.network(
                        customerDetail!.avatar,
                        width: double.infinity,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _buildAvatarFallback(),
                      )
                    : _buildAvatarFallback(),
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
                customerDetail!.name, // ✅ Shows real name "Karthik Sarkar"
                style: TextStyle(
                  color: AppColors.splashText,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                customerDetail!.phone, // ✅ Shows real phone
                style: TextStyle(
                  color: AppColors.splashDots,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                customerDetail!.email, // ✅ Shows real email
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
        
        // ✅ Stats Row 1 - Your Original Design
        Row(
          children: [
            Expanded(
              child: _statTile('Total Bookings', '${customerDetail!.totalBookings}'),
            ),
            Container(width: 1, height: 38, color: Colors.grey[200]),
            Expanded(
              child: _statTile('Total Spend', customerDetail!.totalSpendFormatted),
            ),
          ],
        ),
        
        const SizedBox(height: 18),
        
        // ✅ Stats Row 2 - Your Original Design
        Row(
          children: [
            Expanded(
              child: _statTile('Last Seen', customerDetail!.lastSeenFormatted),
            ),
            Container(width: 1, height: 38, color: Colors.grey[200]),
            Expanded(
              child: _statTile('Tags', customerDetail!.tagsFormatted),
            ),
          ],
        ),
        
        const SizedBox(height: 18),
        
        // ✅ Action buttons - Your Original Design
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
                      builder: (context) => SendNotificationScreen(customer: widget.customer),
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
                      builder: (context) => CustomerWishlistScreen(customer: widget.customer),
                    ),
                  );
                },
                child: Text('View Wishlist'),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 18),
        
        // ✅ Tabs - Your Original Design
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.splashDots, width: 2.5),
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
        
        // ✅ Booking History - Your Original Design
        if (customerDetail!.bookingHistory.isEmpty)
          Container(
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No booking history available',
                    style: TextStyle(
                      color: AppColors.splashSubtext,
                      fontFamily: 'Inter',
                      fontSize: 16,
                    ),
                  ),
                  if (usesFallbackData) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Connect to server to view booking details',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontFamily: 'Inter',
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          )
        else
          ...customerDetail!.bookingHistory.map((booking) => Container(
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
                        booking.title,
                        style: TextStyle(
                          color: AppColors.splashText,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                          fontSize: 15.5,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        booking.date,
                        style: TextStyle(
                          color: AppColors.splashSubtext,
                          fontSize: 13.5,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '₹${booking.amount.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: AppColors.splashDots,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          )),
      ],
    );
  }

  Widget _buildAvatarFallback() {
    return Container(
      width: double.infinity,
      height: 120,
      color: AppColors.splashSecondary.withOpacity(0.08),
      child: Center(
        child: CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.splashDots,
          child: Text(
            customerDetail?.name.isNotEmpty == true ? customerDetail!.name[0].toUpperCase() : 'C',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
