// lib/views/bookings/bookings_screen.dart - FIXED VERSION
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../resources/colors/app_colors.dart';
import '../../resources/styles/text_styles.dart';
import '../../providers/booking_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/booking.dart';
import 'booking_details_screen.dart';

class BookingsScreen extends StatefulWidget {
  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  String searchText = '';
  String sortBy = 'Newest';
  String? filterStatus;

  @override
  void initState() {
    super.initState();
    print('📅 [BookingsScreen] Initializing...');
    
    // Load bookings when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBookings();
    });
  }

  Future<void> _loadBookings() async {
    print('📅 [BookingsScreen] Loading bookings...');
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
    await bookingProvider.getAllBookings(context);
  }

  Future<void> _refreshBookings() async {
    print('🔄 [BookingsScreen] Refreshing bookings...');
    await _loadBookings();
  }

  List<Booking> get filteredBookings {
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
    return bookingProvider.getFilteredBookings(
      status: filterStatus,
      searchQuery: searchText,
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Confirmed':
        return Colors.green;
      case 'Pending':
        return Color(0xFFFBC02D);
      case 'Cancelled':
        return Colors.red;
      default:
        return AppColors.splashText;
    }
  }

  Color _statusBgColor(String status) {
    switch (status) {
      case 'Confirmed':
        return Colors.green.withOpacity(0.08);
      case 'Pending':
        return Color(0xFFFFF9E2);
      case 'Cancelled':
        return Colors.red.withOpacity(0.08);
      default:
        return Colors.grey[100]!;
    }
  }

  Color _paidColor(bool paid) => paid ? Colors.green : Colors.red;
  Color _paidBgColor(bool paid) => paid ? Colors.green.withOpacity(0.08) : Colors.red.withOpacity(0.08);

  IconData _statusIcon(String status) {
    switch (status) {
      case 'Confirmed':
        return Icons.check_circle_outline;
      case 'Pending':
        return Icons.hourglass_bottom_rounded;
      case 'Cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('Bookings', style: AppTextStyles.heading3),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: AppColors.splashText),
            onPressed: _refreshBookings,
          ),
        ],
      ),
      body: Consumer<BookingProvider>(
        builder: (context, bookingProvider, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
                child: Row(
                  children: [
                    // Search Bar
                    Expanded(
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: TextField(
                          onChanged: (val) => setState(() => searchText = val),
                          decoration: InputDecoration(
                            hintText: 'Search by name or service',
                            hintStyle: AppTextStyles.bodyMedium,
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                            contentPadding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          style: AppTextStyles.bodyLarge,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Filter Button
                    IconButton(
                      icon: Icon(Icons.tune, color: AppColors.splashText),
                      tooltip: 'Filter',
                      onPressed: () async {
                        final selected = await showModalBottomSheet<String>(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                          ),
                          builder: (context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  title: Text('All'),
                                  onTap: () => Navigator.pop(context, null),
                                  selected: filterStatus == null,
                                ),
                                ListTile(
                                  title: Text('Confirmed'),
                                  onTap: () => Navigator.pop(context, 'Confirmed'),
                                  selected: filterStatus == 'Confirmed',
                                ),
                                ListTile(
                                  title: Text('Pending'),
                                  onTap: () => Navigator.pop(context, 'Pending'),
                                  selected: filterStatus == 'Pending',
                                ),
                                ListTile(
                                  title: Text('Cancelled'),
                                  onTap: () => Navigator.pop(context, 'Cancelled'),
                                  selected: filterStatus == 'Cancelled',
                                ),
                              ],
                            );
                          },
                        );
                        if (selected != filterStatus) {
                          setState(() {
                            filterStatus = selected;
                          });
                        }
                      },
                    ),
                    // Sort Button
                    PopupMenuButton<String>(
                      onSelected: (val) {
                        setState(() => sortBy = val);
                        bookingProvider.sortBookings(val);
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(value: 'Newest', child: Text('Sort by Newest')),
                        PopupMenuItem(value: 'Amount', child: Text('Sort by Amount')),
                      ],
                      icon: Icon(Icons.swap_vert, color: AppColors.splashText),
                      tooltip: 'Sort',
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _buildBookingsList(bookingProvider),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildBookingsList(BookingProvider bookingProvider) {
    if (bookingProvider.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.splashDots),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading bookings...',
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      );
    }

    if (bookingProvider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              bookingProvider.errorMessage!,
              style: AppTextStyles.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refreshBookings,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    final bookings = filteredBookings;

    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No bookings found.',
              style: AppTextStyles.bodyLarge,
            ),
            if (filterStatus != null || searchText.isNotEmpty) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  setState(() {
                    filterStatus = null;
                    searchText = '';
                  });
                },
                child: Text('Clear filters'),
              ),
            ],
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshBookings,
      color: AppColors.splashDots,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
        itemCount: bookings.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                print('📅 [BookingsScreen] Tapping booking: ${booking.id}');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingDetailsScreen(
                      booking: {
                        // ✅ FIXED: Ensure all required fields are present
                        'id': booking.id,
                        'customer': booking.customerName,         // ✅ This is what was missing!
                        'customer_name': booking.customerName,
                        'phone': booking.customerPhone,
                        'customer_phone': booking.customerPhone,
                        'date': booking.date,
                        'time': booking.time,
                        'status': booking.status,
                        'paid': booking.isPaid,
                        'is_paid': booking.isPaid,
                        'amount': booking.amount,
                        'service_name': booking.serviceName,
                        'service_provider_name': booking.serviceProviderName,
                      },
                    ),
                  ),
                );
              },
              // ✅ FIXED: Complete booking card UI (this was missing!)
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Customer Avatar
                      CircleAvatar(
                        backgroundColor: AppColors.splashDots,
                        radius: 24,
                        child: Text(
                          booking.customerName.isNotEmpty ? booking.customerName[0] : 'C',
                          style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // Booking Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Customer Name
                            Text(
                              booking.customerName,
                              style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 2),
                            
                            // Date & Time
                            Text(
                              '${booking.date} • ${booking.time}',
                              style: AppTextStyles.bodyMedium,
                            ),
                            const SizedBox(height: 2),
                            
                            // Service Name
                            Text(
                              booking.serviceName,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 10),
                            
                            // Status Chips
                            Row(
                              children: [
                                // Paid/Unpaid Chip
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: _paidBgColor(booking.isPaid),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        booking.isPaid ? Icons.check_circle : Icons.cancel,
                                        color: _paidColor(booking.isPaid),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        booking.isPaid ? 'Paid' : 'Unpaid',
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          color: _paidColor(booking.isPaid),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                
                                // Status Chip
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: _statusBgColor(booking.status),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        _statusIcon(booking.status),
                                        color: _statusColor(booking.status),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        booking.status,
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          color: _statusColor(booking.status),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      
                      // Amount
                      Text(
                        '₹${booking.amount.toStringAsFixed(0)}',
                        style: AppTextStyles.labelLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.splashText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
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
          _navButton(Icons.dashboard, "Dashboard"),
          _navButton(Icons.shopping_bag_outlined, "Products"),
          _navButton(Icons.book_online_outlined, "Bookings", selected: true),
          _navButton(Icons.person_outline, "Profile"),
        ],
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
            color: selected ? AppColors.splashDots : Colors.grey[500],
            size: 26,
          ),
          Text(
            label,
            style: TextStyle(
              color: selected ? AppColors.splashDots : Colors.grey[500],
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
