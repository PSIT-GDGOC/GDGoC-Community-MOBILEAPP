import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/gdg_avatar.dart';
import '../../../../core/widgets/gdg_card.dart';
import '../../domain/models/core_dashboard_data.dart';

/// Team card for Organizer Dashboard (Screen 12).
class TeamSummaryCard extends StatelessWidget {
  const TeamSummaryCard({
    super.key,
    required this.members,
    required this.totalCount,
    this.onTap,
  });

  final List<CoreTeamMember> members;
  final int totalCount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;
    final leadName = members.isNotEmpty ? members.first.name : 'Rohan Gupta';
    final remainingCount = totalCount - 1;

    return GdgCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: GdgSpacing.sp4,
        vertical: GdgSpacing.sp3,
      ),
      child: Row(
        children: [
          // Stacked avatars of core organizers
          GdgAvatarStack(
            names: members.map((m) => m.name).toList(),
            size: GdgAvatarSize.md,
            maxVisible: 3,
          ),
          const SizedBox(width: GdgSpacing.sp4),

          // Team label and summary
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Team',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$leadName and $remainingCount others',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: colors.onSurface2,
                      ),
                ),
              ],
            ),
          ),

          Icon(
            Icons.chevron_right_rounded,
            color: colors.onSurface3,
            size: 20,
          ),
        ],
      ),
    );
  }
}
