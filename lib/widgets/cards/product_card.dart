import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../views/products/product_details_screen.dart';

class AnimatedProductCard extends StatefulWidget {
  final Product product;
  final int delay;
  final VoidCallback onEdit;

  const AnimatedProductCard({
    Key? key,
    required this.product,
    required this.delay,
    required this.onEdit,
  }) : super(key: key);

  @override
  State<AnimatedProductCard> createState() => _AnimatedProductCardState();
}

class _AnimatedProductCardState extends State<AnimatedProductCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 550),
      vsync: this,
    );
    _opacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _slide = Tween(begin: const Offset(0, 0.08), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () => _controller.forward());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(
        position: _slide,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(product: widget.product),
              ),
            );
          },
          child: Card(
            elevation: 2.5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Image.asset(
                  widget.product.image,
                  fit: BoxFit.contain,
                ),
              ),
              title: Text(
                widget.product.name,
                style: const TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                  fontSize: 16.5,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  widget.product.price,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w500,
                    fontSize: 14.5,
                  ),
                ),
              ),
              trailing: InkWell(
                borderRadius: BorderRadius.circular(7),
                onTap: widget.onEdit,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(7),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.edit, color: Color(0xFF4FC3F7), size: 22),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
