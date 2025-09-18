// lib/views/business/widgets/business_recent_activity.dart
import 'package:flutter/material.dart';
import '../../../models/business.dart';

class BusinessRecentActivity extends StatelessWidget {
  final Business? business;

  const BusinessRecentActivity({
    Key? key,
    this.business,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final activities = _getRecentActivities();

    return Card(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey[50]!,
            ],
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.history,
                    color: Color(0xFF2E7D32),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recent Activity',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      Text(
                        'Latest business updates',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to full activity log
                    _showFullActivityLog(context);
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    backgroundColor: const Color(0xFF2E7D32).withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      color: Color(0xFF2E7D32),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Activity List
            ...activities.take(5).map((activity) => _buildActivityItem(
              title: activity['title'] as String,
              description: activity['description'] as String,
              time: activity['time'] as String,
              icon: activity['icon'] as IconData,
              color: activity['color'] as Color,
              type: activity['type'] as String,
            )).toList(),

            if (activities.length > 5) ...[
              const SizedBox(height: 16),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '+${activities.length - 5} more activities',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem({
    required String title,
    required String description,
    required String time,
    required IconData icon,
    required Color color,
    required String type,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Activity Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),

          const SizedBox(width: 16),

          // Activity Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        type,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action Button
          IconButton(
            onPressed: () {
              _showActivityDetails(title, description, time);
            },
            icon: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getRecentActivities() {
    return [
      {
        'title': 'New booking confirmed',
        'description': 'Sarah Johnson booked Hair Cut & Styling for tomorrow at 2:00 PM. Payment confirmed.',
        'time': '5 minutes ago',
        'icon': Icons.event_available,
        'color': const Color(0xFF4CAF50),
        'type': 'BOOKING',
      },
      {
        'title': 'Payment received',
        'description': 'Payment of \$85.00 received from Emma Williams via card payment.',
        'time': '15 minutes ago',
        'icon': Icons.payment,
        'color': const Color(0xFF2196F3),
        'type': 'PAYMENT',
      },
      {
        'title': 'Service completed',
        'description': 'Facial Treatment for Lisa Brown marked as completed. Customer rating: 5 stars.',
        'time': '1 hour ago',
        'icon': Icons.check_circle,
        'color': const Color(0xFF9C27B0),
        'type': 'SERVICE',
      },
      {
        'title': 'New customer review',
        'description': 'Jessica Davis left a 5-star review: "Excellent service and professional staff!"',
        'time': '2 hours ago',
        'icon': Icons.star,
        'color': const Color(0xFFFF9800),
        'type': 'REVIEW',
      },
      {
        'title': 'Profile updated',
        'description': 'Business hours updated for weekend schedule. Changes are now live.',
        'time': '1 day ago',
        'icon': Icons.edit,
        'color': const Color(0xFF607D8B),
        'type': 'UPDATE',
      },
      {
        'title': 'New customer registered',
        'description': 'Maria Garcia signed up and booked her first appointment for next week.',
        'time': '1 day ago',
        'icon': Icons.person_add,
        'color': const Color(0xFF00BCD4),
        'type': 'CUSTOMER',
      },
      {
        'title': 'Monthly report generated',
        'description': 'Your monthly performance report is ready for download.',
        'time': '2 days ago',
        'icon': Icons.assessment,
        'color': const Color(0xFF795548),
        'type': 'REPORT',
      },
      {
        'title': 'Product stock updated',
        'description': 'Hair care products inventory has been restocked. 15 items added.',
        'time': '3 days ago',
        'icon': Icons.inventory,
        'color': const Color(0xFF3F51B5),
        'type': 'INVENTORY',
      },
    ];
  }

  void _showActivityDetails(String title, String description, String time) {
    // You can implement detailed activity view here
    print('Activity details: $title - $description - $time');
  }

  void _showFullActivityLog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Text(
                    'All Activities',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            
            // Activity List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _getRecentActivities().length,
                itemBuilder: (context, index) {
                  final activity = _getRecentActivities()[index];
                  return _buildActivityItem(
                    title: activity['title'] as String,
                    description: activity['description'] as String,
                    time: activity['time'] as String,
                    icon: activity['icon'] as IconData,
                    color: activity['color'] as Color,
                    type: activity['type'] as String,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
