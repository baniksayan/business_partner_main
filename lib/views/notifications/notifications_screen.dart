import 'package:business_partner_main/views/customers/customers_list_screen.dart';
import 'package:flutter/material.dart';
import '../../resources/styles/text_styles.dart';
import '../../models/notification_model.dart';
import 'notification_detail_screen.dart';
import 'send_notification_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with TickerProviderStateMixin {
  int _currentIndex = 0; // This will be notifications tab index
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  String _searchQuery = '';
  String _selectedType = 'All';
  String _selectedDateRange = 'All Time';
  String _selectedStatus = 'All';

  final List<String> _types = ['All', 'SMS', 'Email', 'App', 'Push'];
  final List<String> _dateRanges = [
    'All Time',
    'Today',
    'This Week',
    'This Month',
  ];
  final List<String> _statuses = ['All', 'Read', 'Unread', 'Important'];

  // Static notification data (will come from API later)
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: '1',
      title: 'Appointment Reminder',
      message: 'You have an appointment scheduled for tomorrow at 2 PM',
      type: NotificationType.sms,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      isImportant: true,
    ),
    NotificationModel(
      id: '2',
      title: 'New Booking Confirmation',
      message: 'Your booking has been confirmed for Hair Cut service',
      type: NotificationType.email,
      timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      isRead: false,
      isImportant: false,
    ),
    NotificationModel(
      id: '3',
      title: 'Special Offer Alert',
      message: 'Get 20% off on all services this weekend only!',
      type: NotificationType.app,
      timestamp: DateTime.now().subtract(const Duration(hours: 12)),
      isRead: false,
      isImportant: true,
    ),
    NotificationModel(
      id: '4',
      title: 'Feedback Request',
      message: 'Please rate your recent experience with us',
      type: NotificationType.sms,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      isImportant: false,
    ),
    NotificationModel(
      id: '5',
      title: 'Account Update',
      message: 'Your profile information has been successfully updated',
      type: NotificationType.email,
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      isImportant: false,
    ),
    NotificationModel(
      id: '6',
      title: 'New Feature Announcement',
      message: 'Check out our new analytics dashboard feature!',
      type: NotificationType.app,
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      isRead: false,
      isImportant: true,
    ),
    NotificationModel(
      id: '7',
      title: 'Payment Reminder',
      message: 'Your payment for premium features is due tomorrow',
      type: NotificationType.sms,
      timestamp: DateTime.now().subtract(const Duration(days: 4)),
      isRead: true,
      isImportant: true,
    ),
    NotificationModel(
      id: '8',
      title: 'Welcome Email',
      message: 'Welcome to Business Partner! Here\'s how to get started',
      type: NotificationType.email,
      timestamp: DateTime.now().subtract(const Duration(days: 7)),
      isRead: true,
      isImportant: false,
    ),
    NotificationModel(
      id: '9',
      title: 'System Maintenance Alert',
      message: 'Scheduled maintenance on Sunday from 2-4 AM',
      type: NotificationType.app,
      timestamp: DateTime.now().subtract(const Duration(days: 8)),
      isRead: true,
      isImportant: false,
    ),
  ];

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
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<NotificationModel> get _filteredNotifications {
    return _notifications.where((notification) {
      // Search filter
      bool matchesSearch =
          _searchQuery.isEmpty ||
          notification.title.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          notification.message.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );

      // Type filter
      bool matchesType =
          _selectedType == 'All' ||
          notification.type.toString().split('.').last.toLowerCase() ==
              _selectedType.toLowerCase();

      // Status filter
      bool matchesStatus =
          _selectedStatus == 'All' ||
          (_selectedStatus == 'Read' && notification.isRead) ||
          (_selectedStatus == 'Unread' && !notification.isRead) ||
          (_selectedStatus == 'Important' && notification.isImportant);

      // Date range filter (simplified for demo)
      bool matchesDateRange =
          _selectedDateRange == 'All Time' ||
          (_selectedDateRange == 'Today' &&
              notification.timestamp.isAfter(
                DateTime.now().subtract(const Duration(days: 1)),
              )) ||
          (_selectedDateRange == 'This Week' &&
              notification.timestamp.isAfter(
                DateTime.now().subtract(const Duration(days: 7)),
              )) ||
          (_selectedDateRange == 'This Month' &&
              notification.timestamp.isAfter(
                DateTime.now().subtract(const Duration(days: 30)),
              ));

      return matchesSearch && matchesType && matchesStatus && matchesDateRange;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final offers = OfferNotificationStore.notifications;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Header
              _buildHeader(),
              // Search Bar
              _buildSearchBar(),
              // Filters
              _buildFilters(),
              // Notifications List
              Expanded(child: _buildNotificationsList()),
            ],
          ),
        ),
      ),
      // Persistent Bottom Navigation (same as dashboard)
      bottomNavigationBar: _buildBottomNavigation(),
      // Floating Action Button for Send Notification
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back Button
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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF4FC3F7).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.notifications,
                  color: Color(0xFF4FC3F7),
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Notifications',
                style: AppTextStyles.heading3.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Mark All Read Button
          TextButton(
            onPressed: _markAllAsRead,
            child: Text(
              'Mark All Read',
              style: AppTextStyles.linkText.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: const InputDecoration(
          icon: Icon(Icons.search, color: Color(0xFF4FC3F7)),
          hintText: 'Search notifications',
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildFilterDropdown('Type', _selectedType, _types, (value) {
            setState(() {
              _selectedType = value!;
            });
          }),
          const SizedBox(width: 12),
          _buildFilterDropdown('Date Range', _selectedDateRange, _dateRanges, (
            value,
          ) {
            setState(() {
              _selectedDateRange = value!;
            });
          }),
          const SizedBox(width: 12),
          _buildFilterDropdown('Status', _selectedStatus, _statuses, (value) {
            setState(() {
              _selectedStatus = value!;
            });
          }),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down, size: 16),
            style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
            items:
                items.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item, overflow: TextOverflow.ellipsis),
                  );
                }).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationsList() {
    final filteredNotifications = _filteredNotifications;
    if (filteredNotifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No notifications found',
              style: AppTextStyles.heading3.copyWith(color: Colors.grey[500]),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters',
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[400]),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      // Use ListView.separated for better performance
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: filteredNotifications.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final notification = filteredNotifications[index];
        return _buildNotificationTile(notification);
      },
    );
  }

  Widget _buildNotificationTile(NotificationModel notification) {
    return Container(
      // Remove margin: const EdgeInsets.only(bottom: 12), since we're using separators
      decoration: BoxDecoration(
        color:
            notification.isRead
                ? Colors.white
                : const Color(0xFF4FC3F7).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              notification.isRead
                  ? Colors.grey[200]!
                  : const Color(0xFF4FC3F7).withOpacity(0.2),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: _buildNotificationIcon(notification.type),
        title: Row(
          children: [
            Expanded(
              child: Text(
                notification.title,
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight:
                      notification.isRead ? FontWeight.w500 : FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (notification.isImportant)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(left: 8),
                decoration: const BoxDecoration(
                  color: Color(0xFFE91E63),
                  shape: BoxShape.circle,
                ),
              ),
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(left: 8),
                decoration: const BoxDecoration(
                  color: Color(0xFF4FC3F7),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${notification.type.toString().split('.').last.toUpperCase()} • ${_formatTimestamp(notification.timestamp)}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              notification.message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.grey[600],
                fontSize: 13,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
        onTap: () {
          _markAsRead(notification);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      NotificationDetailScreen(notification: notification),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationIcon(NotificationType type) {
    IconData iconData;
    Color color;
    switch (type) {
      case NotificationType.sms:
        iconData = Icons.sms_outlined;
        color = const Color(0xFF4CAF50);
        break;
      case NotificationType.email:
        iconData = Icons.email_outlined;
        color = const Color(0xFF2196F3);
        break;
      case NotificationType.app:
        iconData = Icons.notifications_outlined;
        color = const Color(0xFFFF9800);
        break;
      case NotificationType.push:
        iconData = Icons.push_pin_outlined;
        color = const Color(0xFF9C27B0);
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(iconData, color: color, size: 20),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 65, // Reduced from 70 to prevent overflow
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 4,
      ), // Reduced vertical padding
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
            case "Profile":
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
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
                size: 22, // Reduced icon size
              ),
            ),
            const SizedBox(height: 2), // Reduced spacing
            Flexible(
              // Wrap text in Flexible to prevent overflow
              child: Text(
                label,
                style: TextStyle(
                  color:
                      isSelected ? const Color(0xFF4FC3F7) : Colors.grey[500],
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontFamily: 'Inter',
                  fontSize: 10, // Reduced font size
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SendNotificationScreen(),
          ),
        );
      },
      backgroundColor: const Color(0xFF4FC3F7),
      foregroundColor: Colors.white,
      icon: const Icon(Icons.add),
      label: const Text('Send'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  void _markAsRead(NotificationModel notification) {
    setState(() {
      notification.isRead = true;
    });
    // Here you would call your API to mark as read
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });
    // Here you would call your API to mark all as read
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('All notifications marked as read'),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class OfferNotification {
  final String title;
  final String message;
  final String channel;
  final Customer customer;
  final DateTime date;

  OfferNotification({
    required this.title,
    required this.message,
    required this.channel,
    required this.customer,
    required this.date,
  });
}

class OfferNotificationStore {
  static final List<OfferNotification> notifications = [];
}
