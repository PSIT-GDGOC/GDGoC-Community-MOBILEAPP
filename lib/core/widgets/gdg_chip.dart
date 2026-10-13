import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/shapes.dart';
import '../theme/spacing.dart';

enum GdgChipTone {
  neutral,
  blue,
  green,
  red,
  yellow,
}

/// Filter chip with standard 32dp height and pressed/active state.
class GdgChipFilter extends StatelessWidget {
  const GdgChipFilter({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;

    return SizedBox(
      height: 32,
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: onSelected,
        showCheckmark: false,
        backgroundColor: colors.surface,
        selectedColor: colors.tintBlue,
        labelStyle: Theme.of(context).textTheme.labelLarge!.copyWith(
              color: isSelected ? colors.onTintBlue : colors.onSurface2,
              fontWeight: FontWeight.w500,
            ),
        side: isSelected
            ? BorderSide.none
            : BorderSide(color: colors.outline, width: 1),
        shape: const RoundedRectangleBorder(borderRadius: GdgShapes.full),
        padding: const EdgeInsets.symmetric(horizontal: GdgSpacing.sp3),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

/// Assist and status badge chip with 28dp height and semantic tint tones.
class GdgChipAssist extends StatelessWidget {
  const GdgChipAssist({
    super.key,
    required this.label,
    this.tone = GdgChipTone.neutral,
    this.icon,
    this.onTap,
  });

  final String label;
  final GdgChipTone tone;
  final Widget? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;

    final (Color bg, Color fg) = switch (tone) {
      GdgChipTone.blue => (colors.tintBlue, colors.onTintBlue),
      GdgChipTone.green => (colors.tintGreen, colors.onTintGreen),
      GdgChipTone.red => (colors.tintRed, colors.onTintRed),
      GdgChipTone.yellow => (colors.tintYellow, colors.onTintAmber),
      GdgChipTone.neutral => (colors.surfaceAlt, colors.onSurface2),
    };

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          IconTheme(
            data: IconThemeData(size: 16, color: fg),
            child: icon!,
          ),
          const SizedBox(width: GdgSpacing.sp1),
        ],
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color: fg,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );

    return InkWell(
      onTap: onTap,
      borderRadius: GdgShapes.full,
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: GdgShapes.full,
        ),
        alignment: Alignment.center,
        child: content,
      ),
    );
  }
}
