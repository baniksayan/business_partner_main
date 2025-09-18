// lib/views/business/widgets/business_performance_chart.dart
import 'package:flutter/material.dart';
import '../../../models/business.dart';

class BusinessPerformanceChart extends StatefulWidget {
  final Business? business;

  const BusinessPerformanceChart({
    Key? key,
    this.business,
  }) : super(key: key);

  @override
  State<BusinessPerformanceChart> createState() => _BusinessPerformanceChartState();
}

class _BusinessPerformanceChartState extends State<BusinessPerformanceChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  String _selectedPeriod = 'This Week';
  
  final List<String> _periods = ['Today', 'This Week', 'This Month', 'This Year'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            // Header with Period Selector
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.trending_up,
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
                        'Performance Overview',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      Text(
                        'Revenue & booking trends',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildPeriodSelector(),
              ],
            ),

            const SizedBox(height: 24),

            // Performance Metrics Row
            _buildPerformanceMetrics(),

            const SizedBox(height: 24),

            // Chart Area
            SizedBox(
              height: 200,
              child: _buildPerformanceChart(),
            ),

            const SizedBox(height: 20),

            // Chart Legend
            _buildChartLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedPeriod,
          isDense: true,
          borderRadius: BorderRadius.circular(8),
          items: _periods.map((period) {
            return DropdownMenuItem(
              value: period,
              child: Text(
                period,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E7D32),
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedPeriod = value;
              });
              _animationController.forward(from: 0);
            }
          },
        ),
      ),
    );
  }

  Widget _buildPerformanceMetrics() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'Revenue',
            value: '\$18.7K',
            change: '+12.5%',
            isPositive: true,
            color: const Color(0xFF4CAF50),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildMetricCard(
            title: 'Bookings',
            value: '145',
            change: '+8.3%',
            isPositive: true,
            color: const Color(0xFF2196F3),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildMetricCard(
            title: 'Growth',
            value: '23%',
            change: '+5.1%',
            isPositive: true,
            color: const Color(0xFFFF9800),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String change,
    required bool isPositive,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isPositive 
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPositive ? Icons.trending_up : Icons.trending_down,
                  size: 10,
                  color: isPositive ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 2),
                Text(
                  change,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isPositive ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceChart() {
    final chartData = _getChartData();
    final maxValue = chartData.map((e) => e['value'] as double).reduce((a, b) => a > b ? a : b);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: chartData.asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;
            final value = data['value'] as double;
            final label = data['label'] as String;
            final animatedHeight = (value / maxValue) * 160 * _animation.value;

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Value Label
                    if (animatedHeight > 20)
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          _formatChartValue(value),
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
                      height: animatedHeight,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            const Color(0xFF2E7D32),
                            const Color(0xFF4CAF50),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2E7D32).withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    
                    // Label
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 11,
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
      },
    );
  }

  Widget _buildChartLegend() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2E7D32).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildLegendItem('Revenue', const Color(0xFF2E7D32)),
          const SizedBox(width: 20),
          _buildLegendItem('Target', Colors.grey[400]!),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.trending_up,
                  color: Colors.green,
                  size: 16,
                ),
                const SizedBox(width: 4),
                const Text(
                  '+15.2%',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'vs last period',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
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
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getChartData() {
    switch (_selectedPeriod) {
      case 'Today':
        return [
          {'label': '9AM', 'value': 150.0},
          {'label': '11AM', 'value': 320.0},
          {'label': '1PM', 'value': 280.0},
          {'label': '3PM', 'value': 450.0},
          {'label': '5PM', 'value': 380.0},
          {'label': '7PM', 'value': 220.0},
        ];
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
          {'label': 'W1', 'value': 8500.0},
          {'label': 'W2', 'value': 9200.0},
          {'label': 'W3', 'value': 7800.0},
          {'label': 'W4', 'value': 10500.0},
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

  String _formatChartValue(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    } else {
      return value.toStringAsFixed(0);
    }
  }
}
