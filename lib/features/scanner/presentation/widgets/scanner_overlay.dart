import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/shapes.dart';
import '../../../../core/theme/spacing.dart';

/// Semi-transparent dark overlay with cut-out scan window and corner markers.
class ScannerOverlay extends StatefulWidget {
  const ScannerOverlay({
    super.key,
    this.scanBoxSize = 260.0,
  });

  final double scanBoxSize;

  @override
  State<ScannerOverlay> createState() => _ScannerOverlayState();
}

class _ScannerOverlayState extends State<ScannerOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    // Don't repeat infinitely if in a non-repeating environment
    _animController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;
    final size = widget.scanBoxSize;

    return Stack(
      children: [
        // Darkened Scrim with transparent hole
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.65),
            BlendMode.srcOut,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Center(
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: GdgShapes.lg,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Corner Guides & Animated Laser
        Center(
          child: SizedBox(
            width: size,
            height: size,
            child: Stack(
              children: [
                // 4 Corner Brackets
                Positioned(top: 0, left: 0, child: _CornerBracket(corner: _Corner.topLeft, color: colors.brandBlue)),
                Positioned(top: 0, right: 0, child: _CornerBracket(corner: _Corner.topRight, color: colors.brandBlue)),
                Positioned(bottom: 0, left: 0, child: _CornerBracket(corner: _Corner.bottomLeft, color: colors.brandBlue)),
                Positioned(bottom: 0, right: 0, child: _CornerBracket(corner: _Corner.bottomRight, color: colors.brandBlue)),

                // Animated Laser Sweep Line
                AnimatedBuilder(
                  animation: _animController,
                  builder: (context, child) {
                    return Positioned(
                      top: 16 + (size - 32) * _animController.value,
                      left: 16,
                      right: 16,
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colors.brandBlue.withValues(alpha: 0.1),
                              colors.brandBlue,
                              colors.brandBlue.withValues(alpha: 0.1),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: colors.brandBlue.withValues(alpha: 0.6),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        // Instruction Text Below Viewfinder
        Positioned(
          left: 0,
          right: 0,
          top: MediaQuery.of(context).size.height * 0.5 + (size / 2) + GdgSpacing.sp4,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: GdgShapes.full,
              ),
              child: const Text(
                'Align ticket QR code within the frame',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

enum _Corner { topLeft, topRight, bottomLeft, bottomRight }

class _CornerBracket extends StatelessWidget {
  const _CornerBracket({required this.corner, required this.color});

  final _Corner corner;
  final Color color;

  @override
  Widget build(BuildContext context) {
    const double length = 24.0;
    const double thickness = 3.5;
    const double radius = 16.0;

    return CustomPaint(
      size: const Size(length, length),
      painter: _CornerPainter(
        corner: corner,
        color: color,
        length: length,
        thickness: thickness,
        radius: radius,
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  _CornerPainter({
    required this.corner,
    required this.color,
    required this.length,
    required this.thickness,
    required this.radius,
  });

  final _Corner corner;
  final Color color;
  final double length;
  final double thickness;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    switch (corner) {
      case _Corner.topLeft:
        path.moveTo(0, length);
        path.lineTo(0, radius);
        path.arcToPoint(Offset(radius, 0), radius: Radius.circular(radius));
        path.lineTo(length, 0);
        break;
      case _Corner.topRight:
        path.moveTo(size.width - length, 0);
        path.lineTo(size.width - radius, 0);
        path.arcToPoint(Offset(size.width, radius), radius: Radius.circular(radius));
        path.lineTo(size.width, length);
        break;
      case _Corner.bottomLeft:
        path.moveTo(0, size.height - length);
        path.lineTo(0, size.height - radius);
        path.arcToPoint(Offset(radius, size.height), radius: Radius.circular(radius));
        path.lineTo(length, size.height);
        break;
      case _Corner.bottomRight:
        path.moveTo(size.width - length, size.height);
        path.lineTo(size.width - radius, size.height);
        path.arcToPoint(Offset(size.width, size.height - radius), radius: Radius.circular(radius));
        path.lineTo(size.width, size.height - length);
        break;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
