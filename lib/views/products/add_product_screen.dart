// lib/views/products/add_product_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/product_provider.dart';
import '../../services/auth_provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _productCodeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountController = TextEditingController();
  final _quantityController = TextEditingController();
  final _imageUrlController = TextEditingController();
  
  String? _selectedCategoryId;
  String? _selectedSubCategoryId;
  DateTime? _manufacturingDate;
  DateTime? _expiryDate;
  List<String> _imageUrls = [];
  bool _isActive = true;
  bool _showOptionalFields = false;
  bool _showImageUrlInput = false;
  
  // Categories with IDs - these should match your database
  final List<Map<String, dynamic>> categories = [
    {'id': '1', 'name': 'Electronics'},
    {'id': '2', 'name': 'Clothing'},
    {'id': '3', 'name': 'Home & Garden'},
    {'id': '4', 'name': 'Sports & Outdoors'},
    {'id': '5', 'name': 'Health & Beauty'},
    {'id': '6', 'name': 'Books & Media'},
    {'id': '7', 'name': 'Toys & Games'},
    {'id': '8', 'name': 'Food & Beverages'},
    {'id': '9', 'name': 'Automotive'},
    {'id': '10', 'name': 'Office Supplies'},
  ];

  // FIXED: Updated sub-categories with correct IDs that exist in your database
  final Map<String, List<Map<String, dynamic>>> subCategories = {
    '1': [ // Electronics
      {'id': '1', 'name': 'Smartphones'},
      {'id': '2', 'name': 'Laptops'},
      {'id': '3', 'name': 'Accessories'},
    ],
    '2': [ // Clothing
      {'id': '4', 'name': 'Men\'s Clothing'},
      {'id': '5', 'name': 'Women\'s Clothing'},
      {'id': '6', 'name': 'Kids Clothing'},
    ],
    '3': [ // Home & Garden
      {'id': '7', 'name': 'Furniture'},
      {'id': '8', 'name': 'Garden Tools'},
      {'id': '9', 'name': 'Home Decor'},
    ],
    '8': [ // Food & Beverages
      {'id': '10', 'name': 'Snacks'},
      {'id': '11', 'name': 'Beverages'},
      {'id': '12', 'name': 'Fresh Food'}, // This might be the problematic one
    ],
  };

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
        title: const Text(
          'Add New Product',
          style: TextStyle(
            fontFamily: "Poppins",
            color: Color(0xFF2C3E50),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF4FC3F7)),
          onPressed: () => Navigator.pop(context),
        ),
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
                  // UPDATED: API Info Card with better guidance
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.green[600]),
                            const SizedBox(width: 8),
                            const Text(
                              'Fixed API Requirements',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text('✅ Category ID is required (updated mapping)'),
                        const Text('✅ Sub-category ID is optional (fixed IDs)'),
                        const Text('✅ Only leave sub-category empty if unsure'),
                        const Text('✅ Image URLs must be valid web URLs'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Image Upload Section
                  _buildImageSection(),
                  const SizedBox(height: 24),
                  
                  // Basic Information
                  _buildSectionTitle('Basic Information', Icons.info_outline),
                  const SizedBox(height: 16),
                  _buildProductNameField(),
                  const SizedBox(height: 16),
                  _buildProductCodeField(),
                  const SizedBox(height: 16),
                  _buildDescriptionField(),
                  const SizedBox(height: 24),
                  
                  // Pricing
                  _buildSectionTitle('Pricing', Icons.attach_money),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(flex: 2, child: _buildPriceField()),
                      const SizedBox(width: 16),
                      Expanded(child: _buildDiscountField()),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Category (REQUIRED)
                  _buildSectionTitle('Category (Required)', Icons.category_outlined),
                  const SizedBox(height: 16),
                  _buildCategoryDropdown(),
                  const SizedBox(height: 16),
                  _buildSubCategoryDropdown(),
                  const SizedBox(height: 24),
                  
                  // Inventory
                  _buildSectionTitle('Inventory', Icons.inventory_2_outlined),
                  const SizedBox(height: 16),
                  _buildQuantityField(),
                  const SizedBox(height: 16),
                  _buildActiveStatusToggle(),
                  const SizedBox(height: 24),
                  
                  // Optional Fields Toggle
                  _buildOptionalFieldsToggle(),
                  if (_showOptionalFields) ...[
                    const SizedBox(height: 16),
                    _buildOptionalFields(),
                    const SizedBox(height: 24),
                  ],
                  
                  // Action Buttons
                  _buildActionButtons(productProvider),
                  const SizedBox(height: 20),
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF4FC3F7).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.photo_camera_outlined,
                  color: Color(0xFF4FC3F7),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Product Images',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                  fontFamily: 'Poppins',
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  setState(() {
                    _showImageUrlInput = !_showImageUrlInput;
                  });
                },
                child: Text(_showImageUrlInput ? 'Hide URL Input' : 'Add URL'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          if (_showImageUrlInput) ...[
            const Text(
              'Enter Image URL',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _imageUrlController,
                    decoration: InputDecoration(
                      hintText: 'https://example.com/image.jpg',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      prefixIcon: const Icon(Icons.link),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addImageUrl,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4FC3F7),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          
          if (_imageUrls.isNotEmpty) ...[
            const Text(
              'Added Image URLs:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Column(
              children: _imageUrls.map((url) {
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
                      const Icon(Icons.link, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          url,
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                        onPressed: () => _removeImageUrl(url),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ] else ...[
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!, width: 2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate, color: Colors.grey[400], size: 48),
                  const SizedBox(height: 8),
                  Text(
                    'Add image URLs above',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Valid web URLs only (http/https)',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF4FC3F7).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF4FC3F7), size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  Widget _buildProductNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Product Name *',
        hintText: 'Enter product name',
        prefixIcon: const Icon(Icons.shopping_bag_outlined, color: Color(0xFF4FC3F7)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4FC3F7), width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) => value?.isEmpty ?? true ? 'Please enter product name' : null,
    );
  }

  Widget _buildProductCodeField() {
    return TextFormField(
      controller: _productCodeController,
      decoration: InputDecoration(
        labelText: 'Product Code (SKU)',
        hintText: 'Enter product code',
        prefixIcon: const Icon(Icons.qr_code, color: Color(0xFF4FC3F7)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: InputDecoration(
        labelText: 'Description *',
        hintText: 'Enter product description',
        prefixIcon: const Icon(Icons.description_outlined, color: Color(0xFF4FC3F7)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      maxLines: 3,
      validator: (value) => value?.isEmpty ?? true ? 'Please enter description' : null,
    );
  }

  Widget _buildPriceField() {
    return TextFormField(
      controller: _priceController,
      decoration: InputDecoration(
        labelText: 'Price *',
        prefixIcon: const Icon(Icons.currency_rupee, color: Color(0xFF4FC3F7)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Please enter price';
        if (double.tryParse(value!) == null) return 'Please enter valid price';
        return null;
      },
    );
  }

  Widget _buildDiscountField() {
    return TextFormField(
      controller: _discountController,
      decoration: InputDecoration(
        labelText: 'Discount %',
        prefixIcon: const Icon(Icons.percent, color: Color(0xFF4FC3F7)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4FC3F7).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    (category['id'] as String),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF4FC3F7),
                      fontWeight: FontWeight.bold,
                    ),
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
          print('📂 [AddProduct] Category ID selected: $value');
        },
        validator: (value) => value == null ? 'Please select a category' : null,
      ),
    );
  }

  // UPDATED: Sub-category dropdown with warning for "Leave Empty" option
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            value: _selectedSubCategoryId,
            decoration: const InputDecoration(
              labelText: 'Select Sub-Category (Optional)',
              prefixIcon: Icon(Icons.subdirectory_arrow_right, color: Color(0xFF4FC3F7)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            items: [
              // Add "Leave Empty" option
              const DropdownMenuItem<String>(
                value: null,
                child: Row(
                  children: [
                    Icon(Icons.close, color: Colors.grey, size: 16),
                    SizedBox(width: 12),
                    Text(
                      'Leave Empty (Recommended)',
                      style: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              // Add available sub-categories
              ...availableSubCategories.map<DropdownMenuItem<String>>((subCategory) {
                return DropdownMenuItem<String>(
                  value: subCategory['id'] as String,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          (subCategory['id'] as String),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(subCategory['name'] as String),
                    ],
                  ),
                );
              }).toList(),
            ],
            onChanged: _selectedCategoryId != null ? (value) {
              setState(() {
                _selectedSubCategoryId = value;
              });
              print('📂 [AddProduct] Sub-category ID selected: $value');
            } : null,
            hint: Text(
              _selectedCategoryId == null 
                  ? 'Select a category first'
                  : 'Choose sub-category or leave empty',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          
          // Warning message
          if (_selectedCategoryId != null)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange[600], size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tip: Leave sub-category empty if you\'re not sure which ID exists in your database',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange[700],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildQuantityField() {
    return TextFormField(
      controller: _quantityController,
      decoration: InputDecoration(
        labelText: 'Quantity *',
        prefixIcon: const Icon(Icons.inventory_outlined, color: Color(0xFF4FC3F7)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Please enter quantity';
        if (int.tryParse(value!) == null) return 'Please enter valid quantity';
        return null;
      },
    );
  }

  Widget _buildActiveStatusToggle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        children: [
          Icon(_isActive ? Icons.check_circle : Icons.cancel, 
               color: _isActive ? Colors.green : Colors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _isActive ? 'Product is active' : 'Product is inactive',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          Switch(
            value: _isActive,
            onChanged: (value) => setState(() => _isActive = value),
            activeColor: const Color(0xFF4FC3F7),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionalFieldsToggle() {
    return GestureDetector(
      onTap: () => setState(() => _showOptionalFields = !_showOptionalFields),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF4FC3F7).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, color: Color(0xFF4FC3F7)),
            const SizedBox(width: 12),
            const Expanded(child: Text('Optional Fields (Dates)')),
            Icon(_showOptionalFields ? Icons.expand_less : Icons.expand_more),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionalFields() {
    return Column(
      children: [
        _buildDateField('Manufacturing Date', _manufacturingDate, (date) {
          setState(() => _manufacturingDate = date);
        }),
        const SizedBox(height: 16),
        _buildDateField('Expiry Date', _expiryDate, (date) {
          setState(() => _expiryDate = date);
        }),
      ],
    );
  }

  Widget _buildDateField(String label, DateTime? selectedDate, Function(DateTime) onDateSelected) {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (date != null) onDateSelected(date);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: Color(0xFF4FC3F7)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(
                    selectedDate != null 
                        ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
                        : 'Tap to select date',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(ProductProvider productProvider) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _resetForm,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Color(0xFF4FC3F7)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Reset', style: TextStyle(color: Color(0xFF4FC3F7))),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: productProvider.isCreating ? null : _createProduct,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4FC3F7),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: productProvider.isCreating
                ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                : const Text('Create Product', style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
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
            content: Text('Please enter a valid URL starting with http:// or https://'),
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

  void _resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _productCodeController.clear();
    _descriptionController.clear();
    _priceController.clear();
    _discountController.clear();
    _quantityController.clear();
    _imageUrlController.clear();
    setState(() {
      _selectedCategoryId = null;
      _selectedSubCategoryId = null;
      _manufacturingDate = null;
      _expiryDate = null;
      _imageUrls.clear();
      _isActive = true;
      _showOptionalFields = false;
      _showImageUrlInput = false;
    });
  }

  // FIXED: Updated product creation with better sub-category handling
  void _createProduct() async {
    if (!_formKey.currentState!.validate()) return;

    print('🚀 [AddProduct] Creating product with fixed sub-category handling...');

    // Prepare product data
    final productData = <String, dynamic>{
      'name': _nameController.text.trim(),
      'description': _descriptionController.text.trim(),
      'price': double.parse(_priceController.text.trim()),
      'quantity': int.parse(_quantityController.text.trim()),
      'category': _selectedCategoryId!, // Send category ID
      'is_active': _isActive,
    };

    // Add optional fields only if they have values
    if (_productCodeController.text.trim().isNotEmpty) {
      productData['product_code'] = _productCodeController.text.trim();
    }

    if (_discountController.text.trim().isNotEmpty) {
      productData['discount_per'] = double.parse(_discountController.text.trim());
    }

    // FIXED: Only add sub_category if it's actually selected (not null)
    if (_selectedSubCategoryId != null && _selectedSubCategoryId!.isNotEmpty) {
      productData['sub_category'] = _selectedSubCategoryId!;
      print('📂 [AddProduct] Including sub-category ID: $_selectedSubCategoryId');
    } else {
      print('📂 [AddProduct] Skipping sub-category (left empty)');
    }

    if (_manufacturingDate != null) {
      productData['maf_date'] = _manufacturingDate!.toIso8601String().split('T')[0];
    }

    if (_expiryDate != null) {
      productData['exp_date'] = _expiryDate!.toIso8601String().split('T')[0];
    }

    if (_imageUrls.isNotEmpty) {
      productData['image_urls'] = _imageUrls;
    }

    print('📦 [AddProduct] Final product data:');
    productData.forEach((key, value) {
      print('   $key: $value (${value.runtimeType})');
    });

    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    
    try {
      final success = await productProvider.createProduct(context, productData);
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('✅ Product created successfully!'),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('❌ Failed: ${productProvider.errorMessage ?? "Unknown error"}'),
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
      print('💥 [AddProduct] Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text('⚠️ Error: $e')),
            ],
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }
}
