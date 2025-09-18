// lib/views/products/edit_product_screen.dart - FIXED IMAGE PICKER METHODS
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart'; // ✅ ADD THIS for kIsWeb
import 'dart:io';
import 'dart:typed_data';
import '../../models/product.dart';
import '../../providers/product_provider.dart';
import '../../services/file_upload_service.dart';
import '../../services/product_api_service.dart';

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
  List<File> _selectedFiles = [];
  List<Uint8List> _webImages = [];
  List<String> _webImageNames = [];
  bool _isActive = true;
  bool _showImageUrlInput = false;
  bool _isUploading = false;
  bool _isSaving = false;
  final ImagePicker _imagePicker = ImagePicker();

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
    
    print('📦 [EditProduct] Initialized with existing images: ${_imageUrls.length}');
  }

  void _initializeCategory() {
    if (widget.product.categoryId != null) {
      _selectedCategoryId = widget.product.categoryId;
    } else {
      final matchingCategory = categories.firstWhere(
        (cat) => cat['name'].toString().toLowerCase() == widget.product.category.toLowerCase(),
        orElse: () => categories.first,
      );
      _selectedCategoryId = matchingCategory['id'];
    }
    
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Info Card (unchanged)
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
              
              // Enhanced Image Section with File Upload
              _buildEnhancedImageSection(),
              const SizedBox(height: 24),
              
              // Basic Information (unchanged)
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
              
              // Pricing Section (unchanged)
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
              
              // Category Section (unchanged)
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
              
              // Inventory Section (unchanged)
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
              
              // Status Toggle (unchanged)
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
                      onPressed: (_isSaving || _isUploading) ? null : _updateProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4FC3F7),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: (_isSaving || _isUploading)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                ),
                                const SizedBox(width: 8),
                                Text(_isUploading ? 'Uploading...' : 'Updating...'),
                              ],
                            )
                          : const Text('Update Product', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Enhanced Image Section with File Upload
  Widget _buildEnhancedImageSection() {
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
              ElevatedButton.icon(
                onPressed: _isUploading ? null : _showImagePickerOptions,
                icon: _isUploading 
                    ? SizedBox(
                        width: 16, 
                        height: 16, 
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Icon(Icons.add_photo_alternate),
                label: Text(_isUploading ? 'Uploading...' : 'Add Images'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4FC3F7),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Show selected files preview
          if (_selectedFiles.isNotEmpty || _webImages.isNotEmpty) ...[
            const Text('New Images to Upload:', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.orange)),
            const SizedBox(height: 8),
            _buildNewImagesGrid(),
            const SizedBox(height: 16),
          ],
          
          // URL Input Section
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _showImageUrlInput = !_showImageUrlInput;
                    });
                  },
                  icon: Icon(_showImageUrlInput ? Icons.keyboard_arrow_up : Icons.link),
                  label: Text(_showImageUrlInput ? 'Hide URL Input' : 'Or Add by URL'),
                ),
              ),
            ],
          ),
          
          if (_showImageUrlInput) ...[
            const SizedBox(height: 8),
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
          
          // Existing Images
          if (_imageUrls.isNotEmpty) ...[
            const Text('Current Images:', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.green)),
            const SizedBox(height: 8),
            _buildExistingImagesGrid(),
          ] else if (_selectedFiles.isEmpty && _webImages.isEmpty) ...[
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate, color: Colors.grey[400], size: 40),
                  const SizedBox(height: 8),
                  Text('No images added', style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 4),
                  Text('Tap "Add Images" to upload files', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Show Image Picker Options
  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Product Images',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildPickerOption(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    onTap: () => _pickImagesFromCamera(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildPickerOption(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onTap: () => _pickImagesFromGallery(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildPickerOption(
              icon: Icons.file_upload,
              label: 'Browse Files (Multiple)',
              onTap: () => _pickMultipleImages(),
              fullWidth: true,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildPickerOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool fullWidth = false,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(fullWidth ? 16 : 20),
        decoration: BoxDecoration(
          color: Color(0xFF4FC3F7).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFF4FC3F7).withOpacity(0.3)),
        ),
        child: fullWidth
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Color(0xFF4FC3F7)),
                  const SizedBox(width: 8),
                  Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
                ],
              )
            : Column(
                children: [
                  Icon(icon, color: Color(0xFF4FC3F7), size: 30),
                  const SizedBox(height: 8),
                  Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
      ),
    );
  }

