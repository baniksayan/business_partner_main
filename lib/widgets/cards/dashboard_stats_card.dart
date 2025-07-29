import 'package:flutter/material.dart';

class DashboardStatData {
  final String label;
  final String value;
  final String percent;
  final Color percentColor;
  DashboardStatData(this.label, this.value, this.percent, this.percentColor);
}

class DashboardStatsCard extends StatelessWidget {
  final DashboardStatData data;
  const DashboardStatsCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10, offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.label,
            style: TextStyle(
              fontFamily: 'Inter',
              color: Colors.grey[700],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          AnimatedNumber(
            value: data.value,
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
            duration: const Duration(milliseconds: 1100),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                data.percentColor == Colors.green ? Icons.arrow_upward : Icons.arrow_downward,
                color: data.percentColor,
                size: 15,
              ),
              const SizedBox(width:4),
              Text(
                data.percent,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: data.percentColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Fancy counter animation for numbers
class AnimatedNumber extends StatefulWidget {
  final String value;
  final TextStyle style;
  final Duration duration;
  const AnimatedNumber(
    {super.key, required this.value, required this.style, this.duration = const Duration(milliseconds: 800)});
  @override
  State<AnimatedNumber> createState() => _AnimatedNumberState();
}

class _AnimatedNumberState extends State<AnimatedNumber> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation;
  double _target = 0;
  double _oldValue = 0;

  @override
  void initState() {
    super.initState();
    _target = double.tryParse(widget.value.replaceAll(RegExp('[^0-9.]'), '')) ?? 0;
    _controller = AnimationController(vsync: this, duration: widget.duration);
    animation = Tween<double>(begin: 0, end: _target).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart))
      ..addListener(() => setState(() {}));
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedNumber oldWidget) {
    super.didUpdateWidget(oldWidget);
    _oldValue = _target;
    _target = double.tryParse(widget.value.replaceAll(RegExp('[^0-9.]'), '')) ?? 0;
    animation = Tween<double>(begin: _oldValue, end: _target).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutQuart));
    _controller
      ..reset()
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String display = widget.value.contains('₹')
        ? "₹${animation.value.toStringAsFixed(0)}"
        : animation.value.toStringAsFixed(
            widget.value.contains('.') ? 1 : 0,
          );
    return Text(
      display,
      style: widget.style,
    );
  }
}
