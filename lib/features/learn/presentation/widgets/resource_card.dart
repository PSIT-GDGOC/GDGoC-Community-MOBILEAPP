import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/gdg_card.dart';
import '../../../../core/widgets/gdg_chip.dart';
import '../../domain/models/learning_resource.dart';

class ResourceCard extends StatelessWidget {
  const ResourceCard({super.key, required this.resource, required this.onTap});

  final ResourceItem resource;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;

    final (GdgChipTone typeTone, IconData typeIcon) = switch (resource.type) {
      ResourceType.doc => (GdgChipTone.blue, Icons.article_outlined),
      ResourceType.repo => (GdgChipTone.green, Icons.code_rounded),
      ResourceType.guide => (GdgChipTone.yellow, Icons.menu_book_rounded),
    };

    return GdgCard(
      padding: const EdgeInsets.all(GdgSpacing.sp4),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GdgChipAssist(
                label: resource.type.label,
                tone: typeTone,
                icon: Icon(typeIcon, size: 14),
              ),
              const SizedBox(width: GdgSpacing.sp2),
              GdgChipAssist(label: resource.topic, tone: GdgChipTone.neutral),
              const Spacer(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.schedule_rounded,
                    size: 14,
                    color: colors.onSurface3,
                  ),
                  const SizedBox(width: GdgSpacing.sp1),
                  Text(
                    resource.estimatedReadTime,
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: colors.onSurface3),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: GdgSpacing.sp3),
          Text(
            resource.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: GdgSpacing.sp1),
          Text(
            resource.description,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: colors.onSurface2),
          ),
          const SizedBox(height: GdgSpacing.sp3),
          Row(
            children: [
              Text(
                'By ${resource.author}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colors.onSurface3,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const Spacer(),
              Text(
                'Open Resource',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: GdgSpacing.sp1),
              Icon(Icons.open_in_new_rounded, size: 14, color: colors.primary),
            ],
          ),
        ],
      ),
    );
  }
}