// ✅ QUICK FIX: Pick Images from Gallery (Web & Mobile Compatible)
Future<void> _pickImagesFromGallery() async {
  try {
    print('🖼️ [EditProduct] Opening gallery for multiple images...');
    
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: true, // ✅ CRITICAL: Always loads bytes for web
    );

    if (result != null && result.files.isNotEmpty) {
      print('🖼️ [EditProduct] Selected ${result.files.length} images from gallery');
      
      int addedCount = 0;
      
      setState(() {
        for (var file in result.files) {
          if (!_isValidImageFile(file.name)) {
            print('⚠️ [EditProduct] Skipping non-image file: ${file.name}');
            continue;
          }
          
          // ✅ FIXED: Always use bytes, never check path on web
          if (file.bytes != null && file.bytes!.isNotEmpty) {
            _webImages.add(file.bytes!);
            _webImageNames.add(file.name);
            addedCount++;
            print('✅ [EditProduct] Added file: ${file.name} (${file.bytes!.length} bytes)');
          } else {
            print('⚠️ [EditProduct] File has no bytes data: ${file.name}');
          }
        }
      });
      
      if (addedCount > 0) {
        _showSuccess('Selected $addedCount images successfully!');
      } else {
        _showError('No valid images were selected. Please try again.');
      }
    } else {
      print('📱 [EditProduct] No images selected from gallery');
    }
  } catch (e) {
    print('❌ [EditProduct] Error picking from gallery: $e');
    _showError('Error accessing gallery. Please try again.');
  }
}

// ✅ QUICK FIX: Pick Multiple Images (Web & Mobile Compatible)
Future<void> _pickMultipleImages() async {
  try {
    print('📁 [EditProduct] Opening file picker for multiple images...');
    
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
      withData: true, // ✅ CRITICAL: Always loads bytes
    );

    if (result != null && result.files.isNotEmpty) {
      print('📁 [EditProduct] Selected ${result.files.length} images via file picker');
      
      int addedCount = 0;
      
      setState(() {
        for (var file in result.files) {
          if (!_isValidImageFile(file.name)) {
            print('⚠️ [EditProduct] Skipping non-image file: ${file.name}');
            continue;
          }
          
          // ✅ FIXED: Only use bytes (works on both web and mobile)
          if (file.bytes != null && file.bytes!.isNotEmpty) {
            _webImages.add(file.bytes!);
            _webImageNames.add(file.name);
            addedCount++;
            print('✅ [EditProduct] Added file: ${file.name} (${file.bytes!.length} bytes)');
          } else {
            print('⚠️ [EditProduct] File has no bytes data: ${file.name}');
          }
        }
      });
      
      if (addedCount > 0) {
        _showSuccess('Selected $addedCount images successfully!');
      } else {
        _showError('No valid image files were selected.');
      }
    } else {
      print('📁 [EditProduct] No files selected via file picker');
    }
  } catch (e) {
    print('❌ [EditProduct] Error picking files: $e');
    _showError('Error selecting files. Please try again.');
  }
}

// ✅ UPDATED: Camera picker (mobile only)
Future<void> _pickImagesFromCamera() async {
  try {
    print('📷 [EditProduct] Opening camera...');
    
    if (kIsWeb) {
      _showError('Camera not available on web. Please use file upload instead.');
      return;
    }
    
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );
    
    if (image != null) {
      // ✅ For camera, we convert to bytes for consistency
      final bytes = await image.readAsBytes();
      setState(() {
        _webImages.add(bytes);
        _webImageNames.add('camera_${DateTime.now().millisecondsSinceEpoch}.jpg');
      });
      print('📷 [EditProduct] Image captured from camera');
      _showSuccess('Image captured successfully!');
    } else {
      print('📷 [EditProduct] Camera capture cancelled');
    }
  } catch (e) {
    print('❌ [EditProduct] Error picking from camera: $e');
    _showError('Error accessing camera. Please check permissions.');
  }
}

