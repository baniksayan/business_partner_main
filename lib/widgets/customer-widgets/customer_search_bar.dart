import 'package:flutter/material.dart';
import '../../views/styles/app_colors.dart';
import '../../views/styles/app_text_styles.dart';
import '../../views/styles/customer-style/customer_styles.dart';

class CustomerSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final VoidCallback? onClear;
  final String? hintText;
  final bool enabled;

  const CustomerSearchBar({
    Key? key,
    required this.controller,
    required this.onChanged,
    this.onClear,
    this.hintText = 'Search customers by name, phone...',
    this.enabled = true,
  }) : super(key: key);

  @override
  _CustomerSearchBarState createState() => _CustomerSearchBarState();
}

class _CustomerSearchBarState extends State<CustomerSearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: _isFocused 
                    ? AppColors.primaryColor.withOpacity(0.15)
                    : Colors.black.withOpacity(0.05),
                  blurRadius: _isFocused ? 12 : 8,
                  offset: Offset(0, _isFocused ? 4 : 2),
                  spreadRadius: _isFocused ? 1 : 0,
                ),
              ],
            ),
            child: TextField(
              controller: widget.controller,
              enabled: widget.enabled,
              onChanged: widget.onChanged,
              onTap: () {
                setState(() => _isFocused = true);
                _animationController.forward();
              },
              onTapOutside: (event) {
                setState(() => _isFocused = false);
                _animationController.reverse();
                FocusScope.of(context).unfocus();
              },
              style: AppTextStyles.bodyText.copyWith(
                fontWeight: FontWeight.w500,
              ),
              decoration: CustomerStyles.searchInputDecoration.copyWith(
                suffixIcon: widget.controller.text.isNotEmpty
                    ? Container(
                        margin: EdgeInsets.all(8),
                        child: Material(
                          color: AppColors.lightGreyColor,
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              widget.controller.clear();
                              widget.onChanged('');
                              if (widget.onClear != null) widget.onClear!();
                              setState(() {});
                            },
                            child: Container(
                              width: 32,
                              height: 32,
                              child: Icon(
                                Icons.close_rounded,
                                color: AppColors.greyColor,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
