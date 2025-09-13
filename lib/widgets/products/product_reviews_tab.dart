// lib/widgets/products/product_reviews_tab.dart
import 'package:flutter/material.dart';

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
    final reviews = [
      {
        'name': 'John Doe',
        'rating': 5.0,
        'comment': 'Excellent product! Very satisfied with the quality.',
        'date': '2 days ago',
        'avatar': 'J',
      },
      {
        'name': 'Sarah Smith',
        'rating': 4.0,
        'comment': 'Good product, fast delivery. Recommended!',
        'date': '1 week ago',
        'avatar': 'S',
      },
      {
        'name': 'Mike Johnson',
        'rating': 5.0,
        'comment': 'Amazing quality! Will definitely buy again.',
        'date': '2 weeks ago',
        'avatar': 'M',
      },
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reviews Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Text(
                  'Customer Reviews',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                    fontFamily: "Poppins",
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${productMetrics['averageRating']}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                          fontFamily: "Inter",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Reviews List
          ...reviews.map((review) => _buildReviewItem(review)).toList(),
        ],
      ),
    );
  }

  Widget _buildReviewItem(Map<String, dynamic> review) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFF4FC3F7),
            child: Text(
              review['avatar'],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: "Inter",
              ),
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Review Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      review['name'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2C3E50),
                        fontFamily: "Inter",
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < review['rating'].floor()
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 14,
                        );
                      }),
                    ),
                  ],
                ),
                
                const SizedBox(height: 4),
                
                Text(
                  review['comment'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontFamily: "Inter",
                    height: 1.4,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Row(
                  children: [
                    Text(
                      review['date'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                        fontFamily: "Inter",
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => onReplyToReview(review['name']),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4FC3F7).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Reply',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF4FC3F7),
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
