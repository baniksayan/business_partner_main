// lib/providers/product_provider.dart
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_api_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  bool _isCreating = false;
  String? _errorMessage;
  Product? _selectedProduct;

  // Getters
  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  String? get errorMessage => _errorMessage;
  Product? get selectedProduct => _selectedProduct;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setCreating(bool creating) {
    _isCreating = creating;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Check authentication before API calls
  Future<void> _checkAuthentication() async {
    final isAuth = await ProductApiService.isAuthenticated();
    if (!isAuth) {
      throw Exception('Authentication required. Please login again.');
    }
  }

  // Get all products
  Future<void> getAllProducts(BuildContext context) async {
    _setLoading(true);
    _setError(null);

    try {
      await _checkAuthentication();
      final products = await ProductApiService.getAllProducts();
      _products = products;
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      
      // If authentication error, you might want to navigate to login
      if (e.toString().contains('Authentication')) {
        // Handle authentication error (e.g., navigate to login)
      }
    }
  }

  // Get product by ID
  Future<void> getProductById(BuildContext context, String productId) async {
    _setLoading(true);
    _setError(null);

    try {
      await _checkAuthentication();
      final product = await ProductApiService.getProduct(productId);
      _selectedProduct = product;
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  // Create product
  Future<bool> createProduct(BuildContext context, Map<String, dynamic> productData) async {
    _setCreating(true);
    _setError(null);

    try {
      await _checkAuthentication();
      final newProduct = await ProductApiService.createProduct(productData);
      _products.add(newProduct);
      _setCreating(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setCreating(false);
      return false;
    }
  }

  // Update product
  Future<bool> updateProduct(BuildContext context, String productId, Map<String, dynamic> productData) async {
    _setLoading(true);
    _setError(null);

    try {
      await _checkAuthentication();
      final updatedProduct = await ProductApiService.updateProduct(productId, productData);
      final index = _products.indexWhere((p) => p.id == productId);
      if (index != -1) {
        _products[index] = updatedProduct;
      }
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Partial update product
  Future<bool> partialUpdateProduct(BuildContext context, String productId, Map<String, dynamic> updateData) async {
    _setLoading(true);
    _setError(null);

    try {
      await _checkAuthentication();
      final updatedProduct = await ProductApiService.partialUpdateProduct(productId, updateData);
      final index = _products.indexWhere((p) => p.id == productId);
      if (index != -1) {
        _products[index] = updatedProduct;
      }
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Delete product
  Future<bool> deleteProduct(BuildContext context, String productId) async {
    _setLoading(true);
    _setError(null);

    try {
      await _checkAuthentication();
      final success = await ProductApiService.deleteProduct(productId);
      if (success) {
        _products.removeWhere((p) => p.id == productId);
      }
      _setLoading(false);
      return success;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Sort products
  void sortProducts(String sortBy) {
    switch (sortBy) {
      case 'Name (A-Z)':
        _products.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Price (Low to High)':
        _products.sort((a, b) => a.priceValue.compareTo(b.priceValue));
        break;
      case 'Price (High to Low)':
        _products.sort((a, b) => b.priceValue.compareTo(a.priceValue));
        break;
      case 'Recently Added':
        _products.sort((a, b) => (b.createdAt ?? DateTime.now())
            .compareTo(a.createdAt ?? DateTime.now()));
        break;
    }
    notifyListeners();
  }

  // Search products
  List<Product> searchProducts(String query) {
    if (query.isEmpty) return _products;
    
    return _products.where((product) =>
      product.name.toLowerCase().contains(query.toLowerCase()) ||
      product.description.toLowerCase().contains(query.toLowerCase()) ||
      product.category.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // Refresh products (pull to refresh)
  Future<void> refreshProducts(BuildContext context) async {
    await getAllProducts(context);
  }
}
