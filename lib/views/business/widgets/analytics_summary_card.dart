// lib/views/business/widgets/analytics_summary_card.dart
import 'package:flutter/material.dart';
import '../../../models/business.dart';

class AnalyticsSummaryCard extends StatelessWidget {
  final Business business;
  final String selectedPeriod;

  const AnalyticsSummaryCard({
    Key? key,
    required this.business,
    required this.selectedPeriod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.insights, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Performance Summary',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    selectedPeriod,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Key Metrics Row
            Row(
              children: [
                _buildMetricItem(
                  title: 'Revenue',
                  value: '\$${_formatNumber(business.stats.monthlyRevenue)}',
                  change: '+12.5%',
                  isPositive: true,
                ),
                const SizedBox(width: 20),
                _buildMetricItem(
                  title: 'Bookings',
                  value: '${business.stats.activeBookings}',
                  change: '+8.3%',
                  isPositive: true,
                ),
                const SizedBox(width: 20),
                _buildMetricItem(
                  title: 'Customers',
                  value: '${business.stats.activeCustomers}',
                  change: '+15.7%',
                  isPositive: true,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Performance Indicators
            _buildPerformanceIndicators(),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem({
    required String title,
    required String value,
    required String change,
    required bool isPositive,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: isPositive ? Colors.lightGreenAccent : Colors.redAccent,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                change,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isPositive ? Colors.lightGreenAccent : Colors.redAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceIndicators() {
    final indicators = [
      {'label': 'Avg. Booking Value', 'value': '\$85', 'progress': 0.75},
      {'label': 'Customer Retention', 'value': '89%', 'progress': 0.89},
      {'label': 'Service Utilization', 'value': '92%', 'progress': 0.92},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Performance Indicators',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 12),
        ...indicators.map((indicator) => _buildIndicatorRow(
          indicator['label'] as String,
          indicator['value'] as String,
          indicator['progress'] as double,
        )).toList(),
      ],
    );
  }

  Widget _buildIndicatorRow(String label, String value, double progress) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Colors.white.withOpacity(0.2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 50,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toStringAsFixed(0);
    }
  }
}
