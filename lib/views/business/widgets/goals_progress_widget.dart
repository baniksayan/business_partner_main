// lib/views/business/widgets/goals_progress_widget.dart
import 'package:flutter/material.dart';
import '../../../models/business.dart';

class GoalsProgressWidget extends StatelessWidget {
  final Business business;
  final String timeframe;

  const GoalsProgressWidget({
    Key? key,
    required this.business,
    required this.timeframe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final goals = _getGoalsData();
    
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
                Icon(Icons.flag, color: const Color(0xFF2E7D32), size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Goals Progress',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    timeframe,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            ...goals.map((goal) => _buildGoalProgressItem(
              title: goal['title'],
              current: goal['current'],
              target: goal['target'],
              unit: goal['unit'],
              icon: goal['icon'],
              color: goal['color'],
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalProgressItem({
    required String title,
    required double current,
    required double target,
    required String unit,
    required IconData icon,
    required Color color,
  }) {
    final progress = (current / target).clamp(0.0, 1.0);
    final percentage = (progress * 100).toStringAsFixed(1);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 12),
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
              Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Row(
            children: [
              Text(
                '${current.toStringAsFixed(current.truncateToDouble() == current ? 0 : 1)}$unit',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const Spacer(),
              Text(
                '${target.toStringAsFixed(target.truncateToDouble() == target ? 0 : 1)}$unit target',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Container(
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.grey[200],
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          Row(
            children: [
              Icon(
                progress >= 1.0 
                    ? Icons.check_circle
                    : progress >= 0.7 
                        ? Icons.trending_up 
                        : Icons.warning,
                size: 16,
                color: progress >= 1.0 
                    ? Colors.green
                    : progress >= 0.7 
                        ? color 
                        : Colors.orange,
              ),
              const SizedBox(width: 4),
              Text(
                progress >= 1.0 
                    ? 'Goal achieved!'
                    : progress >= 0.7 
                        ? 'On track'
                        : 'Needs attention',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: progress >= 1.0 
                      ? Colors.green
                      : progress >= 0.7 
                          ? color 
                          : Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getGoalsData() {
    return [
      {
        'title': 'Monthly Revenue',
        'current': 18750.0,
        'target': 25000.0,
        'unit': '\$',
        'icon': Icons.attach_money,
        'color': const Color(0xFF4CAF50),
      },
      {
        'title': 'New Bookings',
        'current': 145.0,
        'target': 180.0,
        'unit': '',
        'icon': Icons.calendar_today,
        'color': const Color(0xFF2196F3),
      },
      {
        'title': 'Customer Acquisition',
        'current': 28.0,
        'target': 35.0,
        'unit': ' customers',
        'icon': Icons.person_add,
        'color': const Color(0xFFFF9800),
      },
      {
        'title': 'Service Rating',
        'current': 4.8,
        'target': 4.5,
        'unit': '/5',
        'icon': Icons.star,
        'color': const Color(0xFF9C27B0),
      },
    ];
  }
}
