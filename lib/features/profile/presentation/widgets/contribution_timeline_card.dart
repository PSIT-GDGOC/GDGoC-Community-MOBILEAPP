import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/shapes.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/widgets/gdg_card.dart';
import '../../domain/models/member_profile.dart';

class ContributionTimelineCard extends StatelessWidget {
  const ContributionTimelineCard({
    super.key,
    required this.contribution,
    required this.onAdvanceStage,
    required this.onSelectStage,
  });

  final ContributionEntry contribution;
  final VoidCallback onAdvanceStage;
  final ValueChanged<ContributionStage> onSelectStage;

  static const List<ContributionStage> _stages = [
    ContributionStage.claimedIssue,
    ContributionStage.prOpened,
    ContributionStage.countedOnBoard,
  ];

  Widget _buildStepIndicator(
    BuildContext context, {
    required ContributionStage stage,
    required int index,
  }) {
    final colors = context.gdgColors;
    final currentStageOrder = contribution.currentStage.order;
    final isCompleted = index <= currentStageOrder;
    final isCurrent = index == currentStageOrder;

    final timestamp =
        contribution.timestamps[stage.label] ??
        (isCompleted ? 'Done' : 'Pending');

    return Expanded(
      child: InkWell(
        onTap: () => onSelectStage(stage),
        borderRadius: GdgShapes.sm,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: [
              // Circle Node
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? (isCurrent && stage == ContributionStage.countedOnBoard
                            ? colors.brandGreen
                            : colors.brandBlue)
                      : colors.surfaceAlt,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isCompleted
                        ? (stage == ContributionStage.countedOnBoard
                              ? colors.brandGreen
                              : colors.brandBlue)
                        : colors.outline,
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: isCompleted
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 14,
                      )
                    : Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: colors.onSurface3,
                        ),
                      ),
              ),
              const SizedBox(height: 4),

              // Stage Label
              Text(
                stage.label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isCompleted ? colors.onSurface : colors.onSurface3,
                  fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 10,
                ),
              ),

              // Stage Timestamp
              Text(
                timestamp,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isCompleted ? colors.onSurface2 : colors.onSurface3,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;

    return GdgCard(
      padding: const EdgeInsets.all(GdgSpacing.sp3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Commit icon, Issue Title, Repo Name
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: colors.tintBlue,
                  borderRadius: GdgShapes.sm,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.commit_rounded,
                  color: colors.brandBlue,
                  size: 20,
                ),
              ),
              const SizedBox(width: GdgSpacing.sp3),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (contribution.issueNumber != null) ...[
                          Text(
                            contribution.issueNumber!,
                            style: GdgTypography.mono(
                              context,
                              color: colors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: GdgSpacing.sp1),
                        ],
                        Expanded(
                          child: Text(
                            contribution.issueTitle,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${contribution.repoName} · ${contribution.timestamps[contribution.currentStage.label] ?? "Active"}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: colors.onSurface2),
                    ),
                  ],
                ),
              ),

              // Quick stage cycle button
              IconButton(
                icon: const Icon(Icons.sync_rounded, size: 18),
                tooltip: 'Advance progression stage',
                onPressed: onAdvanceStage,
                color: colors.primary,
              ),
            ],
          ),

          const SizedBox(height: GdgSpacing.sp3),

          // 3-Step Progression Stepper Indicator
          Stack(
            alignment: Alignment.topCenter,
            children: [
              // Connecting line between steps
              Positioned(
                top: 11,
                left: 36,
                right: 36,
                child: Container(height: 2, color: colors.outline),
              ),
              // Active colored line segment
              Positioned(
                top: 11,
                left: 36,
                right: 36,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final factor = contribution.currentStage.order / 2.0;
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 2,
                        width: constraints.maxWidth * factor,
                        color: colors.brandBlue,
                      ),
                    );
                  },
                ),
              ),

              // The 3 Nodes
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < _stages.length; i++)
                    _buildStepIndicator(context, stage: _stages[i], index: i),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
