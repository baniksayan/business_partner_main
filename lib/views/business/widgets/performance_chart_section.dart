// lib/views/business/widgets/performance_chart_section.dart
import 'package:flutter/material.dart';
import '../../../models/business.dart';

class PerformanceChartSection extends StatefulWidget {
  final Business business;
  final String timeframe;

  const PerformanceChartSection({
    Key? key,
    required this.business,
    required this.timeframe,
  }) : super(key: key);

  @override
  State<PerformanceChartSection> createState() => _PerformanceChartSectionState();
}

class _PerformanceChartSectionState extends State<PerformanceChartSection>
    with SingleTickerProviderStateMixin {
  late TabController _chartTabController;
  
  @override
  void initState() {
    super.initState();
    _chartTabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _chartTabController.dispose();
    super.dispose();
  }

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
                Icon(Icons.bar_chart, color: const Color(0xFF2E7D32), size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Performance Charts',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            TabBar(
              controller: _chartTabController,
              labelColor: const Color(0xFF2E7D32),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFF2E7D32),
              tabs: const [
                Tab(text: 'Revenue'),
                Tab(text: 'Bookings'),
                Tab(text: 'Customers'),
              ],
            ),
            
            const SizedBox(height: 20),
            
            SizedBox(
              height: 250,
              child: TabBarView(
                controller: _chartTabController,
                children: [
                  _buildRevenueChart(),
                  _buildBookingsChart(),
                  _buildCustomersChart(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChart() {
    final chartData = _getRevenueChartData();
    final maxValue = chartData.map((e) => e['value'] as double).reduce((a, b) => a > b ? a : b);
    
    return Column(
      children: [
        Expanded(
          child: Row(
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
                      Text(
                        '\$${(value / 1000).toStringAsFixed(1)}K',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: double.infinity,
                        height: (value / maxValue) * 180,
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
                      const SizedBox(height: 8),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        _buildChartSummary('Total Revenue: \$125K | Avg: \$18K/month'),
      ],
    );
  }

  Widget _buildBookingsChart() {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[50],
            ),
            child: const Center(
              child: Text(
                'Booking Trends Chart',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildChartSummary('Total Bookings: 1,247 | Success Rate: 95%'),
      ],
    );
  }

  Widget _buildCustomersChart() {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[50],
            ),
            child: const Center(
              child: Text(
                'Customer Growth Chart',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildChartSummary('Total Customers: 432 | Growth: +18% this month'),
      ],
    );
  }

  Widget _buildChartSummary(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2E7D32).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2E7D32),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getRevenueChartData() {
    switch (widget.timeframe) {
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
          {'label': 'Jan', 'value': 25000.0},
          {'label': 'Feb', 'value': 28000.0},
          {'label': 'Mar', 'value': 32000.0},
          {'label': 'Apr', 'value': 29000.0},
          {'label': 'May', 'value': 35000.0},
          {'label': 'Jun', 'value': 38000.0},
        ];
    }
  }
}
