// lib/views/business/widgets/performance_kpi_grid.dart
import 'package:flutter/material.dart';
import '../../../models/business.dart';

class PerformanceKpiGrid extends StatelessWidget {
  final Business business;
  final String timeframe;

  const PerformanceKpiGrid({
    Key? key,
    required this.business,
    required this.timeframe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final kpis = _getKpiData();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Key Performance Indicators',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemCount: kpis.length,
          itemBuilder: (context, index) {
            final kpi = kpis[index];
            return _buildKpiCard(
              title: kpi['title'],
              value: kpi['value'],
              change: kpi['change'],
              trend: kpi['trend'],
              icon: kpi['icon'],
              color: kpi['color'],
            );
          },
        ),
      ],
    );
  }

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String change,
    required String trend,
    required IconData icon,
    required Color color,
  }) {
    final isPositive = trend == 'up';
    
    return Card(
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const Spacer(),
                Icon(
                  isPositive ? Icons.trending_up : Icons.trending_down,
                  color: isPositive ? Colors.green : Colors.red,
                  size: 16,
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            
            const SizedBox(height: 4),
            
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isPositive 
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                    color: isPositive ? Colors.green : Colors.red,
                    size: 12,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    change,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isPositive ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getKpiData() {
    return [
      {
        'title': 'Revenue Growth',
        'value': '15.3%',
        'change': '+2.1%',
        'trend': 'up',
        'icon': Icons.attach_money,
        'color': const Color(0xFF4CAF50),
      },
      {
        'title': 'Customer Retention',
        'value': '89.2%',
        'change': '+5.4%',
        'trend': 'up',
        'icon': Icons.people_outline,
        'color': const Color(0xFF2196F3),
      },
      {
        'title': 'Booking Efficiency',
        'value': '94.7%',
        'change': '+1.8%',
        'trend': 'up',
        'icon': Icons.calendar_today,
        'color': const Color(0xFFFF9800),
      },
      {
        'title': 'Service Rating',
        'value': '4.8/5',
        'change': '+0.2',
        'trend': 'up',
        'icon': Icons.star,
        'color': const Color(0xFF9C27B0),
      },
      {
        'title': 'Profit Margin',
        'value': '32.1%',
        'change': '+3.2%',
        'trend': 'up',
        'icon': Icons.trending_up,
        'color': const Color(0xFF00BCD4),
      },
      {
        'title': 'Cost per Booking',
        'value': '\$12.50',
        'change': '-\$1.20',
        'trend': 'up',
        'icon': Icons.money_off,
        'color': const Color(0xFF8BC34A),
      },
    ];
  }
}
