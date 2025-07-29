import 'package:flutter/material.dart';

class InteractivePerformanceChart extends StatefulWidget {
  final List<double> data;
  final void Function(double value, int index) onSelected;
  const InteractivePerformanceChart({
    required this.data,
    required this.onSelected,
    Key? key,
  }) : super(key: key);
  @override
  State<InteractivePerformanceChart> createState() => _InteractivePerformanceChartState();
}

class _InteractivePerformanceChartState extends State<InteractivePerformanceChart> {
  late int _currentIndex;
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.data.length - 1;
  }

  void _onPanUpdate(DragUpdateDetails d, double width) {
    final posX = d.localPosition.dx.clamp(0.0, width);
    final index = (posX / width * (widget.data.length - 1)).round().clamp(0, widget.data.length - 1);
    setState(() => _currentIndex = index);
    widget.onSelected(widget.data[index], index);
  }

  @override
  Widget build(BuildContext context) {
    final chartHeight = 90.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final maxY = widget.data.reduce((a, b) => a > b ? a : b);
        final minY = widget.data.reduce((a, b) => a < b ? a : b);

        List<Offset> points = List.generate(
          widget.data.length,
          (i) => Offset(
            i * width / (widget.data.length - 1),
            chartHeight - ((widget.data[i] - minY) * chartHeight / (maxY - minY + 1)),
          ),
        );

        return GestureDetector(
          onHorizontalDragUpdate: (d) => _onPanUpdate(d, width),
          onTapDown: (d) => _onPanUpdate(
  DragUpdateDetails(
    localPosition: d.localPosition,
    globalPosition: d.globalPosition, // Add this
  ),
  width,
),

          child: SizedBox(
            height: chartHeight,
            width: double.infinity,
            child: CustomPaint(
              painter: _PerformanceLinePainter(points: points, selected: _currentIndex),
            ),
          ),
        );
      },
    );
  }
}

class _PerformanceLinePainter extends CustomPainter {
  final List<Offset> points;
  final int selected;

  _PerformanceLinePainter({required this.points, required this.selected});
  @override
  void paint(Canvas canvas, Size size) {
    // Line
    final linePaint = Paint()
      ..color = const Color(0xFF4FC3F7)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    // Shadow
    final shadowPaint = Paint()
      ..shader = LinearGradient(
        colors: [const Color(0xFF4FC3F7).withOpacity(0.30), Colors.transparent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points) path.lineTo(p.dx, p.dy);

    // Shadow area fill
    final pathShadow = Path()..addPath(path, Offset.zero);
    pathShadow.lineTo(points.last.dx, size.height);
    pathShadow.lineTo(points.first.dx, size.height);
    pathShadow.close();
    canvas.drawPath(pathShadow, shadowPaint);

    // Line
    canvas.drawPath(path, linePaint);

    // THUMB
    if (selected >= 0 && selected < points.length) {
      final p = points[selected];
      canvas.drawCircle(
        p,
        8,
        Paint()
          ..color = const Color(0xFF4FC3F7)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.solid, 3),
      );
      const icon = Icons.drag_indicator;

      // Optionally: Draw value label bubble above thumb
    }
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
