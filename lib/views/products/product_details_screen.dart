// File: lib/views/products/product_details_screen.dart
import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../widgets/products/product_details_app_bar.dart';
import '../../widgets/products/product_overview_section.dart';
import '../../widgets/products/performance_metrics_section.dart';
import '../../widgets/common/custom_tab_navigation.dart';
import '../../widgets/products/product_reviews_tab.dart';
import '../../widgets/products/product_inventory_tab.dart';
import '../../widgets/products/product_analytics_tab.dart';
import '../../widgets/products/product_action_bar.dart';
import '../../widgets/products/product_options_bottom_sheet.dart';
import '../../widgets/dialogs/reply_dialog_widget.dart';
import '../../widgets/dialogs/stock_dialog_widget.dart';
import '../../widgets/dialogs/price_dialog_widget.dart';
// import '../../widgets/dialogs/confirmation_dialog.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  int _selectedTab = 0;
  final List<String> _tabs = ['Reviews', 'Inventory', 'Analytics'];

  // Business metrics (static data for now)
  final Map<String, dynamic> _productMetrics = {
    'totalSales': 156,
    'revenue': 4680.44,
    'views': 1248,
    'conversionRate': 12.5,
    'averageRating': 4.5,
    'totalReviews': 23,
    'stockAlerts': true,
    'lowStockThreshold': 5,
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));
  }

  void _startAnimationSequence() async {
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    _slideController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _scaleController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            // Business Owner App Bar
            ProductDetailsAppBar(
              product: widget.product,
              scaleAnimation: _scaleAnimation,
              onEdit: _editProduct,
              onShowOptions: _showProductOptions,
            ),
            
            // Product Management Content
            SliverToBoxAdapter(
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Overview Section
                    ProductOverviewSection(
                      product: widget.product,
                      productMetrics: _productMetrics,
                    ),
                    
                    // Performance Metrics
                    PerformanceMetricsSection(
                      productMetrics: _productMetrics,
                    ),
                    
                    // Tab Navigation
                    CustomTabNavigation(
                      tabs: _tabs,
                      selectedTab: _selectedTab,
                      onTabChanged: (index) {
                        setState(() {
                          _selectedTab = index;
                        });
                      },
                    ),
                    
                    // Tab Content
                    _buildTabContent(),
                    
                    const SizedBox(height: 100), // Space for bottom button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Business action buttons
      bottomNavigationBar: ProductActionBar(
        onShare: _shareProduct,
        onEdit: _editProduct,
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return ProductReviewsTab(
          productMetrics: _productMetrics,
          onReplyToReview: _replyToReview,
        );
      case 1:
        return ProductInventoryTab(
          product: widget.product,
          productMetrics: _productMetrics,
          onAddStock: _addStock,
          onUpdatePrice: _updatePrice,
        );
      case 2:
        return ProductAnalyticsTab(
          productMetrics: _productMetrics,
        );
      default:
        return ProductReviewsTab(
          productMetrics: _productMetrics,
          onReplyToReview: _replyToReview,
        );
    }
  }

  // Business Owner Actions
  void _editProduct() {
    Navigator.pushNamed(context, '/edit-product', arguments: widget.product);
  }

  void _shareProduct() {
    // Implement product sharing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Product link copied to clipboard!'),
        backgroundColor: Color(0xFF4FC3F7),
      ),
    );
  }

  void _showProductOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductOptionsBottomSheet(
        onEdit: _editProduct,
        onDuplicate: () {
          // Implement duplicate
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product duplicated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        },
        onArchive: () {
          // Implement archive
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Product archived successfully!'),
              backgroundColor: Colors.orange,
            ),
          );
        },
        onDelete: _confirmDeleteProduct,
      ),
    );
  }

  void _replyToReview(String customerName) {
    showDialog(
      context: context,
      builder: (context) => ReplyDialogWidget(
        customerName: customerName,
        onReplySent: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Reply sent successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  void _addStock() {
    showDialog(
      context: context,
      builder: (context) => StockDialogWidget(
        onStockAdded: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Stock updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  void _updatePrice() {
    showDialog(
      context: context,
      builder: (context) => PriceDialogWidget(
        product: widget.product,
        onPriceUpdated: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Price updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  void _confirmDeleteProduct() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Product'),
        content: const Text('Are you sure you want to delete this product? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Go back to products list
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Product deleted successfully!'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}