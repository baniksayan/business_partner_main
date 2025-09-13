// lib/widgets/products/product_options_bottom_sheet.dart
import 'package:flutter/material.dart';

class ProductOptionsBottomSheet extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDuplicate;
  final VoidCallback onArchive;
  final VoidCallback onDelete;

  const ProductOptionsBottomSheet({
    Key? key,
    required this.onEdit,
    required this.onDuplicate,
    required this.onArchive,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          const SizedBox(height: 20),
          
          const Text(
            'Product Options',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
              fontFamily: "Poppins",
            ),
          ),
          
          const SizedBox(height: 20),
          
          _buildOptionItem(
            icon: Icons.edit,
            title: 'Edit Product',
            subtitle: 'Modify product details',
            color: const Color(0xFF4FC3F7),
            onTap: () {
              Navigator.pop(context);
              onEdit();
            },
          ),
          
          _buildOptionItem(
            icon: Icons.content_copy,
            title: 'Duplicate Product',
            subtitle: 'Create a copy of this product',
            color: Colors.orange,
            onTap: () {
              Navigator.pop(context);
              onDuplicate();
            },
          ),
          
          _buildOptionItem(
            icon: Icons.archive,
            title: 'Archive Product',
            subtitle: 'Hide from active listings',
            color: Colors.grey,
            onTap: () {
              Navigator.pop(context);
              onArchive();
            },
          ),
          
          _buildOptionItem(
            icon: Icons.delete,
            title: 'Delete Product',
            subtitle: 'Permanently remove this product',
            color: Colors.red,
            onTap: () {
              Navigator.pop(context);
              onDelete();
            },
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF2C3E50),
          fontFamily: "Inter",
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
          fontFamily: "Inter",
        ),
      ),
      onTap: onTap,
    );
  }
}
