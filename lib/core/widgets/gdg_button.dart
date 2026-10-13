import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/shapes.dart';
import '../theme/spacing.dart';

/// GDG Filled Button adhering to Material 3 tokens.
class GdgFilledButton extends StatefulWidget {
  const GdgFilledButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isWide = false,
    this.isSmall = false,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final bool isWide;
  final bool isSmall;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  State<GdgFilledButton> createState() => _GdgFilledButtonState();
}

class _GdgFilledButtonState extends State<GdgFilledButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;
    final height = widget.isSmall ? 40.0 : 56.0;
    final bg = widget.backgroundColor ?? (_isPressed ? colors.primaryPress : colors.primary);
    final fg = widget.foregroundColor ?? colors.onPrimary;

    Widget content = Row(
      mainAxisSize: widget.isWide ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          widget.icon!,
          const SizedBox(width: GdgSpacing.sp2),
        ],
        DefaultTextStyle(
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: fg,
                fontWeight: FontWeight.w500,
              ),
          child: widget.child,
        ),
      ],
    );

    return AnimatedScale(
      scale: _isPressed ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      child: SizedBox(
        width: widget.isWide ? double.infinity : null,
        height: height,
        child: Material(
          color: widget.onPressed != null ? bg : colors.surfaceAlt,
          borderRadius: GdgShapes.full,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.onPressed,
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            borderRadius: GdgShapes.full,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.isSmall ? GdgSpacing.sp4 : GdgSpacing.sp6,
              ),
              child: Center(child: content),
            ),
          ),
        ),
      ),
    );
  }
}

/// GDG Outlined Button with 1dp border and pill shape.
class GdgOutlinedButton extends StatelessWidget {
  const GdgOutlinedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.icon,
    this.isSmall = true,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final Widget? icon;
  final bool isSmall;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;
    final height = isSmall ? 40.0 : 56.0;

    return SizedBox(
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colors.outline, width: 1),
          shape: const RoundedRectangleBorder(borderRadius: GdgShapes.full),
          padding: const EdgeInsets.symmetric(horizontal: GdgSpacing.sp4),
          foregroundColor: colors.primary,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: GdgSpacing.sp2),
            ],
            child,
          ],
        ),
      ),
    );
  }
}

/// GDG Icon Button maintaining min 48x48dp touch target.
class GdgIconButton extends StatelessWidget {
  const GdgIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.color,
  });

  final Widget icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;

    return Semantics(
      label: tooltip,
      button: true,
      child: SizedBox(
        width: GdgSpacing.minTouchTarget,
        height: GdgSpacing.minTouchTarget,
        child: IconButton(
          icon: icon,
          onPressed: onPressed,
          color: color ?? colors.onSurface2,
          tooltip: tooltip,
          splashRadius: 24,
        ),
      ),
    );
  }
}

/// GDG Primary Floating Action Button with brand tint and 16dp corners.
class GdgFab extends StatelessWidget {
  const GdgFab({
    super.key,
    required this.onPressed,
    required this.label,
    required this.icon,
  });

  final VoidCallback onPressed;
  final String label;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;

    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: colors.tintBlue,
      foregroundColor: colors.onTintBlue,
      elevation: 3,
      shape: const RoundedRectangleBorder(borderRadius: GdgShapes.lg),
      icon: icon,
      label: Text(label),
    );
  }
}
