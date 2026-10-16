import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/shapes.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/gdg_button.dart';
import '../../../../core/widgets/gdg_card.dart';
import '../../../../core/widgets/gdg_linear_progress.dart';
import '../../domain/models/learning_path.dart';

class LearningPathCard extends StatelessWidget {
  const LearningPathCard({super.key, required this.path, required this.onTap});

  final LearningPath path;
  final VoidCallback onTap;

  (Color bg, Color fg, Color barColor) _resolveColors(
    BuildContext context,
    LearningTrackColor color,
  ) {
    final colors = context.gdgColors;
    return switch (color) {
      LearningTrackColor.blue => (
        colors.tintBlue,
        colors.brandBlue,
        colors.brandBlue,
      ),
      LearningTrackColor.green => (
        colors.tintGreen,
        colors.brandGreen,
        colors.brandGreen,
      ),
      LearningTrackColor.red => (
        colors.tintRed,
        colors.brandRed,
        colors.brandRed,
      ),
      LearningTrackColor.yellow => (
        colors.tintYellow,
        colors.onTintAmber,
        colors.brandYellow,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;
    final (iconBg, iconFg, barColor) = _resolveColors(context, path.trackColor);

    return GdgCard(
      padding: const EdgeInsets.all(GdgSpacing.sp4),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Tinted Shape Container for Icon (44dp x 44dp matching mockup)
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: GdgShapes.md,
                ),
                alignment: Alignment.center,
                child: Icon(path.iconData, color: iconFg, size: 24),
              ),
              const SizedBox(width: GdgSpacing.sp3),

              // Title & Progress metadata
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      path.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: GdgSpacing.sp1),
                    // Exact format: "6 of 10 modules · 24 hours"
                    Text(
                      path.progressMetadata,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: colors.onSurface2),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: GdgSpacing.sp2),

              // Action button (Continue / Start / Review)
              GdgFilledButton(
                isSmall: true,
                onPressed: onTap,
                child: Text(path.actionLabel),
              ),
            ],
          ),
          const SizedBox(height: GdgSpacing.sp3),

          // Linear Progress Indicator dynamically reflecting completion
          GdgLinearProgress(
            progress: path.progressRatio,
            color: barColor,
            height: 6,
          ),
        ],
      ),
    );
  }
}
