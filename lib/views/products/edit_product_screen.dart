// lib/views/products/edit_product_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/product_provider.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _productCodeController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _discountController;
  late TextEditingController _quantityController;
  late TextEditingController _imageUrlController;
  
  String? _selectedCategoryId;
  String? _selectedSubCategoryId;
  List<String> _imageUrls = [];
  bool _isActive = true;
  bool _showImageUrlInput = false;

  // Categories with IDs that match your database
  final List<Map<String, dynamic>> categories = [
    {'id': '1', 'name': 'Electronics', 'icon': Icons.devices, 'color': Colors.blue},
    {'id': '2', 'name': 'Clothing', 'icon': Icons.checkroom, 'color': Colors.purple},
    {'id': '3', 'name': 'Home & Garden', 'icon': Icons.home, 'color': Colors.green},
    {'id': '4', 'name': 'Sports & Outdoors', 'icon': Icons.sports_soccer, 'color': Colors.orange},
    {'id': '5', 'name': 'Health & Beauty', 'icon': Icons.favorite, 'color': Colors.pink},
    {'id': '6', 'name': 'Books & Media', 'icon': Icons.book, 'color': Colors.brown},
    {'id': '7', 'name': 'Toys & Games', 'icon': Icons.toys, 'color': Colors.red},
    {'id': '8', 'name': 'Food & Beverages', 'icon': Icons.restaurant, 'color': Colors.amber},
    {'id': '9', 'name': 'Automotive', 'icon': Icons.directions_car, 'color': Colors.grey},
    {'id': '10', 'name': 'Office Supplies', 'icon': Icons.business, 'color': Colors.indigo},
  ];

  final Map<String, List<Map<String, dynamic>>> subCategories = {
    '1': [
      {'id': '11', 'name': 'Smartphones'},
      {'id': '12', 'name': 'Laptops'},
      {'id': '13', 'name': 'Accessories'},
    ],
    '2': [
      {'id': '21', 'name': 'Men\'s Clothing'},
      {'id': '22', 'name': 'Women\'s Clothing'},
      {'id': '23', 'name': 'Kids Clothing'},
    ],
    '8': [
      {'id': '81', 'name': 'Snacks'},
      {'id': '82', 'name': 'Beverages'},
      {'id': '83', 'name': 'Fresh Food'},
    ],
  };

  @override
  void initState() {
    super.initState();
    print('✏️ [EditProduct] Initializing edit screen for: ${widget.product.name}');
    
    _nameController = TextEditingController(text: widget.product.name);
    _productCodeController = TextEditingController(text: widget.product.productCode ?? '');
    _descriptionController = TextEditingController(text: widget.product.description);
    _priceController = TextEditingController(text: widget.product.price.toString());
    _discountController = TextEditingController(text: widget.product.discountPercentage?.toString() ?? '');
    _quantityController = TextEditingController(text: widget.product.quantity.toString());
    _imageUrlController = TextEditingController();
    
    // Initialize existing data
    _isActive = widget.product.isActive;
    _imageUrls = List.from(widget.product.imageUrls);
    
    // Set category - try to find matching category ID
    _initializeCategory();
    
    print('📦 [EditProduct] Initialized with:');
    print('   - Name: ${widget.product.name}');
    print('   - Category: ${widget.product.category}');
    print('   - Category ID: ${widget.product.categoryId}');
    print('   - Sub-category ID: ${widget.product.subCategoryId}');
  }

  void _initializeCategory() {
    // Try to match existing category
    if (widget.product.categoryId != null) {
      _selectedCategoryId = widget.product.categoryId;
    } else {
      // Try to find category by name
      final matchingCategory = categories.firstWhere(
        (cat) => cat['name'].toString().toLowerCase() == widget.product.category.toLowerCase(),
        orElse: () => categories.first, // Default to first category
      );
      _selectedCategoryId = matchingCategory['id'];
    }
    
    // Set sub-category if available
    if (widget.product.subCategoryId != null) {
      _selectedSubCategoryId = widget.product.subCategoryId;
    }
    
    print('🏷️ [EditProduct] Category initialized: $_selectedCategoryId');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _productCodeController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    _quantityController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Edit ${widget.product.name}',
          style: const TextStyle(
            fontFamily: "Poppins",
            color: Color(0xFF2C3E50),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF4FC3F7)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: _deleteProduct,
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Info Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.edit, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Edit Product',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Product ID: ${widget.product.id}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Image Section
                  _buildImageSection(),
                  const SizedBox(height: 24),

                  // Basic Information
                  _buildTextField(
                    controller: _nameController,
                    label: 'Product Name *',
                    icon: Icons.shopping_bag,
                    validator: (value) => value?.isEmpty ?? true ? 'Please enter product name' : null,
                  ),
                  const SizedBox(height: 16),
                  
                  _buildTextField(
                    controller: _productCodeController,
                    label: 'Product Code (SKU)',
                    icon: Icons.qr_code,
                  ),
                  const SizedBox(height: 16),
                  
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'Description *',
                    icon: Icons.description,
                    maxLines: 3,
                    validator: (value) => value?.isEmpty ?? true ? 'Please enter description' : null,
                  ),
                  const SizedBox(height: 24),
                  
                  // Pricing Section
                  const Text(
                    'Pricing',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildTextField(
                          controller: _priceController,
                          label: 'Price *',
                          icon: Icons.currency_rupee,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value?.isEmpty ?? true) return 'Please enter price';
                            if (double.tryParse(value!) == null) return 'Invalid price';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          controller: _discountController,
                          label: 'Discount %',
                          icon: Icons.percent,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Category Section (REQUIRED)
                  const Text(
                    'Category (Required)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildCategoryDropdown(),
                  const SizedBox(height: 16),
                  _buildSubCategoryDropdown(),
                  const SizedBox(height: 24),
                  
                  // Inventory Section
                  const Text(
                    'Inventory',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _quantityController,
                    label: 'Quantity *',
                    icon: Icons.inventory,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Please enter quantity';
                      if (int.tryParse(value!) == null) return 'Invalid quantity';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Status Toggle
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _isActive ? Icons.check_circle : Icons.cancel,
                          color: _isActive ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _isActive ? 'Product is active' : 'Product is inactive',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Switch(
                          value: _isActive,
                          onChanged: (value) => setState(() => _isActive = value),
                          activeColor: const Color(0xFF4FC3F7),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: Colors.grey),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: productProvider.isLoading ? null : _updateProduct,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4FC3F7),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: productProvider.isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text('Update Product', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.photo_camera_outlined, color: Color(0xFF4FC3F7)),
              const SizedBox(width: 12),
              const Text(
                'Product Images',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  setState(() {
                    _showImageUrlInput = !_showImageUrlInput;
                  });
                },
                child: Text(_showImageUrlInput ? 'Hide' : 'Add URL'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          if (_showImageUrlInput) ...[
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _imageUrlController,
                    decoration: const InputDecoration(
                      hintText: 'https://example.com/image.jpg',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.link),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addImageUrl,
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          
          if (_imageUrls.isNotEmpty) ...[
            const Text('Current Images:', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ...(_imageUrls.map((url) => _buildImageUrlItem(url)).toList()),
          ] else ...[
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate, color: Colors.grey[400]),
                  const Text('No images added', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImageUrlItem(String url) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Row(
        children: [
          const Icon(Icons.image, color: Colors.green),
          const SizedBox(width: 8),
          Expanded(
            child: Text(url, style: const TextStyle(fontSize: 12)),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
            onPressed: () => _removeImageUrl(url),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedCategoryId,
        decoration: const InputDecoration(
          labelText: 'Select Category *',
          prefixIcon: Icon(Icons.category_outlined, color: Color(0xFF4FC3F7)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        items: categories.map<DropdownMenuItem<String>>((category) {
          return DropdownMenuItem<String>(
            value: category['id'] as String,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: (category['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(
                    category['icon'] as IconData,
                    color: category['color'] as Color,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Text(category['name'] as String),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedCategoryId = value;
            _selectedSubCategoryId = null; // Reset subcategory
          });
          print('📂 [EditProduct] Category ID selected: $value');
        },
        validator: (value) => value == null ? 'Please select a category' : null,
      ),
    );
  }

  Widget _buildSubCategoryDropdown() {
    final availableSubCategories = _selectedCategoryId != null 
        ? subCategories[_selectedCategoryId] ?? []
        : <Map<String, dynamic>>[];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedSubCategoryId,
        decoration: const InputDecoration(
          labelText: 'Sub-Category (Optional)',
          prefixIcon: Icon(Icons.subdirectory_arrow_right, color: Color(0xFF4FC3F7)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        items: availableSubCategories.map<DropdownMenuItem<String>>((subCategory) {
          return DropdownMenuItem<String>(
            value: subCategory['id'] as String,
            child: Text(subCategory['name'] as String),
          );
        }).toList(),
        onChanged: _selectedCategoryId != null ? (value) {
          setState(() {
            _selectedSubCategoryId = value;
          });
          print('📂 [EditProduct] Sub-category ID selected: $value');
        } : null,
        hint: Text(
          _selectedCategoryId == null 
              ? 'Select a category first'
              : 'Choose sub-category (optional)',
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF4FC3F7)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4FC3F7), width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
    );
  }

  void _addImageUrl() {
    if (_imageUrlController.text.isNotEmpty) {
      final url = _imageUrlController.text.trim();
      final uri = Uri.tryParse(url);
      
      if (uri != null && 
          uri.hasAbsolutePath && 
          (url.startsWith('http://') || url.startsWith('https://'))) {
        setState(() {
          _imageUrls.add(url);
          _imageUrlController.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid URL'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _removeImageUrl(String url) {
    setState(() {
      _imageUrls.remove(url);
    });
  }

  void _updateProduct() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    print('🔄 [EditProduct] Updating product with all required fields...');

    // Prepare complete update data including CATEGORY
    final updateData = <String, dynamic>{
      'name': _nameController.text.trim(),
      'description': _descriptionController.text.trim(),
      'price': double.parse(_priceController.text.trim()),
      'quantity': int.parse(_quantityController.text.trim()),
      'category': int.parse(_selectedCategoryId!), // REQUIRED FIELD
      'is_active': _isActive,
    };

    // Add optional fields only if they have values
    if (_productCodeController.text.trim().isNotEmpty) {
      updateData['product_code'] = _productCodeController.text.trim();
    }

    if (_discountController.text.trim().isNotEmpty) {
      updateData['discount_per'] = double.parse(_discountController.text.trim());
    }

    if (_selectedSubCategoryId != null) {
      updateData['sub_category'] = int.parse(_selectedSubCategoryId!);
    }

    if (_imageUrls.isNotEmpty) {
      updateData['image_urls'] = _imageUrls;
    }

    print('📦 [EditProduct] Final update data with category:');
    updateData.forEach((key, value) {
      print('   $key: $value (${value.runtimeType})');
    });

    final productProvider = Provider.of<ProductProvider>(context, listen: false);

    try {
      final success = await productProvider.updateProduct(context, widget.product.id, updateData);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text('${updateData['name']} updated successfully!'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        Navigator.pop(context, true); // Return true to indicate success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Failed to update product: ${productProvider.errorMessage ?? "Unknown error"}'),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      print('💥 [EditProduct] Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text('Error: $e')),
            ],
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _deleteProduct() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete "${widget.product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _confirmDelete,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete() async {
    Navigator.pop(context); // Close dialog
    Navigator.pop(context, true); // Go back to products list with success flag
    
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    
    try {
      final success = await productProvider.deleteProduct(context, widget.product.id);
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete product: ${productProvider.errorMessage}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting product: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
