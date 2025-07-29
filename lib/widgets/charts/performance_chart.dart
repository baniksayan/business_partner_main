import 'package:flutter/material.dart';

class PerformanceChart extends StatelessWidget {
  final String value;
  final int percent;
  final List<int> data;

  const PerformanceChart(
      {Key? key, required this.value, required this.percent, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // For real projects, use fl_chart or charts_flutter for a real chart
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Revenue & Bookings",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: const Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(width: 10),
              Icon(percent >= 0 ? Icons.arrow_upward : Icons.arrow_downward, color: percent >= 0 ? Colors.green : Colors.red, size: 20),
              Text(
                "+$percent%",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: percent >= 0 ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "Last 7 Days",
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.blueGrey[400],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 80,
            child: CustomPaint(
              painter: _LineChartPainter(data),
              child: Container(),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
                .map((d) => Text(
                      d,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12, color: Colors.grey[600],
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<int> data;
  _LineChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = const Color(0xFF4FC3F7)
      ..strokeWidth = 3
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke;

    final paintShadow = Paint()
      ..shader = LinearGradient(
        colors: [const Color(0xFF4FC3F7).withOpacity(0.5), Colors.transparent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final double stepX = size.width / (data.length - 1);
    final maxY = data.reduce((a, b) => a > b ? a : b).toDouble();
    final minY = (data.reduce((a, b) => a < b ? a : b) - 2).toDouble();
    final List<Offset> points = [
      for (int i = 0; i < data.length; i++)
        Offset(i * stepX, size.height - ((data[i] - minY) * size.height / (maxY - minY + 1)))
    ];

    // Draw shadow under the line
    final pathShadow = Path();
    pathShadow.moveTo(points.first.dx, size.height);
    for (final p in points) { pathShadow.lineTo(p.dx, p.dy); }
    pathShadow.lineTo(points.last.dx, size.height);
    pathShadow.close();
    canvas.drawPath(pathShadow, paintShadow);

    // Draw line
    final pathLine = Path();
    pathLine.moveTo(points.first.dx, points.first.dy);
    for (final p in points) { pathLine.lineTo(p.dx, p.dy); }
    canvas.drawPath(pathLine, paintLine);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
