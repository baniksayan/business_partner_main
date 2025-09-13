// lib/widgets/products/product_inventory_tab.dart
import 'package:flutter/material.dart';
import '../../models/product.dart';

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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Inventory Management',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
                fontFamily: "Poppins",
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Stock Level Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: product.quantity < 10 ? Colors.red[50] : Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: product.quantity < 10 ? Colors.red[200]! : Colors.green[200]!,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    product.quantity < 10 ? Icons.warning : Icons.check_circle,
                    color: product.quantity < 10 ? Colors.red : Colors.green,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.quantity < 10 ? 'Low Stock Alert' : 'Stock Level Good',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: product.quantity < 10 ? Colors.red[700] : Colors.green[700],
                            fontFamily: "Inter",
                          ),
                        ),
                        Text(
                          '${product.quantity} units available',
                          style: TextStyle(
                            fontSize: 12,
                            color: product.quantity < 10 ? Colors.red[600] : Colors.green[600],
                            fontFamily: "Inter",
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${product.quantity}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: product.quantity < 10 ? Colors.red : Colors.green,
                      fontFamily: "Poppins",
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Price Information
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4FC3F7).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Current Price',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF4FC3F7),
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.priceDisplay,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4FC3F7),
                            fontFamily: "Poppins",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Product Code',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.productCode ?? 'N/A',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                            fontFamily: "Inter",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onAddStock,
                    icon: const Icon(Icons.add_box, color: Color(0xFF4FC3F7)),
                    label: const Text(
                      'Add Stock',
                      style: TextStyle(
                        color: Color(0xFF4FC3F7),
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF4FC3F7)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onUpdatePrice,
                    icon: const Icon(Icons.attach_money, color: Colors.green),
                    label: const Text(
                      'Update Price',
                      style: TextStyle(
                        color: Colors.green,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.green),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Inventory History (Mock data)
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
                fontFamily: "Poppins",
              ),
            ),
            
            const SizedBox(height: 12),
            
            _buildActivityItem('Stock Added', '+50 units', '2 days ago', Icons.add_circle, Colors.green),
            _buildActivityItem('Price Updated', 'Changed to ${product.priceDisplay}', '1 week ago', Icons.edit, Colors.blue),
            _buildActivityItem('Sale Recorded', '-5 units sold', '3 days ago', Icons.shopping_cart, Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String subtitle, String time, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                    fontFamily: "Inter",
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontFamily: "Inter",
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[500],
              fontFamily: "Inter",
            ),
          ),
        ],
      ),
    );
  }
}
