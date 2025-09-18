// lib/views/business/widgets/business_stats_grid.dart
import 'package:flutter/material.dart';
import '../../../models/business.dart';

class BusinessStatsGrid extends StatelessWidget {
  final BusinessStats stats;

  const BusinessStatsGrid({
    Key? key,
    required this.stats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Business Overview',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // First Row - Bookings
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Total Bookings',
                value: stats.totalBookings.toString(),
                icon: Icons.calendar_today,
                color: const Color(0xFF1976D2),
                subtitle: '${stats.activeBookings} active',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'Completed',
                value: stats.completedBookings.toString(),
                icon: Icons.check_circle,
                color: const Color(0xFF388E3C),
                subtitle: '${((stats.completedBookings / stats.totalBookings) * 100).toStringAsFixed(1)}% rate',
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Second Row - Customers & Revenue
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Total Customers',
                value: stats.totalCustomers.toString(),
                icon: Icons.people,
                color: const Color(0xFF7B1FA2),
                subtitle: '${stats.activeCustomers} active',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'Monthly Revenue',
                value: '\$${_formatCurrency(stats.monthlyRevenue)}',
                icon: Icons.trending_up,
                color: const Color(0xFFFF9800),
                subtitle: 'This month',
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Third Row - Products & Total Revenue
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'Products',
                value: stats.totalProducts.toString(),
                icon: Icons.inventory,
                color: const Color(0xFFE91E63),
                subtitle: '${stats.activeProducts} active',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'Total Revenue',
                value: '\$${_formatCurrency(stats.totalRevenue)}',
                icon: Icons.account_balance_wallet,
                color: const Color(0xFF00796B),
                subtitle: 'All time',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String subtitle,
  }) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
          ),
        ),
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
                  child: Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    Icons.trending_up,
                    color: color,
                    size: 12,
                  ),
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
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            
            const SizedBox(height: 2),
            
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return amount.toStringAsFixed(0);
    }
  }
}
