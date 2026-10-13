import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/shapes.dart';
import '../theme/spacing.dart';

enum GdgCardTint {
  none,
  blue,
  green,
  red,
  yellow,
}

/// Material 3 Card adhering to GDGoC outline and tint tokens.
class GdgCard extends StatelessWidget {
  const GdgCard({
    super.key,
    required this.child,
    this.isHero = false,
    this.tint = GdgCardTint.none,
    this.padding = const EdgeInsets.all(GdgSpacing.sp4),
    this.onTap,
  });

  final Widget child;
  final bool isHero;
  final GdgCardTint tint;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;
    final borderRadius = isHero ? GdgShapes.xl : GdgShapes.lg;

    final Color bg = switch (tint) {
      GdgCardTint.blue => colors.tintBlue,
      GdgCardTint.green => colors.tintGreen,
      GdgCardTint.red => colors.tintRed,
      GdgCardTint.yellow => colors.tintYellow,
      GdgCardTint.none => colors.surface,
    };

    final Border? border = tint == GdgCardTint.none
        ? Border.all(color: colors.outline, width: 1)
        : null;

    final cardContent = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: borderRadius,
        border: border,
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: cardContent,
        ),
      );
    }

    return cardContent;
  }
}