// ✅ UPDATED: Build Grid for New Images (Only bytes now)
Widget _buildNewImagesGrid() {
  return Container(
    height: 100,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _webImages.length, // ✅ Only web images now
      itemBuilder: (context, index) {
        return _buildNewImageItem(
          webImageData: _webImages[index],
          webImageName: _webImageNames[index],
          index: index,
        );
      },
    ),
  );
}

Widget _buildNewImageItem({
  required Uint8List webImageData,
  required String webImageName,
  required int index,
}) {
  return Container(
    width: 90,
    margin: const EdgeInsets.only(right: 8),
    decoration: BoxDecoration(
      color: Colors.orange[50],
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.orange[300]!),
    ),
    child: Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.memory(
            webImageData,
            width: 90,
            height: 90,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 90,
              height: 90,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image, color: Colors.orange),
                  Text(
                    webImageName,
                    style: TextStyle(fontSize: 10),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => _removeNewImage(index),
            child: Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, color: Colors.white, size: 16),
            ),
          ),
        ),
        Positioned(
          bottom: 4,
          left: 4,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'NEW',
              style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    ),
  );
}

// ✅ SIMPLIFIED: Remove New Image
void _removeNewImage(int index) {
  setState(() {
    if (index < _webImages.length) {
      _webImages.removeAt(index);
      _webImageNames.removeAt(index);
    }
  });
  _showSuccess('Image removed');
}

  // Build Grid for Existing Images
  Widget _buildExistingImagesGrid() {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _imageUrls.length,
        itemBuilder: (context, index) {
          final url = _imageUrls[index];
          return Container(
            width: 90,
            margin: const EdgeInsets.only(right: 8),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    url,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => _removeImageUrl(url),
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close, color: Colors.white, size: 16),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }


  // All your existing methods remain unchanged...
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
            _selectedSubCategoryId = null;
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
        _showError('Please enter a valid URL');
      }
    }
  }

  void _removeImageUrl(String url) {
    setState(() {
      _imageUrls.remove(url);
    });
  }

  // Update Product using ProductApiService
  void _updateProduct() async {
    if (!_formKey.currentState!.validate()) {
      _showError('Please fill in all required fields');
      return;
    }
    
    if (_selectedCategoryId == null) {
      _showError('Please select a category');
      return;
    }

    print('🔄 [EditProduct] Starting product update with ProductApiService...');
    
    setState(() {
      _isUploading = true;
    });

    try {
      // Upload new images first if any
      List<String> newImageUrls = [];
      
      if (_selectedFiles.isNotEmpty || _webImages.isNotEmpty) {
        print('📤 [EditProduct] Uploading ${_selectedFiles.length + _webImages.length} new images...');
        
        // Upload mobile files
        for (File file in _selectedFiles) {
          final uploadResult = await FileUploadService.uploadImage(file);
          if (uploadResult.success && uploadResult.imageUrl != null) {
            newImageUrls.add(uploadResult.imageUrl!);
          } else {
            print('⚠️ [EditProduct] Failed to upload image: ${uploadResult.error}');
          }
        }
        
        // Upload web files
        for (int i = 0; i < _webImages.length; i++) {
          final uploadResult = await FileUploadService.uploadWebImage(
            _webImages[i], 
            _webImageNames[i]
          );
          if (uploadResult.success && uploadResult.imageUrl != null) {
            newImageUrls.add(uploadResult.imageUrl!);
          } else {
            print('⚠️ [EditProduct] Failed to upload web image: ${uploadResult.error}');
          }
        }
        
        print('✅ [EditProduct] Successfully uploaded ${newImageUrls.length} images');
      }

      setState(() {
        _isUploading = false;
        _isSaving = true;
      });

      // Combine existing URLs with new uploaded URLs
      final allImageUrls = [..._imageUrls, ...newImageUrls];

      // Prepare update data in format expected by your API
      final updateData = <String, dynamic>{
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'price': double.parse(_priceController.text.trim()),
        'quantity': int.parse(_quantityController.text.trim()),
        'category': int.parse(_selectedCategoryId!), // Your API expects integer
        'is_active': _isActive,
        'image_urls': allImageUrls, // Include all image URLs
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

      print('📦 [EditProduct] Final update data for ProductApiService:');
      updateData.forEach((key, value) {
        print('   $key: $value (${value.runtimeType})');
      });

      // Use your ProductApiService for update
      try {
        final updatedProduct = await ProductApiService.updateProduct(
          widget.product.id, 
          updateData
        );
        
        print('✅ [EditProduct] Product updated successfully via ProductApiService');
        
        // Update the provider's cache with the updated product
        final productProvider = Provider.of<ProductProvider>(context, listen: false);
        productProvider.updateLocalProduct(updatedProduct);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text('${updatedProduct.name} updated successfully!')),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        Navigator.pop(context, true);
        
      } catch (apiError) {
        print('❌ [EditProduct] ProductApiService error: $apiError');
        
        // Handle specific API errors from your service
        String errorMessage = 'Failed to update product';
        
        if (apiError.toString().contains('AUTHENTICATION')) {
          errorMessage = 'Please login again to continue';
        } else if (apiError.toString().contains('VALIDATION')) {
          errorMessage = 'Please check your product data';
        } else if (apiError.toString().contains('NETWORK')) {
          errorMessage = 'Network error. Please check your connection';
        } else if (apiError.toString().contains('TIMEOUT')) {
          errorMessage = 'Request timed out. Please try again';
        } else if (apiError.toString().contains('PRODUCT_NOT_FOUND')) {
          errorMessage = 'Product not found. It may have been deleted';
        } else {
          // Extract specific error message from your API service
          final errorString = apiError.toString();
          if (errorString.contains(': ')) {
            errorMessage = errorString.split(': ').last;
          }
        }
        
        _showError(errorMessage);
      }
      
    } catch (e) {
      print('💥 [EditProduct] Unexpected exception: $e');
      _showError('Unexpected error: $e');
    } finally {
      setState(() {
        _isUploading = false;
        _isSaving = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
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
    
    try {
      print('🗑️ [EditProduct] Deleting product via ProductApiService...');
      
      // Use your ProductApiService for deletion
      final success = await ProductApiService.deleteProduct(widget.product.id);
      
      if (success) {
        print('✅ [EditProduct] Product deleted successfully via ProductApiService');
        
        // Update the provider to remove from cache
        final productProvider = Provider.of<ProductProvider>(context, listen: false);
        productProvider.removeLocalProduct(widget.product.id);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text('${widget.product.name} deleted successfully'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        
        Navigator.pop(context, true); // Go back with success
      }
      
    } catch (e) {
      print('❌ [EditProduct] Delete error: $e');
      
      String errorMessage = 'Failed to delete product';
      
      if (e.toString().contains('AUTHENTICATION')) {
        errorMessage = 'Please login again to continue';
      } else if (e.toString().contains('PRODUCT_NOT_FOUND')) {
        errorMessage = 'Product not found. It may have been already deleted';
      } else if (e.toString().contains('NETWORK')) {
        errorMessage = 'Network error. Please check your connection';
      } else {
        final errorString = e.toString();
        if (errorString.contains(': ')) {
          errorMessage = errorString.split(': ').last;
        }
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(errorMessage)),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }
  
// ✅ ADD THIS: Show success messages helper method
void _showSuccess(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      duration: Duration(seconds: 3),
    ),
  );
}

// ✅ ADD THIS: Validate image file extensions helper method
bool _isValidImageFile(String fileName) {
  if (fileName.isEmpty) return false;
  
  final validExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
  final extension = fileName.toLowerCase().split('.').last;
  
  return validExtensions.contains(extension);
}

// ✅ ADD THIS: Enhanced error messages helper method (if not already present)

}