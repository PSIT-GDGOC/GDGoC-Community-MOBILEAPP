import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/gdg_avatar.dart';
import '../../../../core/widgets/gdg_card.dart';
import '../../domain/models/home_data.dart';

/// Screen 05: 2-Column Activity Grid on Member Home.
class ActivityGrid extends StatelessWidget {
  const ActivityGrid({
    super.key,
    required this.activities,
  });

  final List<ActivityCardItem> activities;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activity',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: GdgSpacing.sp3),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: activities.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: GdgSpacing.sp3,
            crossAxisSpacing: GdgSpacing.sp3,
            mainAxisExtent: 96,
          ),
          itemBuilder: (context, index) {
            final item = activities[index];
            final firstName = item.name.split(' ').first;

            return GdgCard(
              padding: const EdgeInsets.all(GdgSpacing.sp3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GdgAvatar(
                    name: item.name,
                    size: GdgAvatarSize.sm,
                    colorIndex: item.colorIndex,
                  ),
                  const SizedBox(height: GdgSpacing.sp2),
                  Text(
                    '$firstName ${item.action}',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: colors.onSurface,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    item.timeAgo,
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: colors.onSurface3,
                        ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
