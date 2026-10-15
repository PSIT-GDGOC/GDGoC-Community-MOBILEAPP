import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/shapes.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/gdg_chip.dart';
import '../../domain/models/member_profile.dart';

class BadgesSkillsSection extends StatelessWidget {
  const BadgesSkillsSection({
    super.key,
    required this.badges,
    required this.skillChips,
    required this.onAddSkill,
    required this.onRemoveSkill,
  });

  final List<ProfileBadge> badges;
  final List<String> skillChips;
  final ValueChanged<String> onAddSkill;
  final ValueChanged<String> onRemoveSkill;

  IconData _resolveBadgeIcon(String name) {
    return switch (name) {
      'workspace_premium' => Icons.workspace_premium_rounded,
      'event' => Icons.event_available_rounded,
      'bug_report' => Icons.bug_report_rounded,
      'celebration' => Icons.celebration_rounded,
      _ => Icons.stars_rounded,
    };
  }

  GdgChipTone _resolveTone(String colorTone) {
    return switch (colorTone) {
      'yellow' => GdgChipTone.yellow,
      'blue' => GdgChipTone.blue,
      'green' => GdgChipTone.green,
      'red' => GdgChipTone.red,
      _ => GdgChipTone.neutral,
    };
  }

  void _showBadgeDialog(BuildContext context, ProfileBadge badge) {
    final colors = context.gdgColors;
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: GdgShapes.lg),
          title: Row(
            children: [
              Icon(
                _resolveBadgeIcon(badge.iconName),
                color: badge.isUnlocked
                    ? colors.brandYellow
                    : colors.onSurface3,
                size: 28,
              ),
              const SizedBox(width: GdgSpacing.sp2),
              Text(badge.title),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                badge.description,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: colors.onSurface2),
              ),
              const SizedBox(height: GdgSpacing.sp3),
              if (badge.isUnlocked && badge.unlockedAt != null)
                Text(
                  'Unlocked on ${badge.unlockedAt}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colors.brandGreen,
                    fontWeight: FontWeight.w600,
                  ),
                )
              else
                Text(
                  'Locked — Complete event objectives to unlock',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colors.onSurface3,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showAddSkillDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: GdgShapes.lg),
          title: const Text('Add Skill'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'e.g. Flutter, Kotlin, Docker',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  onAddSkill(controller.text.trim());
                }
                Navigator.of(ctx).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Badges Row
        Wrap(
          spacing: GdgSpacing.sp2,
          runSpacing: GdgSpacing.sp2,
          children: badges.map((badge) {
            return GdgChipAssist(
              label: badge.title,
              tone: badge.isUnlocked
                  ? _resolveTone(badge.colorTone)
                  : GdgChipTone.neutral,
              icon: Icon(_resolveBadgeIcon(badge.iconName), size: 16),
              onTap: () => _showBadgeDialog(context, badge),
            );
          }).toList(),
        ),

        const SizedBox(height: GdgSpacing.sp3),

        // Skills Wrapping Row
        Wrap(
          spacing: GdgSpacing.sp2,
          runSpacing: GdgSpacing.sp2,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ...skillChips.map((skill) {
              return Chip(
                label: Text(skill),
                avatar: const Icon(Icons.code_rounded, size: 14),
                backgroundColor: colors.surfaceAlt,
                labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w500,
                ),
                shape: const RoundedRectangleBorder(
                  borderRadius: GdgShapes.full,
                ),
                side: BorderSide(color: colors.outline, width: 1),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onDeleted: () => onRemoveSkill(skill),
                deleteIconColor: colors.onSurface3,
              );
            }),
            ActionChip(
              avatar: const Icon(Icons.add_rounded, size: 16),
              label: const Text('Add'),
              onPressed: () => _showAddSkillDialog(context),
              backgroundColor: colors.tintBlue,
              labelStyle: TextStyle(
                color: colors.onTintBlue,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              side: BorderSide.none,
              shape: const RoundedRectangleBorder(borderRadius: GdgShapes.full),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ],
    );
  }
}
