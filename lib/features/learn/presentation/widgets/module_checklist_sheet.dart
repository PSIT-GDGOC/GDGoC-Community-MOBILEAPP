import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/shapes.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/gdg_chip.dart';
import '../../../../core/widgets/gdg_linear_progress.dart';
import '../../domain/models/learning_path.dart';

class ModuleChecklistSheet extends StatelessWidget {
  const ModuleChecklistSheet({
    super.key,
    required this.path,
    required this.onToggleModule,
  });

  final LearningPath path;
  final void Function(String moduleId) onToggleModule;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: GdgShapes.sheetTop,
          ),
          child: Column(
            children: [
              // Drag Handle
              const SizedBox(height: GdgSpacing.sp3),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.outline,
                  borderRadius: GdgShapes.full,
                ),
              ),
              const SizedBox(height: GdgSpacing.sp4),

              // Header Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: GdgSpacing.sp5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GdgChipAssist(
                          label: path.category,
                          tone: switch (path.trackColor) {
                            LearningTrackColor.blue => GdgChipTone.blue,
                            LearningTrackColor.green => GdgChipTone.green,
                            LearningTrackColor.red => GdgChipTone.red,
                            LearningTrackColor.yellow => GdgChipTone.yellow,
                          },
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          tooltip: 'Close',
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: GdgSpacing.sp2),
                    Text(
                      path.title,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: GdgSpacing.sp1),
                    Text(
                      path.progressMetadata,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.onSurface2,
                      ),
                    ),
                    const SizedBox(height: GdgSpacing.sp3),
                    GdgLinearProgress(
                      progress: path.progressRatio,
                      color: switch (path.trackColor) {
                        LearningTrackColor.blue => colors.brandBlue,
                        LearningTrackColor.green => colors.brandGreen,
                        LearningTrackColor.red => colors.brandRed,
                        LearningTrackColor.yellow => colors.brandYellow,
                      },
                      height: 8,
                    ),
                    const SizedBox(height: GdgSpacing.sp2),
                    Text(
                      '${path.progressPercentage.toInt()}% Completed · Tap a module to toggle completion',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: colors.onSurface3),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: GdgSpacing.sp3),
              const Divider(height: 1),

              // Modules List
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: GdgSpacing.sp5,
                    vertical: GdgSpacing.sp4,
                  ),
                  itemCount: path.modules.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: GdgSpacing.sp3),
                  itemBuilder: (context, index) {
                    final module = path.modules[index];
                    final isCompleted = module.isCompleted;

                    return InkWell(
                      onTap: () => onToggleModule(module.id),
                      borderRadius: GdgShapes.md,
                      child: Container(
                        padding: const EdgeInsets.all(GdgSpacing.sp3),
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? colors.tintGreen.withValues(alpha: 0.4)
                              : colors.surfaceAlt,
                          borderRadius: GdgShapes.md,
                          border: Border.all(
                            color: isCompleted
                                ? colors.brandGreen.withValues(alpha: 0.3)
                                : colors.outline,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: isCompleted,
                              activeColor: colors.brandGreen,
                              shape: const RoundedRectangleBorder(
                                borderRadius: GdgShapes.xs,
                              ),
                              onChanged: (_) => onToggleModule(module.id),
                            ),
                            const SizedBox(width: GdgSpacing.sp2),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Module ${index + 1}: ${module.title}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                decoration: isCompleted
                                                    ? TextDecoration.lineThrough
                                                    : null,
                                                color: isCompleted
                                                    ? colors.onSurface2
                                                    : colors.onSurface,
                                              ),
                                        ),
                                      ),
                                      Text(
                                        '${module.durationMinutes}m',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              color: colors.onSurface3,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: GdgSpacing.sp1),
                                  Text(
                                    module.description,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: colors.onSurface2),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
