import 'package:flutter/material.dart';
import '../theme/colors.dart';

/// GDG brand chevron logo stand-in matching the mockup SVG.
/// Renders crisp vector paths for the 4 brand colors: Blue, Green, Red, Yellow.
class GdgLogo extends StatelessWidget {
  const GdgLogo({
    super.key,
    this.width = 44,
    this.height = 22,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;

    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _GdgLogoPainter(
          blue: colors.brandBlue,
          green: colors.brandGreen,
          red: colors.brandRed,
          yellow: colors.brandYellow,
        ),
      ),
    );
  }
}

class _GdgLogoPainter extends CustomPainter {
  const _GdgLogoPainter({
    required this.blue,
    required this.green,
    required this.red,
    required this.yellow,
  });

  final Color blue;
  final Color green;
  final Color red;
  final Color yellow;

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 64.0;
    final scaleY = size.height / 32.0;

    Paint createPaint(Color color) => Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0 * scaleY
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Left bracket upper: M17 6 L5 16 (Blue)
    final bluePath = Path()
      ..moveTo(17 * scaleX, 6 * scaleY)
      ..lineTo(5 * scaleX, 16 * scaleY);
    canvas.drawPath(bluePath, createPaint(blue));

    // Left bracket lower: M5 16 L17 26 (Green)
    final greenPath = Path()
      ..moveTo(5 * scaleX, 16 * scaleY)
      ..lineTo(17 * scaleX, 26 * scaleY);
    canvas.drawPath(greenPath, createPaint(green));

    // Right bracket upper: M47 6 L59 16 (Red)
    final redPath = Path()
      ..moveTo(47 * scaleX, 6 * scaleY)
      ..lineTo(59 * scaleX, 16 * scaleY);
    canvas.drawPath(redPath, createPaint(red));

    // Right bracket lower: M59 16 L47 26 (Yellow)
    final yellowPath = Path()
      ..moveTo(59 * scaleX, 16 * scaleY)
      ..lineTo(47 * scaleX, 26 * scaleY);
    canvas.drawPath(yellowPath, createPaint(yellow));
  }

  @override
  bool shouldRepaint(covariant _GdgLogoPainter oldDelegate) {
    return oldDelegate.blue != blue ||
        oldDelegate.green != green ||
        oldDelegate.red != red ||
        oldDelegate.yellow != yellow;
  }
}
