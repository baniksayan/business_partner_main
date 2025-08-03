// File: lib/widgets/products/product_inventory_tab.dart
import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../common/metric_card_widget.dart';

class ProductInventoryTab extends StatelessWidget {
  final Product product;
  final Map<String, dynamic> productMetrics;
  final VoidCallback onAddStock;
  final VoidCallback onUpdatePrice;

  const ProductInventoryTab({
    Key? key,
    required this.product,
    required this.productMetrics,
    required this.onAddStock,
    required this.onUpdatePrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Stock Management Card
          Container(
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
                const Text(
                  'Inventory Management',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: MetricCardWidget(
                        title: 'Current Stock',
                        value: '${product.stock}',
                        color: product.stock < 10 ? Colors.red : Colors.green,
                        icon: Icons.inventory,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: MetricCardWidget(
                        title: 'Sold This Month',
                        value: '${productMetrics['totalSales']}',
                        color: Colors.blue,
                        icon: Icons.trending_up,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onAddStock,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Stock'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF4FC3F7),
                          side: const BorderSide(color: Color(0xFF4FC3F7)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onUpdatePrice,
                        icon: const Icon(Icons.edit),
                        label: const Text('Update Price'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4FC3F7),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
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