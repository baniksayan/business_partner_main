// lib/models/product.dart
import 'dart:convert'; 

class Product {
  final String id;
  final String name;
  final String? productCode;
  final String description;
  final double price;
  final double? discountPercentage;
  final int quantity;
  final DateTime? manufacturingDate;
  final DateTime? expiryDate;
  final List<String> imageUrls;
  final String? othersCategory;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? categoryId;
  final String? subCategoryId;
  final String? createdById;
  final String? updatedById;

  // Compatibility getters for old code
  String get image => imageUrls.isNotEmpty ? imageUrls.first : '';
  String get priceDisplay => '₹${price.toStringAsFixed(2)}';
  double get priceValue => price;
  String get stock => quantity.toString();
  bool get inStock => quantity > 0;
  String get category => othersCategory ?? categoryId ?? '';
  double get rating => 4.5;
  int get reviewCount => 0;
  List<String> get features => [];
  List<String> get gallery => imageUrls;

  const Product({
    required this.id,
    required this.name,
    this.productCode,
    required this.description,
    required this.price,
    this.discountPercentage,
    required this.quantity,
    this.manufacturingDate,
    this.expiryDate,
    this.imageUrls = const [],
    this.othersCategory,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.categoryId,
    this.subCategoryId,
    this.createdById,
    this.updatedById,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    print('🔍 [Product] Parsing JSON: ${json.keys.toList()}');
    
    return Product(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      productCode: json['product_code']?.toString(),
      description: json['description']?.toString() ?? '',
      price: _parsePrice(json['price']),
      discountPercentage: _parseDouble(json['discount_per']),
      quantity: _parseInt(json['quantity']),
      manufacturingDate: json['maf_date'] != null 
          ? DateTime.tryParse(json['maf_date'].toString()) 
          : null,
      expiryDate: json['exp_date'] != null 
          ? DateTime.tryParse(json['exp_date'].toString()) 
          : null,
      imageUrls: _parseImageUrls(json['image_urls']),
      othersCategory: json['others_category']?.toString(),
      isActive: _parseBool(json['is_active']),
      createdAt: _parseDateTime(json['created_at']) ?? DateTime.now(),
      updatedAt: _parseDateTime(json['updated_at']) ?? DateTime.now(),
      categoryId: json['category_id']?.toString(),
      subCategoryId: json['sub_category_id']?.toString(),
      createdById: json['created_by_id']?.toString(),
      updatedById: json['updated_by_id']?.toString(),
    );
  }

  // Safe parsing methods
  static double _parsePrice(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      final cleanValue = value.replaceAll(RegExp(r'[₹$,\s]'), '');
      return double.tryParse(cleanValue) ?? 0.0;
    }
    return 0.0;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      final cleanValue = value.replaceAll(RegExp(r'[₹$,\s%]'), '');
      return double.tryParse(cleanValue);
    }
    return null;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static bool _parseBool(dynamic value) {
    if (value == null) return true;
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true' || value == '1';
    if (value is int) return value == 1;
    return true;
  }

  static List<String> _parseImageUrls(dynamic value) {
    if (value == null) return [];
    if (value is List) return value.map((e) => e.toString()).toList();
    if (value is String) {
      if (value.isEmpty) return [];
      try {
        final List<dynamic> parsed = json.decode(value);
        return parsed.map((e) => e.toString()).toList();
      } catch (e) {
        return [value];
      }
    }
    return [];
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'product_code': productCode,
      'description': description,
      'price': price,
      'discount_per': discountPercentage,
      'quantity': quantity,
      'maf_date': manufacturingDate?.toIso8601String(),
      'exp_date': expiryDate?.toIso8601String(),
      'image_urls': imageUrls,
      'others_category': othersCategory,
      'is_active': isActive,
      'category_id': categoryId,
      'sub_category_id': subCategoryId,
    };
  }
} 
