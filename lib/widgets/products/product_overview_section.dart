// lib/widgets/products/product_overview_section.dart
import 'package:flutter/material.dart';
import '../../models/product.dart';

class ProductOverviewSection extends StatelessWidget {
  final Product product;
  final Map<String, dynamic> productMetrics;

  const ProductOverviewSection({
    Key? key,
    required this.product,
    required this.productMetrics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
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
          // Product Name and Category
          Row(
            children: [
              Expanded(
                child: Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                    fontFamily: "Poppins",
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF4FC3F7).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  product.category,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF4FC3F7),
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Product Code
          if (product.productCode != null)
            Text(
              'SKU: ${product.productCode}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontFamily: "Inter",
              ),
            ),
          
          const SizedBox(height: 16),
          
          // Description
          Text(
            product.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              fontFamily: "Inter",
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Price and Stock Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Price',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.priceDisplay,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4FC3F7),
                        fontFamily: "Poppins",
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: product.inStock ? Colors.green[50] : Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: product.inStock ? Colors.green[200]! : Colors.red[200]!,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      product.inStock ? Icons.check_circle : Icons.cancel,
                      color: product.inStock ? Colors.green[600] : Colors.red[600],
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${product.quantity}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: product.inStock ? Colors.green[700] : Colors.red[700],
                        fontFamily: "Poppins",
                      ),
                    ),
                    Text(
                      'in stock',
                      style: TextStyle(
                        fontSize: 10,
                        color: product.inStock ? Colors.green[600] : Colors.red[600],
                        fontFamily: "Inter",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
