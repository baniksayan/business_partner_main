import 'package:flutter/material.dart';

class StockLineChart extends StatefulWidget {
  final List<double> data;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const StockLineChart({
    Key? key,
    required this.data,
    required this.selectedIndex,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<StockLineChart> createState() => _StockLineChartState();
}

class _StockLineChartState extends State<StockLineChart> {
  void _onPanUpdate(DragUpdateDetails details, double width) {
    final posX = details.localPosition.dx.clamp(0.0, width);
    final index = (posX / width * (widget.data.length - 1)).round().clamp(0, widget.data.length - 1);
    widget.onChanged(index);
  }

  void _onTapDown(TapDownDetails details, double width) {
    final posX = details.localPosition.dx.clamp(0.0, width);
    final index = (posX / width * (widget.data.length - 1)).round().clamp(0, widget.data.length - 1);
    widget.onChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Chart area
        Container(
          height: 160,
          width: double.infinity,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;
              
              return GestureDetector(
                onHorizontalDragUpdate: (details) => _onPanUpdate(details, width),
                onTapDown: (details) => _onTapDown(details, width),
                child: CustomPaint(
                  painter: _StockChartPainter(
                    data: widget.data,
                    selectedIndex: widget.selectedIndex,
                  ),
                  size: Size(width, height),
                ),
              );
            },
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Day labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
              .asMap()
              .entries
              .map((entry) => Text(
                    entry.value,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: entry.key == widget.selectedIndex 
                          ? const Color(0xFF4FC3F7)
                          : Colors.grey[500],
                      fontWeight: entry.key == widget.selectedIndex 
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _StockChartPainter extends CustomPainter {
  final List<double> data;
  final int selectedIndex;

  _StockChartPainter({
    required this.data,
    required this.selectedIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final double maxY = data.reduce((a, b) => a > b ? a : b);
    final double minY = data.reduce((a, b) => a < b ? a : b);
    final double range = maxY - minY;
    final double stepX = size.width / (data.length - 1);

    // Create points for the line
    final List<Offset> points = data.asMap().entries.map((entry) {
      final double x = entry.key * stepX;
      final double y = size.height - ((entry.value - minY) / range * size.height * 0.8) - size.height * 0.1;
      return Offset(x, y);
    }).toList();

    // Paint for the gradient area under the line
    final Paint areaPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF4FC3F7).withOpacity(0.3),
          const Color(0xFF4FC3F7).withOpacity(0.05),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    // Paint for the line
    final Paint linePaint = Paint()
      ..color = const Color(0xFF4FC3F7)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Paint for the selected point
    final Paint pointPaint = Paint()
      ..color = const Color(0xFF4FC3F7)
      ..style = PaintingStyle.fill;

    final Paint pointBorderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Draw gradient area under the line
    final Path areaPath = Path();
    areaPath.moveTo(points.first.dx, size.height);
    for (final point in points) {
      areaPath.lineTo(point.dx, point.dy);
    }
    areaPath.lineTo(points.last.dx, size.height);
    areaPath.close();
    canvas.drawPath(areaPath, areaPaint);

    // Draw the smooth line
    final Path linePath = Path();
    linePath.moveTo(points.first.dx, points.first.dy);
    
    for (int i = 1; i < points.length; i++) {
      final p0 = points[i - 1];
      final p1 = points[i];
      
      // Create smooth curve using quadratic bezier
      final controlPoint = Offset(
        p0.dx + (p1.dx - p0.dx) * 0.5,
        p0.dy,
      );
      
      linePath.quadraticBezierTo(controlPoint.dx, controlPoint.dy, p1.dx, p1.dy);
    }
    
    canvas.drawPath(linePath, linePaint);

    // Draw selected point
    if (selectedIndex >= 0 && selectedIndex < points.length) {
      final selectedPoint = points[selectedIndex];
      
      // Draw outer circle (white border)
      canvas.drawCircle(selectedPoint, 8, pointBorderPaint);
      
      // Draw inner circle (blue)
      canvas.drawCircle(selectedPoint, 6, pointPaint);
      
      // Draw vertical line from point to bottom
      final Paint dashedLinePaint = Paint()
        ..color = const Color(0xFF4FC3F7).withOpacity(0.3)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;
      
      canvas.drawLine(
        Offset(selectedPoint.dx, selectedPoint.dy),
        Offset(selectedPoint.dx, size.height),
        dashedLinePaint,
      );
      
      // Draw value tooltip above the point
      _drawTooltip(canvas, selectedPoint, data[selectedIndex]);
    }
  }

  void _drawTooltip(Canvas canvas, Offset point, double value) {
    final tooltipPaint = Paint()
      ..color = const Color(0xFF4FC3F7)
      ..style = PaintingStyle.fill;

    final tooltipText = '₹${value.toStringAsFixed(0)}';
    final textPainter = TextPainter(
      text: TextSpan(
        text: tooltipText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout();
    
    final tooltipRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(point.dx, point.dy - 30),
        width: textPainter.width + 16,
        height: textPainter.height + 8,
      ),
      const Radius.circular(8),
    );
    
    canvas.drawRRect(tooltipRect, tooltipPaint);
    
    textPainter.paint(
      canvas,
      Offset(
        point.dx - textPainter.width / 2,
        point.dy - 34,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
