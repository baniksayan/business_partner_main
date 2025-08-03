// File: lib/widgets/products/product_reviews_tab.dart
import 'package:flutter/material.dart';
import '../common/review_item_widget.dart';

class ProductReviewsTab extends StatelessWidget {
  final Map<String, dynamic> productMetrics;
  final Function(String) onReplyToReview;

  const ProductReviewsTab({
    Key? key,
    required this.productMetrics,
    required this.onReplyToReview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Customer Reviews',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              Text(
                '${productMetrics['totalReviews']} reviews',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ReviewItemWidget(
            name: 'Sarah Johnson',
            rating: 5,
            review: 'Excellent quality! Fresh and delicious. Will definitely order again.',
            time: '2 days ago',
            hasReply: false,
            onReply: () => onReplyToReview('Sarah Johnson'),
          ),
          ReviewItemWidget(
            name: 'Mike Chen',
            rating: 4,
            review: 'Good product but delivery was a bit delayed.',
            time: '1 week ago',
            hasReply: true,
            reply: 'Thank you for your feedback! We\'re working on improving our delivery times.',
            onReply: () => onReplyToReview('Mike Chen'),
          ),
        ],
      ),
    );
  }
}