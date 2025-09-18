// lib/views/business/business_analytics_screen.dart - UPDATED WITH APP COLORS & STYLES
import 'package:business_partner_main/resources/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/business_provider.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart';
import '../../resources/colors/app_colors.dart';
// import '../../resources/styles/app_text_styles.dart';
import 'widgets/analytics_summary_card.dart';
import 'widgets/revenue_chart_widget.dart';
import 'widgets/booking_trends_widget.dart';
import 'widgets/customer_insights_widget.dart';

class BusinessAnalyticsScreen extends StatefulWidget {
  const BusinessAnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<BusinessAnalyticsScreen> createState() => _BusinessAnalyticsScreenState();
}

class _BusinessAnalyticsScreenState extends State<BusinessAnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'This Month';
  
  final List<String> _periods = [
    'This Week',
    'This Month',
    'Last 3 Months',
    'This Year'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAnalytics();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadAnalytics() {
    final businessProvider = Provider.of<BusinessProvider>(context, listen: false);
    businessProvider.loadBusinessData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      appBar: AppBar(
        title: Text(
          'Business Analytics',
          style: AppTextStyles.heading3.copyWith(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.splashPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadAnalytics,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.date_range, color: Colors.white),
            onSelected: (period) {
              setState(() {
                _selectedPeriod = period;
              });
            },
            itemBuilder: (context) => _periods.map((period) {
              return PopupMenuItem(
                value: period,
                child: Row(
                  children: [
                    Icon(
                      period == _selectedPeriod ? Icons.check : Icons.calendar_today,
                      size: 16,
                      color: period == _selectedPeriod ? AppColors.splashPrimary : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      period,
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(text: 'Overview', icon: Icon(Icons.dashboard, size: 20)),
            Tab(text: 'Revenue', icon: Icon(Icons.trending_up, size: 20)),
            Tab(text: 'Customers', icon: Icon(Icons.people, size: 20)),
          ],
        ),
      ),
      body: Consumer<BusinessProvider>(
        builder: (context, businessProvider, child) {
          if (businessProvider.isLoading) {
            return const LoadingWidget(message: 'Loading analytics...');
          }

          if (businessProvider.errorMessage != null) {
            return CustomErrorWidget(
              message: businessProvider.errorMessage!,
              onRetry: _loadAnalytics,
            );
          }

          if (!businessProvider.hasData) {
            return Center(
              child: Text(
                'No analytics data available',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.splashSubtext,
                ),
              ),
            );
          }

          final business = businessProvider.business!;

          return Column(
            children: [
              // Period Selector
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.splashPrimary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: AppColors.splashPrimary.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time,
                      color: AppColors.splashPrimary,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _selectedPeriod,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.splashPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOverviewTab(business),
                    _buildRevenueTab(business),
                    _buildCustomersTab(business),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOverviewTab(business) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          AnalyticsSummaryCard(
            business: business,
            selectedPeriod: _selectedPeriod,
          ),
          const SizedBox(height: 16),
          BookingTrendsWidget(
            business: business,
            selectedPeriod: _selectedPeriod,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildRevenueTab(business) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          RevenueChartWidget(
            business: business,
            selectedPeriod: _selectedPeriod,
          ),
          const SizedBox(height: 16),
          _buildRevenueBreakdown(business),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildCustomersTab(business) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          CustomerInsightsWidget(
            business: business,
            selectedPeriod: _selectedPeriod,
          ),
          const SizedBox(height: 16),
          _buildTopCustomers(business),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildRevenueBreakdown(business) {
    final revenueBreakdown = [
      {'service': 'Hair Cut & Styling', 'revenue': 8500.0, 'percentage': 45.3},
      {'service': 'Hair Coloring', 'revenue': 4200.0, 'percentage': 22.4},
      {'service': 'Facial Treatments', 'revenue': 3100.0, 'percentage': 16.5},
      {'service': 'Manicure & Pedicure', 'revenue': 2950.0, 'percentage': 15.8},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.pie_chart, color: AppColors.splashPrimary, size: 24),
              const SizedBox(width: 8),
              Text(
                'Revenue by Service',
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.splashText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...revenueBreakdown.map((item) => _buildRevenueItem(
            item['service'] as String,
            item['revenue'] as double,
            item['percentage'] as double,
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildRevenueItem(String service, double revenue, double percentage) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              service,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.splashText,
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
                    color: AppColors.splashPrimary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              '\$${revenue.toStringAsFixed(0)}',
              textAlign: TextAlign.right,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.splashPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopCustomers(business) {
    final topCustomers = [
      {'name': 'Emma Johnson', 'visits': 12, 'spent': 1850.0, 'lastVisit': '2 days ago'},
      {'name': 'Sarah Williams', 'visits': 8, 'spent': 1420.0, 'lastVisit': '5 days ago'},
      {'name': 'Lisa Brown', 'visits': 10, 'spent': 1320.0, 'lastVisit': '1 week ago'},
      {'name': 'Jessica Davis', 'visits': 6, 'spent': 980.0, 'lastVisit': '3 days ago'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: AppColors.splashSecondary, size: 24),
              const SizedBox(width: 8),
              Text(
                'Top Customers',
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.splashText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...topCustomers.asMap().entries.map((entry) {
            final index = entry.key;
            final customer = entry.value;
            return _buildCustomerItem(
              index + 1,
              customer['name'] as String,
              customer['visits'] as int,
              customer['spent'] as double,
              customer['lastVisit'] as String,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildCustomerItem(int rank, String name, int visits, double spent, String lastVisit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.splashBackground,
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.splashPrimary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.splashPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.splashText,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '$visits visits',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 12,
                        color: AppColors.splashSubtext,
                      ),
                    ),
                    const Text(' • ', style: TextStyle(color: Colors.grey)),
                    Text(
                      'Last: $lastVisit',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 12,
                        color: AppColors.splashSubtext,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            '\$${spent.toStringAsFixed(0)}',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.splashSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
