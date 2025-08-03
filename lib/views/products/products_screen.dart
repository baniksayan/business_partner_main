import 'package:business_partner_main/views/products/add_product_screen.dart';
import 'package:flutter/material.dart';
import '../../widgets/cards/product_card.dart';
import '../../models/product.dart';
import 'search_suggestion_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> with TickerProviderStateMixin {
  final List<Product> _products = [
    Product(
      id: '1',
      image: "assets/images/avocado.png",
      name: "Organic Avocado",
      price: "₹29.99",
      description: "Fresh, creamy organic avocados perfect for salads, toast, and smoothies.",
      category: "Fruits",
      stock: 25,
      inStock: true,
      rating: 4.5,
      reviewCount: 128,
      features: ['100% Organic', 'Rich in Healthy Fats', 'Farm Fresh', 'No Pesticides'],
    ),
    Product(
      id: '2',
      image: "assets/images/strawberry.png",
      name: "Fresh Strawberries",
      price: "₹19.99",
      description: "Sweet, juicy strawberries bursting with flavor and vitamins.",
      category: "Fruits",
      stock: 15,
      inStock: true,
      rating: 4.8,
      reviewCount: 85,
      features: ['Vitamin C Rich', 'Antioxidants', 'Fresh Picked', 'Sweet & Juicy'],
    ),
    Product(
      id: '3',
      image: "assets/images/banana.png",
      name: "Ripe Bananas",
      price: "₹9.99",
      description: "Naturally sweet bananas, perfect for snacking and baking.",
      category: "Fruits",
      stock: 30,
      inStock: true,
      rating: 4.4,
      reviewCount: 67,
      features: ['Potassium Rich', 'Naturally Sweet', 'Energy Booster'],
    ),
    Product(
      id: '4',
      image: "assets/images/mango.png",
      name: "Sweet Mangoes",
      price: "₹14.99",
      description: "Deliciously ripe mangoes for a taste of summer.",
      category: "Fruits",
      stock: 20,
      inStock: true,
      rating: 4.9,
      reviewCount: 150,
      features: ['Tropical Flavor', 'Vitamin A', 'Handpicked'],
    ),
    Product(
      id: '5',
      image: "assets/images/orange.png",
      name: "Juicy Oranges",
      price: "₹12.99",
      description: "Citrusy and juicy oranges to refresh your day.",
      category: "Fruits",
      stock: 18,
      inStock: true,
      rating: 4.6,
      reviewCount: 110,
      features: ['Immunity Booster', 'Citrus Fresh', 'Rich in Vitamin C'],
    ),
  ];

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
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
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF4FC3F7)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchSuggestionScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 6),
              child: Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _showSortBottomSheet,
                    icon: const Icon(Icons.sort_rounded, color: Color(0xFF4FC3F7), size: 20),
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
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                itemCount: _products.length,
                itemBuilder: (context, i) => AnimatedProductCard(
                  product: _products[i],
                  delay: 80 * i,
                  onEdit: () => _editProduct(_products[i]),
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
      ),
    );
  }

  void _showSortBottomSheet() {
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
            _sortOption('Name (A-Z)', Icons.sort_by_alpha),
            _sortOption('Price (Low to High)', Icons.arrow_upward),
            _sortOption('Price (High to Low)', Icons.arrow_downward),
            _sortOption('Recently Added', Icons.access_time),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _sortOption(String title, IconData icon) {
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
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sorted by: $title'),
            backgroundColor: const Color(0xFF4FC3F7),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      },
    );
  }

  void _editProduct(Product product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Editing: ${product.name}'),
        backgroundColor: const Color(0xFF4FC3F7),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    // TODO: Implement actual edit navigation
    // Navigator.push(context, MaterialPageRoute(builder: (context) => EditProductScreen(product: product)));
  }

  void _addNewProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddProductScreen(),
      ),
    );
  }
}
