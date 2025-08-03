// File: lib/widgets/products/performance_metrics_section.dart
import 'package:flutter/material.dart';
import '../common/metric_card_widget.dart';

class PerformanceMetricsSection extends StatelessWidget {
  final Map<String, dynamic> productMetrics;

  const PerformanceMetricsSection({
    Key? key,
    required this.productMetrics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Performance Analytics',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: MetricCardWidget(
                  title: 'Conversion Rate',
                  value: '${productMetrics['conversionRate']}%',
                  color: Colors.green,
                  icon: Icons.trending_up,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: MetricCardWidget(
                  title: 'Avg. Rating',
                  value: '${productMetrics['averageRating']}⭐',
                  color: Colors.orange,
                  icon: Icons.star,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}