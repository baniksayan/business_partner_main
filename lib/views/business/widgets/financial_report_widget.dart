// lib/views/business/widgets/financial_report_widget.dart
import 'package:flutter/material.dart';
import '../../../models/business.dart';

class FinancialReportWidget extends StatelessWidget {
  final Business business;
  final String period;
  final DateTime startDate;
  final DateTime endDate;

  const FinancialReportWidget({
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
        // Revenue Breakdown
        _buildRevenueBreakdown(),
        
        const SizedBox(height: 16),
        
        // Expense Analysis
        _buildExpenseAnalysis(),
        
        const SizedBox(height: 16),
        
        // Payment Methods
        _buildPaymentMethods(),
        
        const SizedBox(height: 16),
        
        // Profit & Loss
        _buildProfitLoss(),
      ],
    );
  }

  Widget _buildRevenueBreakdown() {
    final revenueData = [
      {'service': 'Hair Cut & Styling', 'amount': 8500.0, 'percentage': 45.3},
      {'service': 'Hair Coloring', 'amount': 4200.0, 'percentage': 22.4},
      {'service': 'Facial Treatments', 'amount': 3100.0, 'percentage': 16.5},
      {'service': 'Manicure & Pedicure', 'amount': 2950.0, 'percentage': 15.8},
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
                  'Revenue Breakdown by Service',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            ...revenueData.map((item) => _buildRevenueItem(
              service: item['service'] as String,
              amount: item['amount'] as double,
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
                    'Total Revenue',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${_formatCurrency(18750.0)}',
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

  Widget _buildRevenueItem({
    required String service,
    required double amount,
    required double percentage,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
                    color: const Color(0xFF2E7D32),
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          SizedBox(
            width: 80,
            child: Text(
              '\$${_formatCurrency(amount)}',
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

  Widget _buildExpenseAnalysis() {
    final expenses = [
      {'category': 'Staff Salaries', 'amount': 5200.0, 'color': Colors.red},
      {'category': 'Rent & Utilities', 'amount': 2800.0, 'color': Colors.orange},
      {'category': 'Supplies & Products', 'amount': 1950.0, 'color': Colors.blue},
      {'category': 'Marketing', 'amount': 850.0, 'color': Colors.purple},
      {'category': 'Other', 'amount': 400.0, 'color': Colors.grey},
    ];

    final totalExpenses = expenses.fold(0.0, (sum, item) => sum + (item['amount'] as double));

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
                Icon(Icons.money_off, color: Colors.red, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Expense Analysis',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            ...expenses.map((expense) => _buildExpenseItem(
              category: expense['category'] as String,
              amount: expense['amount'] as double,
              color: expense['color'] as Color,
              totalExpenses: totalExpenses,
            )).toList(),
            
            const SizedBox(height: 16),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    'Total Expenses',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${_formatCurrency(totalExpenses)}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
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

  Widget _buildExpenseItem({
    required String category,
    required double amount,
    required Color color,
    required double totalExpenses,
  }) {
    final percentage = (amount / totalExpenses) * 100;
    
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
            child: Text(
              category,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          
          Text(
            '${percentage.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          
          const SizedBox(width: 12),
          
          Text(
            '\$${_formatCurrency(amount)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
    final paymentMethods = [
      {'method': 'Card Payments', 'amount': 12400.0, 'percentage': 66.1, 'icon': Icons.credit_card},
      {'method': 'Cash', 'amount': 4200.0, 'percentage': 22.4, 'icon': Icons.money},
      {'method': 'Digital Wallet', 'amount': 2150.0, 'percentage': 11.5, 'icon': Icons.account_balance_wallet},
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
                Icon(Icons.payment, color: const Color(0xFF2E7D32), size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Payment Methods',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            ...paymentMethods.map((method) => _buildPaymentMethodItem(
              method: method['method'] as String,
              amount: method['amount'] as double,
              percentage: method['percentage'] as double,
              icon: method['icon'] as IconData,
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodItem({
    required String method,
    required double amount,
    required double percentage,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF2E7D32), size: 20),
          ),
          
          const SizedBox(width: 16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  method,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${percentage.toStringAsFixed(1)}% of total payments',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          Text(
            '\$${_formatCurrency(amount)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfitLoss() {
    final revenue = 18750.0;
    final expenses = 11200.0;
    final profit = revenue - expenses;
    final profitMargin = (profit / revenue) * 100;

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
                  'Profit & Loss Summary',
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
                  child: _buildPLItem('Revenue', revenue, Colors.green),
                ),
                Container(width: 1, height: 60, color: Colors.grey[300]),
                Expanded(
                  child: _buildPLItem('Expenses', expenses, Colors.red),
                ),
                Container(width: 1, height: 60, color: Colors.grey[300]),
                Expanded(
                  child: _buildPLItem('Net Profit', profit, const Color(0xFF2E7D32)),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF2E7D32).withOpacity(0.1),
                    const Color(0xFF4CAF50).withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.percent, color: const Color(0xFF2E7D32), size: 20),
                  const SizedBox(width: 12),
                  Text(
                    'Profit Margin: ${profitMargin.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 16,
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

  Widget _buildPLItem(String label, double amount, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '\$${_formatCurrency(amount)}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }
}
