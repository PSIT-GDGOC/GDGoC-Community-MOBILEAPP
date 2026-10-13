import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/shapes.dart';

/// 6dp pill-shaped linear progress bar matching the design system.
class GdgLinearProgress extends StatelessWidget {
  const GdgLinearProgress({
    super.key,
    required this.progress,
    this.color,
    this.height = 6.0,
  });

  /// Normalized progress between 0.0 and 1.0.
  final double progress;
  final Color? color;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;
    final clamped = progress.clamp(0.0, 1.0);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: GdgShapes.full,
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.centerLeft,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            width: constraints.maxWidth * clamped,
            height: height,
            decoration: BoxDecoration(
              color: color ?? colors.brandBlue,
              borderRadius: GdgShapes.full,
            ),
          );
        },
      ),
    );
  }
}
