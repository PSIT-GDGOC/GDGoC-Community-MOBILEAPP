import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/shapes.dart';
import '../../../../core/theme/spacing.dart';
import '../../domain/models/core_dashboard_data.dart';

/// "Needs your attention" section for Organizer Dashboard (Screen 12).
class AttentionSection extends StatelessWidget {
  const AttentionSection({
    super.key,
    required this.items,
    required this.onItemTap,
  });

  final List<AttentionItem> items;
  final ValueChanged<AttentionItem> onItemTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Text(
          'Needs your attention',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: GdgSpacing.sp3),

        // List of Attention Items
        for (int i = 0; i < items.length; i++) ...[
          _buildAttentionTile(context, items[i], colors),
          if (i < items.length - 1)
            Divider(
              height: 1,
              thickness: 1,
              color: colors.surfaceAlt,
            ),
        ],
      ],
    );
  }

  Widget _buildAttentionTile(
    BuildContext context,
    AttentionItem item,
    GdgColors colors,
  ) {
    final (Color bg, Color fg) = switch (item.colorKey) {
      'yellow' => (colors.tintYellow, colors.onTintAmber),
      'blue' => (colors.tintBlue, colors.onTintBlue),
      'green' => (colors.tintGreen, colors.onTintGreen),
      'red' => (colors.tintRed, colors.onTintRed),
      _ => (colors.surfaceAlt, colors.onSurface2),
    };

    return InkWell(
      onTap: () => onItemTap(item),
      borderRadius: GdgShapes.md,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: GdgSpacing.sp3,
          horizontal: GdgSpacing.sp1,
        ),
        child: Row(
          children: [
            // Colored Squircle / Shape Icon Container
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: bg,
                borderRadius: GdgShapes.md,
              ),
              alignment: Alignment.center,
              child: Icon(item.icon, size: 20, color: fg),
            ),
            const SizedBox(width: GdgSpacing.sp3),

            // Title & Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.subtitle,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: colors.onSurface2,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Trailing Chevron
            Icon(
              Icons.chevron_right_rounded,
              color: colors.onSurface3,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
