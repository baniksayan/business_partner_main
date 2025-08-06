import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../styles/app_colors.dart';
import '../styles/app_text_styles.dart';
import '../../widgets/customer-widgets/custom_app_bar.dart';

class CustomerWishlistScreen extends StatefulWidget {
  final Map<String, dynamic> customerData;

  const CustomerWishlistScreen({
    Key? key,
    required this.customerData,
  }) : super(key: key);

  @override
  _CustomerWishlistScreenState createState() => _CustomerWishlistScreenState();
}

class _CustomerWishlistScreenState extends State<CustomerWishlistScreen> {
  final List<Map<String, dynamic>> _wishlistItems = [
    {
      'title': 'Luxury Spa Day',
      'price': '₹250',
      'date': 'Added on 01/15/2024',
      'image': 'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?ixlib=rb-4.0.3&auto=format&fit=crop&w=1170&q=80',
      'category': 'Wellness',
    },
    {
      'title': 'Personalized Fitness Plan',
      'price': '₹150',
      'date': 'Added on 02/20/2024',
      'image': 'https://images.unsplash.com/photo-1571019613540-996a69c2a7e5?ixlib=rb-4.0.3&auto=format&fit=crop&w=1170&q=80',
      'category': 'Fitness',
    },
    {
      'title': 'Gourmet Cooking Class',
      'price': '₹100',
      'date': 'Added on 03/05/2024',
      'image': 'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?ixlib=rb-4.0.3&auto=format&fit=crop&w=1170&q=80',
      'category': 'Cooking',
    },
    {
      'title': 'Professional Photography Session',
      'price': '₹300',
      'date': 'Added on 04/10/2024',
      'image': 'https://images.unsplash.com/photo-1554048612-b6ebae92138d?ixlib=rb-4.0.3&auto=format&fit=crop&w=1170&q=80',
      'category': 'Photography',
    },
    {
      'title': 'Weekend Getaway Package',
      'price': '₹500',
      'date': 'Added on 05/15/2024',
      'image': 'https://images.unsplash.com/photo-1469474968028-56623f02e42e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1170&q=80',
      'category': 'Travel',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Customer Wishlist',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: 'SF Pro Display',
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        itemCount: _wishlistItems.length,
        itemBuilder: (context, index) {
          final item = _wishlistItems[index];
          return _buildWishlistCard(item, index);
        },
      ),
    );
  }

  Widget _buildWishlistCard(Map<String, dynamic> item, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            spreadRadius: 0,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left side - Service Image
          Container(
            width: 120,
            height: 120,
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                item['image'] ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  decoration: BoxDecoration(
                    color: _getCategoryColor(item['category']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Icon(
                      _getCategoryIcon(item['category']),
                      size: 40,
                      color: _getCategoryColor(item['category']),
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Right side - Service Details
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 16, top: 12, bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Date with blue color
                  Text(
                    item['date'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF007AFF),
                      fontFamily: 'SF Pro Display',
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 6),
                  
                  // Service Title
                  Text(
                    item['title'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      fontFamily: 'SF Pro Display',
                      letterSpacing: -0.3,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  
                  // Price
                  Text(
                    item['price'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      fontFamily: 'SF Pro Display',
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 12),
                  
                  // Convert to Offer Button
                  Container(
                    width: double.infinity,
                    height: 36,
                    child: OutlinedButton(
                      onPressed: () {
                        _convertToOffer(item);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: BorderSide(
                          color: Color(0xFF007AFF),
                          width: 1.5,
                        ),
                        backgroundColor: Colors.transparent,
                      ),
                      child: Text(
                        'Convert to Offer',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF007AFF),
                          fontFamily: 'SF Pro Display',
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'wellness':
        return Color(0xFFD2691E);
      case 'fitness':
        return Color(0xFF34C759);
      case 'cooking':
        return Color(0xFFFF9500);
      case 'photography':
        return Color(0xFF007AFF);
      case 'travel':
        return Color(0xFF5856D6);
      default:
        return Colors.grey[600]!;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'wellness':
        return Icons.spa_outlined;
      case 'fitness':
        return Icons.fitness_center_outlined;
      case 'cooking':
        return Icons.restaurant_outlined;
      case 'photography':
        return Icons.camera_alt_outlined;
      case 'travel':
        return Icons.flight_outlined;
      default:
        return Icons.star_outline;
    }
  }

  void _convertToOffer(Map<String, dynamic> item) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: EdgeInsets.all(24),
        title: Text(
          'Convert to Offer',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: 'SF Pro Display',
            color: Colors.black87,
            letterSpacing: -0.5,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to convert "${item['title']}" to a special offer?',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'SF Pro Display',
                color: Colors.black54,
                height: 1.4,
                letterSpacing: -0.2,
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xFF007AFF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Price: ${item['price']}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF007AFF),
                  fontFamily: 'SF Pro Display',
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
                fontFamily: 'SF Pro Display',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessSnackBar();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF007AFF),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: Text(
              'Create Offer',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontFamily: 'SF Pro Display',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              'Offer created successfully!',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                fontFamily: 'SF Pro Display',
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF34C759),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 3),
      ),
    );
  }
}