import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/shapes.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/gdg_card.dart';
import '../../domain/models/workshop_session.dart';

class SessionCard extends StatelessWidget {
  const SessionCard({
    super.key,
    required this.session,
    required this.onPlayTap,
  });

  final WorkshopSession session;
  final VoidCallback onPlayTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;

    return GdgCard(
      padding: const EdgeInsets.all(GdgSpacing.sp3),
      onTap: onPlayTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Play icon in tinted circular container
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colors.tintBlue,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.play_circle_filled_rounded,
              color: colors.brandBlue,
              size: 28,
            ),
          ),
          const SizedBox(width: GdgSpacing.sp3),

          // Title & Speaker / Date metadata
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: GdgSpacing.sp1),
                Text(
                  '${session.speaker} · ${session.metadataLine}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: colors.onSurface2),
                ),
              ],
            ),
          ),
          const SizedBox(width: GdgSpacing.sp2),

          // Visible Duration Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: colors.surfaceAlt,
              borderRadius: GdgShapes.full,
              border: Border.all(color: colors.outline, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.timer_outlined, size: 12, color: colors.onSurface2),
                const SizedBox(width: 4),
                Text(
                  session.duration,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colors.onSurface2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
