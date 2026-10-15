import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/shapes.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/gdg_card.dart';
import '../../domain/models/home_data.dart';

/// Screen 05: Projects shortcuts strip on Member Home.
class ProjectShortcutsStrip extends StatelessWidget {
  const ProjectShortcutsStrip({
    super.key,
    required this.projects,
    this.onProjectTapped,
  });

  final List<ProjectShortcut> projects;
  final ValueChanged<ProjectShortcut>? onProjectTapped;

  Color _resolveBrandColor(GdgColors colors, String colorName) {
    return switch (colorName) {
      'blue' => colors.brandBlue,
      'green' => colors.brandGreen,
      'red' => colors.brandRed,
      'yellow' => colors.brandYellow,
      _ => colors.brandBlue,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Projects',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: GdgSpacing.sp3),
        Row(
          children: [
            for (final prj in projects)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: GdgSpacing.sp2),
                  child: GdgCard(
                    padding: const EdgeInsets.all(GdgSpacing.sp3),
                    onTap: () => onProjectTapped?.call(prj),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            borderRadius: GdgShapes.md,
                            gradient: RadialGradient(
                              center: Alignment.topLeft,
                              radius: 1.2,
                              colors: [
                                _resolveBrandColor(colors, prj.brandColor1).withAlpha(50),
                                _resolveBrandColor(colors, prj.brandColor2).withAlpha(30),
                                colors.surface,
                              ],
                            ),
                            border: Border.all(color: colors.outline, width: 1),
                          ),
                          child: Icon(
                            prj.icon,
                            size: 22,
                            color: _resolveBrandColor(colors, prj.brandColor1),
                          ),
                        ),
                        const SizedBox(height: GdgSpacing.sp2),
                        Text(
                          prj.name,
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
