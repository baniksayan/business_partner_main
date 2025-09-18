// lib/views/business/widgets/service_report_widget.dart
import 'package:flutter/material.dart';
import '../../../models/business.dart';

class ServiceReportWidget extends StatelessWidget {
  final Business business;
  final String period;
  final DateTime startDate;
  final DateTime endDate;

  const ServiceReportWidget({
    Key? key,
    required this.business,
    required this.period,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Service Performance Overview
        _buildServicePerformanceOverview(),
        
        const SizedBox(height: 16),
        
        // Popular Services
        _buildPopularServices(),
        
        const SizedBox(height: 16),
        
        // Service Revenue Breakdown
        _buildServiceRevenueBreakdown(),
        
        const SizedBox(height: 16),
        
        // Service Duration Analysis
        _buildServiceDurationAnalysis(),
        
        const SizedBox(height: 16),
        
        // Service Rating Analysis
        _buildServiceRatingAnalysis(),
      ],
    );
  }

  Widget _buildServicePerformanceOverview() {
    final performanceData = [
      {'title': 'Total Services', 'value': '145', 'change': '+12.3%', 'trend': 'up', 'icon': Icons.design_services, 'color': const Color(0xFF2196F3)},
      {'title': 'Avg Service Value', 'value': '\$95', 'change': '+8.7%', 'trend': 'up', 'icon': Icons.attach_money, 'color': const Color(0xFF4CAF50)},
      {'title': 'Service Efficiency', 'value': '94.2%', 'change': '+3.1%', 'trend': 'up', 'icon': Icons.speed, 'color': const Color(0xFFFF9800)},
      {'title': 'Customer Satisfaction', 'value': '4.8/5', 'change': '+0.2', 'trend': 'up', 'icon': Icons.sentiment_very_satisfied, 'color': const Color(0xFF9C27B0)},
    ];

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
                Icon(Icons.analytics, color: const Color(0xFF2E7D32), size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Service Performance Overview',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
              ),
              itemCount: performanceData.length,
              itemBuilder: (context, index) {
                final data = performanceData[index];
                return _buildPerformanceCard(
                  title: data['title'] as String,
                  value: data['value'] as String,
                  change: data['change'] as String,
                  trend: data['trend'] as String,
                  icon: data['icon'] as IconData,
                  color: data['color'] as Color,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceCard({
    required String title,
    required String value,
    required String change,
    required String trend,
    required IconData icon,
    required Color color,
  }) {
    final isPositive = trend == 'up';
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
              Icon(
                isPositive ? Icons.trending_up : Icons.trending_down,
                color: isPositive ? Colors.green : Colors.red,
                size: 16,
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
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
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          const SizedBox(height: 8),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isPositive 
                  ? Colors.green.withOpacity(0.1)
                  : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              change,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isPositive ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularServices() {
    final popularServices = [
      {'name': 'Hair Cut & Styling', 'bookings': 45, 'revenue': 3375.0, 'avgRating': 4.9, 'duration': '60 min'},
      {'name': 'Hair Coloring', 'bookings': 28, 'revenue': 2800.0, 'avgRating': 4.7, 'duration': '120 min'},
      {'name': 'Facial Treatment', 'bookings': 32, 'revenue': 2240.0, 'avgRating': 4.8, 'duration': '75 min'},
      {'name': 'Manicure & Pedicure', 'bookings': 25, 'revenue': 1750.0, 'avgRating': 4.6, 'duration': '90 min'},
      {'name': 'Eyebrow Threading', 'bookings': 15, 'revenue': 450.0, 'avgRating': 4.5, 'duration': '30 min'},
    ];

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
                Icon(Icons.star, color: const Color(0xFF2E7D32), size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Popular Services',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            ...popularServices.asMap().entries.map((entry) {
              final index = entry.key;
              final service = entry.value;
              return _buildPopularServiceItem(
                rank: index + 1,
                name: service['name'] as String,
                bookings: service['bookings'] as int,
                revenue: service['revenue'] as double,
                avgRating: service['avgRating'] as double,
                duration: service['duration'] as String,
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularServiceItem({
    required int rank,
    required String name,
    required int bookings,
    required double revenue,
    required double avgRating,
    required String duration,
  }) {
    final rankColors = [
      const Color(0xFFFFD700), // Gold
      const Color(0xFFC0C0C0), // Silver
      const Color(0xFFCD7F32), // Bronze
      const Color(0xFF2E7D32), // Green
      const Color(0xFF2E7D32), // Green
    ];
    
    final rankColor = rankColors[rank - 1];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: rankColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: rankColor,
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Row(
                  children: [
                    Icon(Icons.access_time, size: 12, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      duration,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.star, size: 12, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      avgRating.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${revenue.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$bookings bookings',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceRevenueBreakdown() {
    final revenueData = [
      {'service': 'Hair Cut & Styling', 'revenue': 3375.0, 'percentage': 32.1},
      {'service': 'Hair Coloring', 'revenue': 2800.0, 'percentage': 26.7},
      {'service': 'Facial Treatment', 'revenue': 2240.0, 'percentage': 21.3},
      {'service': 'Manicure & Pedicure', 'revenue': 1750.0, 'percentage': 16.7},
      {'service': 'Others', 'revenue': 335.0, 'percentage': 3.2},
    ];
    
    final totalRevenue = revenueData.fold(0.0, (sum, item) => sum + (item['revenue'] as double));

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
                Icon(Icons.pie_chart, color: const Color(0xFF2E7D32), size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Service Revenue Breakdown',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            ...revenueData.map((item) => _buildServiceRevenueItem(
              service: item['service'] as String,
              revenue: item['revenue'] as double,
              percentage: item['percentage'] as double,
            )).toList(),
            
            const SizedBox(height: 16),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    'Total Service Revenue',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${totalRevenue.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
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

  Widget _buildServiceRevenueItem({
    required String service,
    required double revenue,
    required double percentage,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              service,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          
          Expanded(
            flex: 2,
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Colors.grey[200],
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percentage / 100,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: const Color(0xFF2E7D32),
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          SizedBox(
            width: 60,
            child: Text(
              '\$${revenue.toStringAsFixed(0)}',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceDurationAnalysis() {
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
                Icon(Icons.schedule, color: const Color(0xFF2E7D32), size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Service Duration Analysis',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            Row(
              children: [
                Expanded(
                  child: _buildDurationMetric(
                    'Average Duration',
                    '78 min',
                    Icons.access_time,
                    const Color(0xFF2196F3),
                  ),
                ),
                Container(width: 1, height: 60, color: Colors.grey[300]),
                Expanded(
                  child: _buildDurationMetric(
                    'On-Time Completion',
                    '94.2%',
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.insights, color: Colors.blue, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Duration Insights',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• Hair services average 90 minutes vs scheduled 75 minutes\n• Facial treatments are most punctual (98% on-time)\n• Consider adjusting booking slots for better efficiency',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue,
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

  Widget _buildDurationMetric(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
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
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceRatingAnalysis() {
    final ratingDistribution = [
      {'rating': '5 Stars', 'count': 89, 'percentage': 61.4, 'color': const Color(0xFF4CAF50)},
      {'rating': '4 Stars', 'count': 32, 'percentage': 22.1, 'color': const Color(0xFF8BC34A)},
      {'rating': '3 Stars', 'count': 18, 'percentage': 12.4, 'color': const Color(0xFFFF9800)},
      {'rating': '2 Stars', 'count': 4, 'percentage': 2.8, 'color': const Color(0xFFFF5722)},
      {'rating': '1 Star', 'count': 2, 'percentage': 1.4, 'color': const Color(0xFFF44336)},
    ];

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
                Icon(Icons.star_rate, color: const Color(0xFF2E7D32), size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Service Rating Distribution',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        '4.8',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) => Icon(
                          Icons.star,
                          color: index < 5 ? Colors.amber : Colors.grey[300],
                          size: 20,
                        )),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Overall Rating',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 20),
                
                Expanded(
                  flex: 2,
                  child: Column(
                    children: ratingDistribution.map((rating) => _buildRatingDistributionItem(
                      rating: rating['rating'] as String,
                      count: rating['count'] as int,
                      percentage: rating['percentage'] as double,
                      color: rating['color'] as Color,
                    )).toList(),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.emoji_events, color: Colors.amber[700], size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Excellent performance! 83.5% of customers rate services 4+ stars',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.amber[700],
                      ),
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

  Widget _buildRatingDistributionItem({
    required String rating,
    required int count,
    required double percentage,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              rating,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          
          Expanded(
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Colors.grey[200],
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percentage / 100,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: color,
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 8),
          
          SizedBox(
            width: 30,
            child: Text(
              '$count',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
