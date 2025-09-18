// lib/views/business/business_performance_screen.dart - UPDATED WITH APP COLORS & STYLES
import 'package:business_partner_main/resources/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/business_provider.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart';
import '../../resources/colors/app_colors.dart';
// import '../../resources/styles/app_text_styles.dart';
import 'widgets/performance_kpi_grid.dart';
import 'widgets/performance_chart_section.dart';
import 'widgets/goals_progress_widget.dart';
import 'widgets/recent_activities_widget.dart';

class BusinessPerformanceScreen extends StatefulWidget {
  const BusinessPerformanceScreen({Key? key}) : super(key: key);

  @override
  State<BusinessPerformanceScreen> createState() => _BusinessPerformanceScreenState();
}

class _BusinessPerformanceScreenState extends State<BusinessPerformanceScreen> {
  String _selectedTimeframe = 'This Month';
  final List<String> _timeframes = [
    'Today',
    'This Week',
    'This Month',
    'Last 3 Months',
    'This Year',
  ];

  @override
  void initState() {
    super.initState();
    _loadPerformanceData();
  }

  void _loadPerformanceData() {
    final businessProvider = Provider.of<BusinessProvider>(context, listen: false);
    businessProvider.loadBusinessData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      appBar: AppBar(
        title: Text(
          'Performance Dashboard',
          style: AppTextStyles.heading3.copyWith(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.splashSecondary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.calendar_today, color: Colors.white),
            onSelected: (timeframe) {
              setState(() {
                _selectedTimeframe = timeframe;
              });
            },
            itemBuilder: (context) => _timeframes.map((timeframe) {
              return PopupMenuItem(
                value: timeframe,
                child: Row(
                  children: [
                    Icon(
                      timeframe == _selectedTimeframe ? Icons.check : Icons.schedule,
                      size: 16,
                      color: timeframe == _selectedTimeframe 
                          ? AppColors.splashSecondary
                          : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      timeframe,
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadPerformanceData,
          ),
        ],
      ),
      body: Consumer<BusinessProvider>(
        builder: (context, businessProvider, child) {
          if (businessProvider.isLoading) {
            return const LoadingWidget(message: 'Loading performance data...');
          }

          if (businessProvider.errorMessage != null) {
            return CustomErrorWidget(
              message: businessProvider.errorMessage!,
              onRetry: _loadPerformanceData,
            );
          }

          if (!businessProvider.hasData) {
            return Center(
              child: Text(
                'No performance data available',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.splashSubtext,
                ),
              ),
            );
          }

          final business = businessProvider.business!;

          return RefreshIndicator(
            onRefresh: () async => _loadPerformanceData(),
            color: AppColors.splashSecondary,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Timeframe Indicator
                  _buildTimeframeIndicator(),
                  
                  const SizedBox(height: 16),
                  
                  // KPI Grid
                  PerformanceKpiGrid(
                    business: business,
                    timeframe: _selectedTimeframe,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Performance Charts
                  PerformanceChartSection(
                    business: business,
                    timeframe: _selectedTimeframe,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Goals Progress
                  GoalsProgressWidget(
                    business: business,
                    timeframe: _selectedTimeframe,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Recent Activities
                  RecentActivitiesWidget(
                    business: business,
                  ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showGoalsDialog,
        backgroundColor: AppColors.splashSecondary,
        icon: const Icon(Icons.flag, color: Colors.white),
        label: Text(
          'Set Goals',
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeframeIndicator() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.splashSecondary, AppColors.splashAccent],
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
          const Icon(Icons.insights, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Performance Overview',
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Showing data for $_selectedTimeframe',
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
              _selectedTimeframe,
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

  void _showGoalsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.flag, color: AppColors.splashAccent),
            const SizedBox(width: 8),
            Text(
              'Set Performance Goals',
              style: AppTextStyles.labelLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildGoalInputField('Monthly Revenue Target', 'Enter amount'),
            const SizedBox(height: 16),
            _buildGoalInputField('Booking Target', 'Enter number'),
            const SizedBox(height: 16),
            _buildGoalInputField('New Customer Target', 'Enter number'),
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
                    'Goals updated successfully!',
                    style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                  ),
                  backgroundColor: AppColors.splashSecondary,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.splashSecondary,
            ),
            child: Text(
              'Save Goals', 
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalInputField(String label, String hint) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.bodyMedium,
        hintText: hint,
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.splashSubtext,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.splashSecondary),
        ),
      ),
    );
  }
}
