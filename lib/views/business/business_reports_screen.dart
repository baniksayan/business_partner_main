// lib/views/business/business_reports_screen.dart - UPDATED WITH APP COLORS & STYLES
import 'package:business_partner_main/resources/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/business_provider.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart';
import '../../resources/colors/app_colors.dart';
// import '../../resources/styles/app_text_styles.dart';
import 'widgets/report_summary_cards.dart';
import 'widgets/financial_report_widget.dart';
import 'widgets/customer_report_widget.dart';
import 'widgets/service_report_widget.dart';
import 'widgets/export_report_widget.dart';

class BusinessReportsScreen extends StatefulWidget {
  const BusinessReportsScreen({Key? key}) : super(key: key);

  @override
  State<BusinessReportsScreen> createState() => _BusinessReportsScreenState();
}

class _BusinessReportsScreenState extends State<BusinessReportsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'This Month';
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  final List<String> _periods = [
    'Today',
    'This Week', 
    'This Month',
    'Last Month',
    'This Quarter',
    'This Year',
    'Custom Range'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadReports();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadReports() {
    final businessProvider = Provider.of<BusinessProvider>(context, listen: false);
    businessProvider.loadBusinessData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      appBar: AppBar(
        title: Text(
          'Business Reports',
          style: AppTextStyles.heading3.copyWith(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.splashAccent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.date_range, color: Colors.white),
            onSelected: _onPeriodSelected,
            itemBuilder: (context) => _periods.map((period) {
              return PopupMenuItem(
                value: period,
                child: Row(
                  children: [
                    Icon(
                      period == _selectedPeriod ? Icons.check : Icons.calendar_today,
                      size: 16,
                      color: period == _selectedPeriod 
                          ? AppColors.splashAccent
                          : Colors.grey,
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
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: _showExportDialog,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          isScrollable: true,
          labelStyle: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(text: 'Overview', icon: Icon(Icons.dashboard, size: 18)),
            Tab(text: 'Financial', icon: Icon(Icons.attach_money, size: 18)),
            Tab(text: 'Customers', icon: Icon(Icons.people, size: 18)),
            Tab(text: 'Services', icon: Icon(Icons.design_services, size: 18)),
          ],
        ),
      ),
      body: Consumer<BusinessProvider>(
        builder: (context, businessProvider, child) {
          if (businessProvider.isLoading) {
            return const LoadingWidget(message: 'Generating reports...');
          }

          if (businessProvider.errorMessage != null) {
            return CustomErrorWidget(
              message: businessProvider.errorMessage!,
              onRetry: _loadReports,
            );
          }

          if (!businessProvider.hasData) {
            return Center(
              child: Text(
                'No data available for reports',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.splashSubtext,
                ),
              ),
            );
          }

          final business = businessProvider.business!;

          return Column(
            children: [
              // Period Indicator
              _buildPeriodIndicator(),
              
              // Tab Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOverviewTab(business),
                    _buildFinancialTab(business),
                    _buildCustomersTab(business),
                    _buildServicesTab(business),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showReportScheduleDialog,
        backgroundColor: AppColors.splashAccent,
        icon: const Icon(Icons.schedule, color: Colors.white),
        label: Text(
          'Schedule Reports',
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodIndicator() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.splashAccent, AppColors.splashDots],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.assessment, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Business Reports Dashboard',
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getPeriodDescription(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _selectedPeriod,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(business) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          ReportSummaryCards(
            business: business,
            period: _selectedPeriod,
            startDate: _startDate,
            endDate: _endDate,
          ),
          const SizedBox(height: 16),
          _buildQuickInsights(business),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildFinancialTab(business) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          FinancialReportWidget(
            business: business,
            period: _selectedPeriod,
            startDate: _startDate,
            endDate: _endDate,
          ),
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
          CustomerReportWidget(
            business: business,
            period: _selectedPeriod,
            startDate: _startDate,
            endDate: _endDate,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildServicesTab(business) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          ServiceReportWidget(
            business: business,
            period: _selectedPeriod,
            startDate: _startDate,
            endDate: _endDate,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildQuickInsights(business) {
    final insights = [
      {
        'title': 'Peak Performance Day',
        'value': 'Saturday',
        'description': 'Highest revenue and bookings',
        'icon': Icons.trending_up,
        'color': AppColors.splashPrimary,
      },
      {
        'title': 'Top Service Category',
        'value': 'Hair Services',
        'description': '68% of total bookings',
        'icon': Icons.star,
        'color': AppColors.splashSecondary,
      },
      {
        'title': 'Customer Satisfaction',
        'value': '4.8/5.0',
        'description': 'Based on 156 reviews',
        'icon': Icons.sentiment_very_satisfied,
        'color': AppColors.splashAccent,
      },
      {
        'title': 'Growth Trend',
        'value': '+23%',
        'description': 'Compared to last period',
        'icon': Icons.analytics,
        'color': AppColors.splashDots,
      },
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
              Icon(Icons.lightbulb, color: AppColors.splashAccent, size: 24),
              const SizedBox(width: 8),
              Text(
                'Quick Insights',
                style: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.splashText,
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
              childAspectRatio: 1.2,
            ),
            itemCount: insights.length,
            itemBuilder: (context, index) {
              final insight = insights[index];
              return _buildInsightCard(
                title: insight['title'] as String,
                value: insight['value'] as String,
                description: insight['description'] as String,
                icon: insight['icon'] as IconData,
                color: insight['color'] as Color,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard({
    required String title,
    required String value,
    required String description,
    required IconData icon,
    required Color color,
  }) {
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
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.info_outline, color: color, size: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTextStyles.labelMedium.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.splashText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 10,
              color: AppColors.splashSubtext,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _onPeriodSelected(String period) {
    setState(() {
      _selectedPeriod = period;
    });

    if (period == 'Custom Range') {
      _showDateRangePicker();
    } else {
      _updateDateRange(period);
    }
  }

  void _updateDateRange(String period) {
    final now = DateTime.now();
    switch (period) {
      case 'Today':
        _startDate = DateTime(now.year, now.month, now.day);
        _endDate = now;
        break;
      case 'This Week':
        _startDate = now.subtract(Duration(days: now.weekday - 1));
        _endDate = now;
        break;
      case 'This Month':
        _startDate = DateTime(now.year, now.month, 1);
        _endDate = now;
        break;
      case 'Last Month':
        final lastMonth = DateTime(now.year, now.month - 1, 1);
        _startDate = lastMonth;
        _endDate = DateTime(now.year, now.month, 0);
        break;
      case 'This Quarter':
        final quarter = ((now.month - 1) / 3).floor();
        _startDate = DateTime(now.year, quarter * 3 + 1, 1);
        _endDate = now;
        break;
      case 'This Year':
        _startDate = DateTime(now.year, 1, 1);
        _endDate = now;
        break;
    }
  }

  Future<void> _showDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  String _getPeriodDescription() {
    if (_selectedPeriod == 'Custom Range') {
      return '${_startDate.day}/${_startDate.month}/${_startDate.year} - ${_endDate.day}/${_endDate.month}/${_endDate.year}';
    }
    return 'Report data for $_selectedPeriod';
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => ExportReportWidget(
        period: _selectedPeriod,
        startDate: _startDate,
        endDate: _endDate,
      ),
    );
  }

  void _showReportScheduleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.schedule, color: AppColors.splashAccent),
            const SizedBox(width: 8),
            Text(
              'Schedule Reports',
              style: AppTextStyles.labelLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Set up automated report delivery to your email.',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Frequency',
                labelStyle: AppTextStyles.bodyMedium,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              items: ['Daily', 'Weekly', 'Monthly'].map((freq) {
                return DropdownMenuItem(value: freq, child: Text(freq));
              }).toList(),
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email Address',
                labelStyle: AppTextStyles.bodyMedium,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: AppTextStyles.bodyMedium,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Report schedule saved successfully!',
                    style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                  ),
                  backgroundColor: AppColors.splashAccent,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.splashAccent),
            child: Text(
              'Schedule', 
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
