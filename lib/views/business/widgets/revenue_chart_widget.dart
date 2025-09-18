// lib/views/business/widgets/revenue_chart_widget.dart
import 'package:flutter/material.dart';
import '../../../models/business.dart';

class RevenueChartWidget extends StatelessWidget {
  final Business business;
  final String selectedPeriod;

  const RevenueChartWidget({
    Key? key,
    required this.business,
    required this.selectedPeriod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                Icon(Icons.trending_up, color: const Color(0xFF2E7D32), size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Revenue Trends',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Chart Area
            Container(
              height: 200,
              child: _buildRevenueChart(),
            ),
            
            const SizedBox(height: 20),
            
            // Chart Legend
            _buildChartLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChart() {
    // Dummy data for chart visualization
    final chartData = _getChartData();
    final maxValue = chartData.map((e) => e['value'] as double).reduce((a, b) => a > b ? a : b);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: chartData.asMap().entries.map((entry) {
        final index = entry.key;
        final data = entry.value;
        final value = data['value'] as double;
        final label = data['label'] as String;
        
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Value Label
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    '\$${(value / 1000).toStringAsFixed(1)}K',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                
                // Bar
                Container(
                  width: double.infinity,
                  height: (value / maxValue) * 150,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        const Color(0xFF2E7D32),
                        const Color(0xFF4CAF50),
                      ],
                    ),
                  ),
                ),
                
                // Label
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChartLegend() {
    return Row(
      children: [
        _buildLegendItem('Current Period', const Color(0xFF2E7D32)),
        const SizedBox(width: 20),
        _buildLegendItem('Previous Period', Colors.grey[400]!),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.trending_up,
                color: const Color(0xFF2E7D32),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '+15.2% vs last period',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getChartData() {
    switch (selectedPeriod) {
      case 'This Week':
        return [
          {'label': 'Mon', 'value': 1200.0},
          {'label': 'Tue', 'value': 1800.0},
          {'label': 'Wed', 'value': 1500.0},
          {'label': 'Thu', 'value': 2200.0},
          {'label': 'Fri', 'value': 2800.0},
          {'label': 'Sat', 'value': 3200.0},
          {'label': 'Sun', 'value': 900.0},
        ];
      case 'This Month':
        return [
          {'label': 'Week 1', 'value': 8500.0},
          {'label': 'Week 2', 'value': 9200.0},
          {'label': 'Week 3', 'value': 7800.0},
          {'label': 'Week 4', 'value': 10500.0},
        ];
      case 'Last 3 Months':
        return [
          {'label': 'Month 1', 'value': 32000.0},
          {'label': 'Month 2', 'value': 28500.0},
          {'label': 'Month 3', 'value': 36000.0},
        ];
      default:
        return [
          {'label': 'Q1', 'value': 85000.0},
          {'label': 'Q2', 'value': 92000.0},
          {'label': 'Q3', 'value': 88000.0},
          {'label': 'Q4', 'value': 95000.0},
        ];
    }
  }
}
