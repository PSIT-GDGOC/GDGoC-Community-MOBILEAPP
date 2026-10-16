import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/widgets/gdg_card.dart';
import '../../domain/models/member_profile.dart';

class ProfileStatisticsBar extends StatelessWidget {
  const ProfileStatisticsBar({super.key, required this.profile});

  final MemberProfile profile;

  Widget _buildStatCard(
    BuildContext context, {
    required String value,
    required String label,
    required Color accentColor,
  }) {
    final colors = context.gdgColors;

    return Expanded(
      child: GdgCard(
        padding: const EdgeInsets.symmetric(
          horizontal: GdgSpacing.sp3,
          vertical: GdgSpacing.sp3,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value,
              style: GdgTypography.mono(
                context,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: accentColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colors.onSurface2,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;

    return Row(
      children: [
        _buildStatCard(
          context,
          value: '${profile.mergedPRs}',
          label: 'Merged',
          accentColor: colors.brandGreen,
        ),
        const SizedBox(width: GdgSpacing.sp2),
        _buildStatCard(
          context,
          value: '${profile.openPRs}',
          label: 'Open PRs',
          accentColor: colors.brandBlue,
        ),
        const SizedBox(width: GdgSpacing.sp2),
        _buildStatCard(
          context,
          value: profile.rank,
          label: 'Rank',
          accentColor: colors.onTintAmber,
        ),
      ],
    );
  }
}
