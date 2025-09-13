// lib/views/products/products_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/cards/product_card.dart';
import '../../models/product.dart';
import '../../providers/product_provider.dart';
import 'add_product_screen.dart';
import 'edit_product_screen.dart';
import 'search_suggestion_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen>
    with TickerProviderStateMixin {
  
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    print('🎬 [ProductsScreen] Initializing...');
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );

    // Start animation immediately
    _fadeController.forward();
    
    // Load products in background without showing loader
    _loadProductsInBackground();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _loadProductsInBackground() async {
    print('🔄 [ProductsScreen] Loading products in background...');
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    
    // Load products silently
    await productProvider.getAllProducts(context);
    
    // Just update the UI without showing any loading states
    if (mounted) {
      setState(() {
        // This will trigger a rebuild with the loaded products
      });
    }
  }

  Future<void> _refreshProducts() async {
    print('🔄 [ProductsScreen] Refreshing products...');
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    await productProvider.getAllProducts(context);
    
    if (mounted) {
      setState(() {
        // Refresh UI
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Products",
          style: TextStyle(
            fontFamily: "Poppins",
            color: Color(0xFF2C3E50),
            fontWeight: FontWeight.bold,
            fontSize: 21,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF4FC3F7)),
          onPressed: () {
            print('⬅️ [ProductsScreen] Back button pressed');
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF4FC3F7)),
            onPressed: () {
              print('🔍 [ProductsScreen] Search button pressed');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchSuggestionScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF4FC3F7)),
            onPressed: () {
              print('🔄 [ProductsScreen] Refresh button pressed');
              _refreshProducts();
            },
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          // Always show the main UI, never show loading
          return _buildMainContent(productProvider);
        },
      ),
    );
  }

  Widget _buildMainContent(ProductProvider productProvider) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 6),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => _showSortBottomSheet(productProvider),
                  icon: const Icon(
                    Icons.sort_rounded,
                    color: Color(0xFF4FC3F7),
                    size: 20,
                  ),
                  label: const Text(
                    'Sort',
                    style: TextStyle(
                      color: Color(0xFF4FC3F7),
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    minimumSize: const Size(70, 38),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '${productProvider.products.length} Products',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshProducts,
              color: const Color(0xFF4FC3F7),
              child: productProvider.products.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 5,
                      ),
                      itemCount: productProvider.products.length,
                      itemBuilder: (context, i) => AnimatedProductCard(
                        product: productProvider.products[i],
                        delay: 80 * i,
                        onEdit: () => _editProduct(productProvider.products[i]),
                        onDelete: () => _deleteProduct(productProvider.products[i]),
                      ),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _addNewProduct,
                icon: const Icon(Icons.add, size: 22),
                label: const Text(
                  "Add New Product",
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4FC3F7),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.blue[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: Colors.blue[300],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Products Yet!',
            style: TextStyle(
              fontSize: 24,
              color: Colors.grey[700],
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Start building your product catalog by adding your first product',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[500],
                fontFamily: 'Inter',
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _addNewProduct,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4FC3F7),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            icon: const Icon(Icons.add, size: 24),
            label: const Text(
              'Add Your First Product',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSortBottomSheet(ProductProvider productProvider) {
    print('📊 [ProductsScreen] Sort bottom sheet opened');
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sort Products',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 20),
            _sortOption('Name (A-Z)', Icons.sort_by_alpha, productProvider),
            _sortOption('Price (Low to High)', Icons.arrow_upward, productProvider),
            _sortOption('Price (High to Low)', Icons.arrow_downward, productProvider),
            _sortOption('Recently Added', Icons.access_time, productProvider),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _sortOption(String title, IconData icon, ProductProvider productProvider) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF4FC3F7)),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          color: Color(0xFF2C3E50),
        ),
      ),
      onTap: () {
        print('📊 [ProductsScreen] Sorting by: $title');
        Navigator.pop(context);
        productProvider.sortProducts(title);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sorted by: $title'),
            backgroundColor: const Color(0xFF4FC3F7),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
    );
  }

  void _editProduct(Product product) {
    print('✏️ [ProductsScreen] Edit product: ${product.name}');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProductScreen(product: product),
      ),
    ).then((result) {
      if (result == true) {
        _refreshProducts(); // Refresh after edit
      }
    });
  }

  void _deleteProduct(Product product) {
    print('🗑️ [ProductsScreen] Delete product: ${product.name}');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red[600], size: 28),
            const SizedBox(width: 12),
            const Text('Delete Product'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete "${product.name}"?',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.red[600], size: 20),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'This action cannot be undone. All product data will be permanently removed.',
                      style: TextStyle(fontSize: 12, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => _confirmDelete(product),
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

  void _confirmDelete(Product product) async {
    Navigator.pop(context); // Close dialog
    
    print('🗑️ [ProductsScreen] Confirming delete for product: ${product.name}');
    
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    
    try {
      final success = await productProvider.deleteProduct(context, product.id);
      
      if (success) {
        print('✅ [ProductsScreen] Product deleted successfully');
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.name} deleted successfully! 🎉'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        
        // Refresh the products list
        _refreshProducts();
      } else {
        print('❌ [ProductsScreen] Product deletion failed');
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete product: ${productProvider.errorMessage ?? "Unknown error"}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      print('💥 [ProductsScreen] Exception during delete: $e');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting product: $e'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _addNewProduct() {
    print('➕ [ProductsScreen] Opening Add Product screen');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddProductScreen()),
    ).then((result) {
      print('🔄 [ProductsScreen] Returned from Add Product screen');
      if (result == true) {
        _refreshProducts(); // Refresh after adding
      }
    });
  }
}
