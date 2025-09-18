// lib/views/business/widgets/recent_activities_widget.dart
import 'package:flutter/material.dart';
import '../../../models/business.dart';

class RecentActivitiesWidget extends StatelessWidget {
  final Business business;

  const RecentActivitiesWidget({
    Key? key,
    required this.business,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final activities = _getRecentActivities();
    
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history, color: const Color(0xFF2E7D32), size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Recent Activities',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // Navigate to full activity log
                  },
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      color: Color(0xFF2E7D32),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length,
              separatorBuilder: (context, index) => const Divider(height: 20),
              itemBuilder: (context, index) {
                final activity = activities[index];
                return _buildActivityItem(
                  title: activity['title'],
                  description: activity['description'],
                  time: activity['time'],
                  icon: activity['icon'],
                  color: activity['color'],
                  type: activity['type'],
                );
              },
            ),
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
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        
        const SizedBox(width: 16),
        
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
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
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
                ),
              ),
              
              const SizedBox(height: 4),
              
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 12,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getRecentActivities() {
    return [
      {
        'title': 'New booking confirmed',
        'description': 'Sarah Johnson booked Hair Cut & Styling for tomorrow 2:00 PM',
        'time': '5 minutes ago',
        'icon': Icons.event_available,
        'color': const Color(0xFF4CAF50),
        'type': 'BOOKING',
      },
      {
        'title': 'Payment received',
        'description': 'Payment of \$85.00 received from Emma Williams',
        'time': '15 minutes ago',
        'icon': Icons.payment,
        'color': const Color(0xFF2196F3),
        'type': 'PAYMENT',
      },
      {
        'title': 'Service completed',
        'description': 'Facial Treatment for Lisa Brown marked as completed',
        'time': '1 hour ago',
        'icon': Icons.check_circle,
        'color': const Color(0xFF9C27B0),
        'type': 'SERVICE',
      },
      {
        'title': 'New customer review',
        'description': 'Jessica Davis left a 5-star review for Manicure service',
        'time': '2 hours ago',
        'icon': Icons.star,
        'color': const Color(0xFFFF9800),
        'type': 'REVIEW',
      },
      {
        'title': 'Profile updated',
        'description': 'Business hours updated for weekend schedule',
        'time': '1 day ago',
        'icon': Icons.edit,
        'color': const Color(0xFF607D8B),
        'type': 'UPDATE',
      },
    ];
  }
}
