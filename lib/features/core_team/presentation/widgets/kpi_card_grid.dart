import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/gdg_card.dart';
import '../../domain/models/core_dashboard_data.dart';

/// 2x2 KPI card grid for Organizer Dashboard (Screen 12).
class KpiCardGrid extends StatelessWidget {
  const KpiCardGrid({
    super.key,
    required this.kpis,
    this.onKpiTap,
  });

  final List<CoreKpiItem> kpis;
  final ValueChanged<CoreKpiItem>? onKpiTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - GdgSpacing.sp3) / 2;

        return Wrap(
          spacing: GdgSpacing.sp3,
          runSpacing: GdgSpacing.sp3,
          children: [
            for (final kpi in kpis)
              SizedBox(
                width: itemWidth,
                child: GdgCard(
                  tint: kpi.tint,
                  padding: const EdgeInsets.all(GdgSpacing.sp4),
                  onTap: onKpiTap != null ? () => onKpiTap!(kpi) : null,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(
                            kpi.icon,
                            size: 20,
                            color: _getIconColor(kpi.tint, colors),
                          ),
                          const SizedBox(width: GdgSpacing.sp2),
                          Expanded(
                            child: Text(
                              kpi.label,
                              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                    color: _getTextColor(kpi.tint, colors),
                                    fontWeight: FontWeight.w500,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: GdgSpacing.sp2),
                      Text(
                        kpi.count,
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _getTextColor(kpi.tint, colors),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Color _getIconColor(GdgCardTint tint, GdgColors colors) {
    return switch (tint) {
      GdgCardTint.blue => colors.onTintBlue,
      GdgCardTint.green => colors.onTintGreen,
      GdgCardTint.yellow => colors.onTintAmber,
      GdgCardTint.red => colors.onTintRed,
      GdgCardTint.none => colors.onSurface2,
    };
  }

  Color _getTextColor(GdgCardTint tint, GdgColors colors) {
    return switch (tint) {
      GdgCardTint.blue => colors.onTintBlue,
      GdgCardTint.green => colors.onTintGreen,
      GdgCardTint.yellow => colors.onTintAmber,
      GdgCardTint.red => colors.onTintRed,
      GdgCardTint.none => colors.onSurface,
    };
  }
}
