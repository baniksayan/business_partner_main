// lib/views/business/widgets/customer_report_widget.dart
import 'package:flutter/material.dart';
import '../../../models/business.dart';

class CustomerReportWidget extends StatelessWidget {
  final Business business;
  final String period;
  final DateTime startDate;
  final DateTime endDate;

  const CustomerReportWidget({
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
        // Customer Overview
        _buildCustomerOverview(),
        
        const SizedBox(height: 16),
        
        // Customer Segmentation
        _buildCustomerSegmentation(),
        
        const SizedBox(height: 16),
        
        // Top Customers
        _buildTopCustomers(),
        
        const SizedBox(height: 16),
        
        // Customer Acquisition
        _buildCustomerAcquisition(),
        
        const SizedBox(height: 16),
        
        // Customer Retention Analysis
        _buildCustomerRetention(),
      ],
    );
  }

  Widget _buildCustomerOverview() {
    final overviewData = [
      {'title': 'Total Customers', 'value': '432', 'change': '+18.5%', 'trend': 'up', 'icon': Icons.people, 'color': const Color(0xFF2196F3)},
      {'title': 'New Customers', 'value': '28', 'change': '+12.3%', 'trend': 'up', 'icon': Icons.person_add, 'color': const Color(0xFF4CAF50)},
      {'title': 'Returning Customers', 'value': '158', 'change': '+8.7%', 'trend': 'up', 'icon': Icons.repeat, 'color': const Color(0xFFFF9800)},
      {'title': 'Customer Lifetime Value', 'value': '\$287', 'change': '+15.2%', 'trend': 'up', 'icon': Icons.attach_money, 'color': const Color(0xFF9C27B0)},
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
                Icon(Icons.dashboard, color: const Color(0xFF2E7D32), size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Customer Overview',
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
              itemCount: overviewData.length,
              itemBuilder: (context, index) {
                final data = overviewData[index];
                return _buildOverviewCard(
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

  Widget _buildOverviewCard({
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

  Widget _buildCustomerSegmentation() {
    final segments = [
      {'label': 'VIP Customers', 'count': 24, 'percentage': 15.0, 'color': const Color(0xFF9C27B0), 'description': 'Spent over \$500'},
      {'label': 'Regular Customers', 'count': 156, 'percentage': 65.0, 'color': const Color(0xFF2196F3), 'description': '3+ visits'},
      {'label': 'New Customers', 'count': 48, 'percentage': 20.0, 'color': const Color(0xFF4CAF50), 'description': 'First time visitors'},
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
                Icon(Icons.pie_chart, color: const Color(0xFF2E7D32), size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Customer Segmentation',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            ...segments.map((segment) => _buildSegmentItem(
              label: segment['label'] as String,
              count: segment['count'] as int,
              percentage: segment['percentage'] as double,
              color: segment['color'] as Color,
              description: segment['description'] as String,
            )).toList(),
            
            const SizedBox(height: 16),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.insights, color: const Color(0xFF2E7D32), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Focus on VIP customer retention - they contribute 45% of total revenue',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E7D32),
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

  Widget _buildSegmentItem({
    required String label,
    required int count,
    required double percentage,
    required Color color,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$count customers',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.grey[200],
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: percentage / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: color,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopCustomers() {
    final topCustomers = [
      {'name': 'Emma Johnson', 'email': 'emma.j@email.com', 'visits': 12, 'spent': 1850.0, 'lastVisit': '2 days ago', 'status': 'VIP'},
      {'name': 'Sarah Williams', 'email': 'sarah.w@email.com', 'visits': 8, 'spent': 1420.0, 'lastVisit': '5 days ago', 'status': 'Regular'},
      {'name': 'Lisa Brown', 'email': 'lisa.b@email.com', 'visits': 10, 'spent': 1320.0, 'lastVisit': '1 week ago', 'status': 'VIP'},
      {'name': 'Jessica Davis', 'email': 'jessica.d@email.com', 'visits': 6, 'spent': 980.0, 'lastVisit': '3 days ago', 'status': 'Regular'},
      {'name': 'Maria Garcia', 'email': 'maria.g@email.com', 'visits': 9, 'spent': 1650.0, 'lastVisit': '4 days ago', 'status': 'VIP'},
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
                  'Top Customers',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    // Navigate to full customer list
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
            
            ...topCustomers.asMap().entries.map((entry) {
              final index = entry.key;
              final customer = entry.value;
              return _buildTopCustomerItem(
                rank: index + 1,
                name: customer['name'] as String,
                email: customer['email'] as String,
                visits: customer['visits'] as int,
                spent: customer['spent'] as double,
                lastVisit: customer['lastVisit'] as String,
                status: customer['status'] as String,
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopCustomerItem({
    required int rank,
    required String name,
    required String email,
    required int visits,
    required double spent,
    required String lastVisit,
    required String status,
  }) {
    final statusColor = status == 'VIP' ? const Color(0xFF9C27B0) : const Color(0xFF2196F3);
    
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
              color: const Color(0xFF2E7D32).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ),
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
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 4),
                
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Row(
                  children: [
                    Text(
                      '$visits visits',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const Text(' • ', style: TextStyle(color: Colors.grey)),
                    Text(
                      'Last: $lastVisit',
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
                '\$${spent.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              Text(
                'Total Spent',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerAcquisition() {
    final acquisitionSources = [
      {'source': 'Social Media', 'count': 12, 'percentage': 42.9, 'color': const Color(0xFFE91E63)},
      {'source': 'Referrals', 'count': 8, 'percentage': 28.6, 'color': const Color(0xFF4CAF50)},
      {'source': 'Walk-ins', 'count': 5, 'percentage': 17.9, 'color': const Color(0xFF2196F3)},
      {'source': 'Online Search', 'count': 3, 'percentage': 10.7, 'color': const Color(0xFFFF9800)},
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
                Icon(Icons.person_add, color: const Color(0xFF2E7D32), size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Customer Acquisition Sources',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            ...acquisitionSources.map((source) => _buildAcquisitionSourceItem(
              source: source['source'] as String,
              count: source['count'] as int,
              percentage: source['percentage'] as double,
              color: source['color'] as Color,
            )).toList(),
            
            const SizedBox(height: 16),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE91E63).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.trending_up, color: const Color(0xFFE91E63), size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Social media is your top acquisition channel - consider increasing investment',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE91E63),
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

  Widget _buildAcquisitionSourceItem({
    required String source,
    required int count,
    required double percentage,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          const SizedBox(width: 12),
          
          Expanded(
            flex: 2,
            child: Text(
              source,
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
                    color: color,
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          SizedBox(
            width: 40,
            child: Text(
              '$count',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerRetention() {
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
                Icon(Icons.repeat, color: const Color(0xFF2E7D32), size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Customer Retention Analysis',
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
                  child: _buildRetentionMetric(
                    'Retention Rate',
                    '89.2%',
                    '+5.4%',
                    Icons.trending_up,
                    Colors.green,
                  ),
                ),
                Container(width: 1, height: 60, color: Colors.grey[300]),
                Expanded(
                  child: _buildRetentionMetric(
                    'Churn Rate',
                    '10.8%',
                    '-2.1%',
                    Icons.trending_down,
                    Colors.red,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Retention Insights',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• Customers who book within 30 days have 95% retention rate\n• Weekend bookings show higher satisfaction scores\n• Loyalty program members visit 40% more frequently',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green,
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

  Widget _buildRetentionMetric(
    String title,
    String value,
    String change,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Text(
              change,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
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
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
