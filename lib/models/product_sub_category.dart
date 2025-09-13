
// lib/models/product_sub_category.dart
class ProductSubCategory {
  final String id;
  final String name;
  final String description;
  final bool isActive;
  final String categoryId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductSubCategory({
    required this.id,
    required this.name,
    required this.description,
    this.isActive = true,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductSubCategory.fromJson(Map<String, dynamic> json) {
    return ProductSubCategory(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      isActive: json['is_active'] ?? true,
      categoryId: json['category_id']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at']) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at']) ?? DateTime.now(),
    );
  }
}
