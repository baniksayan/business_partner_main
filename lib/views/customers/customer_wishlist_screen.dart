import 'package:flutter/material.dart';
import '../../resources/colors/app_colors.dart';
import 'choose_offer_template_screen.dart';
import 'customers_list_screen.dart'; // For Customer class

class CustomerWishlistScreen extends StatelessWidget {
  final Customer customer;
  const CustomerWishlistScreen({Key? key, required this.customer}) : super(key: key);

  // Example static wishlist data
  final List<Map<String, dynamic>> wishlist = const [
    {
      'date': '01/15/2024',
      'title': 'Luxury Spa Day',
      'price': '₹250',
      'image': 'assets/images/spa.jpg',
    },
    {
      'date': '02/20/2024',
      'title': 'Personalized Fitness Plan',
      'price': '₹150',
      'image': 'assets/images/fitness.jpg',
    },
    {
      'date': '03/05/2024',
      'title': 'Gourmet Cooking Class',
      'price': '₹100',
      'image': 'assets/images/cooking.jpg',
    },
    {
      'date': '04/10/2024',
      'title': 'Professional Photography Session',
      'price': '₹300',
      'image': 'assets/images/photography.jpg',
    },
    {
      'date': '05/15/2024',
      'title': 'Weekend Getaway Package',
      'price': '₹500',
      'image': 'assets/images/getaway.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.splashText),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          'Customer Wishlist',
          style: TextStyle(
            color: AppColors.splashText,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: wishlist.length,
        itemBuilder: (context, i) {
          final item = wishlist[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 18),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Added on ${item['date']}',
                        style: TextStyle(
                          color: AppColors.splashSubtext,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.splashText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item['price'],
                        style: TextStyle(
                          color: AppColors.splashDots,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChooseOfferTemplateScreen(
                                wishlistItem: item,
                                customer: customer,
                              ),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.splashDots,
                          side: BorderSide(color: AppColors.splashDots),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Convert to Offer'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    item['image'],
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 70,
                      height: 70,
                      color: AppColors.splashSecondary.withOpacity(0.08),
                      child: Icon(Icons.image_not_supported, color: AppColors.splashSecondary, size: 32),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}