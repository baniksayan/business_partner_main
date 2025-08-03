class Product {
  final String id;
  final String image;
  final String name;
  final String price;
  final String description;
  final String category;
  final int stock;
  final bool inStock;
  final double rating;
  final int reviewCount;
  final List<String> features;
  final List<String> gallery;

  const Product({
    required this.id,
    required this.image,
    required this.name,
    required this.price,
    this.description = '',
    this.category = '',
    this.stock = 0,
    this.inStock = true,
    this.rating = 4.5,
    this.reviewCount = 0,
    this.features = const [],
    this.gallery = const [],
  });

  // Convert price string to double for calculations
  double get priceValue {
    return double.tryParse(price.replaceAll('₹', '').replaceAll(',', '')) ?? 0.0;
  }
}
