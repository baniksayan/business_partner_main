// lib/widgets/common/success_widget.dart
import 'package:flutter/material.dart';

class SuccessWidget extends StatefulWidget {
  final String message;
  final String? title;
  final IconData? icon;
  final VoidCallback? onContinue;
  final String? continueButtonText;
  final bool autoHide;
  final Duration autoHideDuration;

  const SuccessWidget({
    Key? key,
    required this.message,
    this.title,
    this.icon,
    this.onContinue,
    this.continueButtonText,
    this.autoHide = false,
    this.autoHideDuration = const Duration(seconds: 3),
  }) : super(key: key);

  @override
  State<SuccessWidget> createState() => _SuccessWidgetState();
}

class _SuccessWidgetState extends State<SuccessWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _animationController.forward();

    if (widget.autoHide) {
      Future.delayed(widget.autoHideDuration, () {
        if (mounted && widget.onContinue != null) {
          widget.onContinue!();
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Icon
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.icon ?? Icons.check_circle,
                    size: 60,
                    color: Colors.green,
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Title
              if (widget.title != null)
                Text(
                  widget.title!,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              
              if (widget.title != null) const SizedBox(height: 16),
              
              // Message
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Text(
                  widget.message,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              if (widget.onContinue != null && !widget.autoHide) ...[
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: widget.onContinue,
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                  label: Text(
                    widget.continueButtonText ?? 'Continue',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    shadowColor: Colors.black.withOpacity(0.3),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
