import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/shapes.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/gdg_avatar.dart';
import '../../../../core/widgets/gdg_card.dart';
import '../../../../core/widgets/gdg_chip.dart';
import '../../domain/models/board_entry.dart';

/// Screen 05: The Chapter Leaderboard ("Board") Hero Card.
class BoardCard extends StatelessWidget {
  const BoardCard({
    super.key,
    required this.userRank,
    required this.userPoints,
    required this.entries,
    required this.isExpanded,
    required this.selectedFilter,
    required this.onToggleExpand,
    required this.onFilterSelected,
  });

  final int userRank;
  final int userPoints;
  final List<BoardEntry> entries;
  final bool isExpanded;
  final String selectedFilter;
  final VoidCallback onToggleExpand;
  final ValueChanged<String> onFilterSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;

    final topThree = entries.take(3).toList();
    final remainingEntries = entries.skip(3).toList();

    return GdgCard(
      isHero: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Your rank on the Board & Points
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your rank on the Board',
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            color: colors.onSurface2,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '#$userRank',
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              GdgChipAssist(
                label: '$userPoints points',
                tone: GdgChipTone.blue,
                icon: const Icon(Icons.bolt, size: 16),
              ),
            ],
          ),
          const SizedBox(height: GdgSpacing.sp3),

          // Top 3 Leaders
          for (final entry in topThree) _buildLeaderRow(context, entry),

          // Expandable Remaining Leaders
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                for (final entry in remainingEntries)
                  _buildLeaderRow(context, entry),
              ],
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
          const SizedBox(height: GdgSpacing.sp3),

          // Filter chips & Toggle button
          Row(
            children: [
              _buildFilterChip(
                context,
                label: 'Events',
                icon: Icons.event,
                filterKey: 'events',
              ),
              const SizedBox(width: GdgSpacing.sp2),
              _buildFilterChip(
                context,
                label: 'Learning',
                icon: Icons.school,
                filterKey: 'learning',
              ),
              const SizedBox(width: GdgSpacing.sp2),
              _buildFilterChip(
                context,
                label: 'PRs',
                icon: Icons.merge_type,
                filterKey: 'prs',
              ),
              const Spacer(),
              TextButton(
                onPressed: onToggleExpand,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: GdgSpacing.sp2),
                  minimumSize: const Size(0, 36),
                ),
                child: Text(isExpanded ? 'Collapse' : 'View full Board'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderRow(BuildContext context, BoardEntry entry) {
    final colors = context.gdgColors;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: GdgSpacing.sp2, vertical: 6),
      decoration: BoxDecoration(
        color: entry.isCurrentUser ? colors.tintBlue : Colors.transparent,
        borderRadius: GdgShapes.md,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '${entry.rank}',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: entry.isCurrentUser ? colors.onTintBlue : colors.onSurface,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: GdgSpacing.sp2),
          GdgAvatar(
            name: entry.name,
            colorIndex: entry.colorIndex,
            size: GdgAvatarSize.sm,
          ),
          const SizedBox(width: GdgSpacing.sp3),
          Expanded(
            child: Text(
              entry.name,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: entry.isCurrentUser ? colors.onTintBlue : colors.onSurface,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '${entry.points} points',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: entry.isCurrentUser ? colors.onTintBlue : colors.onSurface2,
                  fontWeight: entry.isCurrentUser ? FontWeight.w600 : FontWeight.normal,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required IconData icon,
    required String filterKey,
  }) {
    final colors = context.gdgColors;
    final isSelected = selectedFilter == filterKey;

    return InkWell(
      onTap: () => onFilterSelected(filterKey),
      borderRadius: GdgShapes.full,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? colors.tintBlue : colors.surfaceAlt,
          borderRadius: GdgShapes.full,
          border: isSelected
              ? Border.all(color: colors.primary.withAlpha(80), width: 1)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? colors.onTintBlue : colors.onSurface2,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                    color: isSelected ? colors.onTintBlue : colors.onSurface2,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
