// lib/views/customers/customer_detail_screen.dart - ENHANCED ERROR HANDLING
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

  @override
  void initState() {
    super.initState();
    print('👤 [CustomerDetailScreen] Initializing for customer: ${widget.customer.id} - ${widget.customer.name}');
    _loadCustomerDetails();
  }

  Future<void> _loadCustomerDetails() async {
    print('👤 [CustomerDetailScreen] Loading details for customer: ${widget.customer.id}');
    
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      if (!authProvider.isAuthenticated || authProvider.token == null) {
        setState(() {
          errorMessage = 'Authentication required. Please login again.';
          isLoading = false;
        });
        return;
      }

      // ✅ ENHANCED: Better debugging
      print('🔑 [CustomerDetailScreen] Using token: ${authProvider.token!.substring(0, 20)}...');
      print('👤 [CustomerDetailScreen] Customer ID: ${widget.customer.id}');

      final response = await CustomerApiService.getCustomerDetails(
        authProvider.token!,
        widget.customer.id,
      );

      if (response.success && response.data != null) {
        setState(() {
          customerDetail = CustomerDetail.fromJson(response.data);
          isLoading = false;
        });
        print('✅ [CustomerDetailScreen] Customer details loaded successfully');
      } else {
        setState(() {
          errorMessage = response.error ?? 'Failed to load customer details';
          isLoading = false;
        });
        print('❌ [CustomerDetailScreen] Failed to load: ${response.error}');
      }
    } catch (e) {
      print('❌ [CustomerDetailScreen] Error: $e');
      setState(() {
        errorMessage = 'Error loading customer details: $e';
        isLoading = false;
      });
    }
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
          ? _buildLoadingState()
          : errorMessage != null
              ? _buildErrorState()
              : _buildCustomerDetails(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.splashDots),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading ${widget.customer.name}\'s details...',
            style: TextStyle(
              color: AppColors.splashSubtext,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 20),
            Text(
              'Failed to Load Customer Details',
              style: TextStyle(
                color: AppColors.splashText,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Text(
                errorMessage!,
                style: TextStyle(
                  color: Colors.red[700],
                  fontFamily: 'Inter',
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Go Back'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.splashSubtext,
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _loadCustomerDetails,
                  child: Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.splashDots,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // ✅ ENHANCED: Show fallback customer info from list
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Basic Customer Info:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.splashText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Name: ${widget.customer.name}'),
                  Text('Phone: ${widget.customer.phone}'),
                  Text('Email: ${widget.customer.email}'),
                  Text('ID: ${widget.customer.id}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerDetails() {
    if (customerDetail == null) return const SizedBox.shrink();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      children: [
        // Customer Profile Card - Using Real Data
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
                customerDetail!.name,
                style: TextStyle(
                  color: AppColors.splashText,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                customerDetail!.phone,
                style: TextStyle(
                  color: AppColors.splashDots,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                customerDetail!.email,
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
        
        // Stats Row 1 - Real Data
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
        
        // Stats Row 2 - Real Data
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
        
        // Tabs - Keep same design
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
        
        // Real Booking History from API
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
                    'No booking history',
                    style: TextStyle(
                      color: AppColors.splashSubtext,
                      fontFamily: 'Inter',
                      fontSize: 16,
                    ),
                  ),
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
    final name = customerDetail?.name ?? widget.customer.name;
    return Container(
      width: double.infinity,
      height: 120,
      color: AppColors.splashSecondary.withOpacity(0.08),
      child: Center(
        child: CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.splashDots,
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : 'C',
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
