// lib/widgets/products/product_overview_section.dart - ENHANCED WITH IMAGE SLIDER
import 'package:business_partner_main/widgets/products/full_screen_image_gallery.dart';
import 'package:flutter/material.dart';
import '../../models/product.dart';

class ProductOverviewSection extends StatefulWidget {
  final Product product;
  final Map<String, dynamic> productMetrics;

  const ProductOverviewSection({
    Key? key,
    required this.product,
    required this.productMetrics,
  }) : super(key: key);

  @override
  State<ProductOverviewSection> createState() => _ProductOverviewSectionState();
}

class _ProductOverviewSectionState extends State<ProductOverviewSection> 
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _indicatorController;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _indicatorController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    // Auto-slide timer if more than one image
    if (widget.product.imageUrls.length > 1) {
      _startAutoSlide();
    }
  }

  void _startAutoSlide() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted && widget.product.imageUrls.length > 1) {
        _nextImage();
        _startAutoSlide();
      }
    });
  }

  void _nextImage() {
    if (widget.product.imageUrls.length <= 1) return;
    
    final nextIndex = (_currentImageIndex + 1) % widget.product.imageUrls.length;
    _pageController.animateToPage(
      nextIndex,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _goToImage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _indicatorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ ENHANCED: Multi-Image Slider Section
            _buildImageSliderSection(),
            
            const SizedBox(height: 20),
            
            // Product Information (unchanged)
            _buildProductInfo(),
            
            const SizedBox(height: 16),
            
            // Product Stats (unchanged) 
            _buildProductStats(),
            
            const SizedBox(height: 16),
            
            // Quick Actions (unchanged)
            _buildQuickActions(),
          ],
        ),
      ),
    );
  }

  // ✅ NEW: Enhanced Image Slider Section
  Widget _buildImageSliderSection() {
    final images = widget.product.imageUrls;
    
    if (images.isEmpty) {
      return _buildNoImagePlaceholder();
    }

    return Container(
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[100],
      ),
      child: Stack(
        children: [
          // ✅ Main Image Slider
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentImageIndex = index;
                });
                _indicatorController.forward().then((_) {
                  _indicatorController.reverse();
                });
              },
              itemCount: images.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _showFullScreenImage(index),
                  child: Hero(
                    tag: 'product_image_$index',
                    child: Image.network(
                      images[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 240,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: double.infinity,
                          height: 240,
                          color: Colors.grey[200],
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              color: const Color(0xFF4FC3F7),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 240,
                          color: Colors.grey[200],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.broken_image_outlined,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Image not available',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),

          // ✅ Image Counter (Top Right)
          if (images.length > 1)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_currentImageIndex + 1}/${images.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

          // ✅ Navigation Arrows (for manual navigation)
          if (images.length > 1) ...[
            // Previous Arrow
            Positioned(
              left: 12,
              top: 0,
              bottom: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    final prevIndex = _currentImageIndex > 0 
                        ? _currentImageIndex - 1 
                        : images.length - 1;
                    _goToImage(prevIndex);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.chevron_left,
                      color: Color(0xFF4FC3F7),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),

            // Next Arrow
            Positioned(
              right: 12,
              top: 0,
              bottom: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    final nextIndex = (_currentImageIndex + 1) % images.length;
                    _goToImage(nextIndex);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.chevron_right,
                      color: Color(0xFF4FC3F7),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],

          // ✅ Page Indicators (Bottom)
          if (images.length > 1)
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(images.length, (index) {
                  return GestureDetector(
                    onTap: () => _goToImage(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentImageIndex == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentImageIndex == index 
                            ? const Color(0xFF4FC3F7)
                            : Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          if (_currentImageIndex == index)
                            BoxShadow(
                              color: const Color(0xFF4FC3F7).withOpacity(0.4),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),

          // ✅ Zoom Icon (Bottom Right)
          Positioned(
            bottom: 12,
            right: 12,
            child: GestureDetector(
              onTap: () => _showFullScreenImage(_currentImageIndex),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.fullscreen,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ NEW: No Image Placeholder
  Widget _buildNoImagePlaceholder() {
    return Container(
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[100],
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 12),
          Text(
            'No Product Images',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Add images to showcase your product',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ✅ NEW: Full Screen Image View
  void _showFullScreenImage(int initialIndex) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black87,
        pageBuilder: (context, animation, _) {
          return FadeTransition(
            opacity: animation,
            child: FullScreenImageGallery(
              images: widget.product.imageUrls,
              initialIndex: initialIndex,
              productName: widget.product.name,
            ),
          );
        },
      ),
    );
  }

  // Product Info Section (unchanged)
  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.product.category,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: widget.product.isActive 
                    ? Colors.green.withOpacity(0.1)
                    : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: widget.product.isActive 
                      ? Colors.green.withOpacity(0.3)
                      : Colors.orange.withOpacity(0.3),
                ),
              ),
              child: Text(
                widget.product.isActive ? 'Active' : 'Inactive',
                style: TextStyle(
                  color: widget.product.isActive ? Colors.green[700] : Colors.orange[700],
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              widget.product.priceDisplay,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4FC3F7),
              ),
            ),
            if (widget.product.discountPercentage != null && widget.product.discountPercentage! > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${widget.product.discountPercentage}% OFF',
                  style: TextStyle(
                    color: Colors.red[700],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  // Product Stats Section (unchanged)
  Widget _buildProductStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF4FC3F7).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF4FC3F7).withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildStatItem(
                icon: Icons.inventory_outlined,
                label: 'In Stock',
                value: '${widget.product.quantity}',
                color: widget.product.quantity > 10 ? Colors.green : Colors.orange,
              ),
              const SizedBox(width: 20),
              _buildStatItem(
                icon: Icons.shopping_cart_outlined,
                label: 'Total Sales',
                value: '${widget.productMetrics['totalSales']}',
                color: const Color(0xFF4FC3F7),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatItem(
                icon: Icons.visibility_outlined,
                label: 'Views',
                value: '${widget.productMetrics['views']}',
                color: Colors.purple,
              ),
              const SizedBox(width: 20),
              _buildStatItem(
                icon: Icons.star_outline,
                label: 'Rating',
                value: '${widget.productMetrics['averageRating']}',
                color: Colors.amber,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Quick Actions Section (unchanged)
  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // Quick edit action
            },
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Quick Edit'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF4FC3F7),
              side: const BorderSide(color: Color(0xFF4FC3F7)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // Share product action
            },
            icon: const Icon(Icons.share_outlined, size: 18),
            label: const Text('Share'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4FC3F7),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
