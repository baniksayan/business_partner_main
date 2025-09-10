import 'package:flutter/material.dart';
import '../../resources/colors/app_colors.dart';
import '../../resources/styles/text_styles.dart';

class BookingsScreen extends StatefulWidget {
  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  final List<Map<String, dynamic>> bookings = [
    {
      'customer': 'Rahul Singh',
      'date': '9 Sep, 2025',
      'time': '11:00 AM',
      'status': 'Cancelled',
      'paid': false,
      'amount': 0,
    },
    {
      'customer': 'Amit Sharma',
      'date': '11 Sep, 2025',
      'time': '2:00 PM',
      'status': 'Confirmed',
      'paid': true,
      'amount': 1200,
    },
    {
      'customer': 'Neha Verma',
      'date': '10 Sep, 2025',
      'time': '5:30 PM',
      'status': 'Pending',
      'paid': false,
      'amount': 800,
    },
  ];

  String searchText = '';
  String sortBy = 'Newest';
  String? filterStatus; // Add this to your _BookingsScreenState

  List<Map<String, dynamic>> get filteredBookings {
    List<Map<String, dynamic>> filtered = bookings
        .where((b) =>
            b['customer'].toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    if (filterStatus != null) {
      filtered = filtered.where((b) => b['status'] == filterStatus).toList();
    }
    if (sortBy == 'Amount') {
      filtered.sort((a, b) => b['amount'].compareTo(a['amount']));
    } else {
      filtered.sort((a, b) => b['date'].compareTo(a['date']));
    }
    return filtered;
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Confirmed':
        return Colors.green;
      case 'Pending':
        return Color(0xFFFBC02D); // Amber for pending
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
        title: Text('Bookings', style: AppTextStyles.heading3), // Reduced size
      ),
      body: Column(
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
                // Filter Button (dummy for now)
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
                    if (selected != null || filterStatus != selected) {
                      setState(() {
                        filterStatus = selected;
                      });
                    }
                  },
                ),
                // Sort Button
                PopupMenuButton<String>(
                  onSelected: (val) => setState(() => sortBy = val),
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
            child: filteredBookings.isEmpty
                ? Center(
                    child: Text(
                      'No bookings found.',
                      style: AppTextStyles.bodyLarge,
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                    itemCount: filteredBookings.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final booking = filteredBookings[index];
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {
                            // TODO: Navigate to booking details
                          },
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
                                  CircleAvatar(
                                    backgroundColor: AppColors.splashDots,
                                    radius: 24,
                                    child: Text(
                                      booking['customer'][0],
                                      style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          booking['customer'],
                                          style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w600),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${booking['date']} • ${booking['time']}',
                                          style: AppTextStyles.bodyMedium,
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          children: [
                                            // Paid/Unpaid Chip
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                              decoration: BoxDecoration(
                                                color: _paidBgColor(booking['paid']),
                                                borderRadius: BorderRadius.circular(7),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    booking['paid'] ? Icons.check_circle : Icons.cancel,
                                                    color: _paidColor(booking['paid']),
                                                    size: 16,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    booking['paid'] ? 'Paid' : 'Unpaid',
                                                    style: AppTextStyles.bodyMedium.copyWith(
                                                      color: _paidColor(booking['paid']),
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
                                                color: _statusBgColor(booking['status']),
                                                borderRadius: BorderRadius.circular(7),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    _statusIcon(booking['status']),
                                                    color: _statusColor(booking['status']),
                                                    size: 16,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    booking['status'],
                                                    style: AppTextStyles.bodyMedium.copyWith(
                                                      color: _statusColor(booking['status']),
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
                                  Text(
                                    '₹${booking['amount']}',
                                    style: AppTextStyles.labelLarge.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.splashText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      );
                  },
                ),
          ),
        ],
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
            _navButton(Icons.dashboard, "Dashboard"),
            _navButton(Icons.shopping_bag_outlined, "Products"),
            _navButton(Icons.book_online_outlined, "Bookings", selected: true),
            _navButton(Icons.person_outline, "Profile"),
          ],
        ),
      ),
    );
  }

  Widget _navButton(IconData icon, String label, {bool selected = false}) {
    return GestureDetector(
      onTap: () {
        if (!selected) {
          switch (label) {
            case "Dashboard":
              Navigator.pushNamed(context, '/dashboard');
              break;
            case "Products":
              Navigator.pushNamed(context, '/products');
              break;
            case "Bookings":
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