import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/gdg_card.dart';
import '../../../../core/widgets/gdg_chip.dart';
import '../../../../core/widgets/gdg_linear_progress.dart';
import '../../domain/models/manage_event_item.dart';

/// Event management card widget for Screen 13.
class ManageEventCard extends StatelessWidget {
  const ManageEventCard({
    super.key,
    required this.event,
    required this.onEdit,
    this.onScanTickets,
    this.onToggleLive,
    this.onTap,
  });

  final ManageEventItem event;
  final VoidCallback onEdit;
  final VoidCallback? onScanTickets;
  final VoidCallback? onToggleLive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;

    final progressColor = event.statusTone == GdgChipTone.yellow || event.isFull
        ? colors.brandYellow
        : colors.brandBlue;

    return GdgCard(
      onTap: onTap,
      padding: const EdgeInsets.all(GdgSpacing.sp4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Title, Live indicator & Action buttons
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (event.isLiveNow) ...[
                          const _LiveDot(),
                          const SizedBox(width: GdgSpacing.sp2),
                        ],
                        Expanded(
                          child: Text(
                            event.title,
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      event.dateAndVenue,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: colors.onSurface2,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: GdgSpacing.sp2),

              // Live now badge if live
              if (event.isLiveNow) ...[
                GdgChipAssist(
                  label: 'Live now',
                  tone: GdgChipTone.red,
                  icon: const Icon(Icons.fiber_manual_record, size: 12),
                  onTap: onToggleLive,
                ),
                const SizedBox(width: GdgSpacing.sp1),
              ],

              // Scan Tickets Button (Screen 23 shortcut)
              if (onScanTickets != null && !event.isPast)
                IconButton(
                  icon: const Icon(Icons.qr_code_scanner_rounded),
                  tooltip: 'Scan tickets',
                  color: colors.primary,
                  onPressed: onScanTickets,
                  visualDensity: VisualDensity.compact,
                ),

              // Edit Event Button
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit event',
                color: colors.onSurface2,
                onPressed: onEdit,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: GdgSpacing.sp3),

          // Linear Progress Bar
          GdgLinearProgress(
            progress: event.progress,
            color: progressColor,
            height: 6.0,
          ),
          const SizedBox(height: GdgSpacing.sp2),

          // Registration stats (monospace text)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                event.registrationRatioText,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontFamily: 'monospace',
                      color: colors.onSurface2,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              if (event.isPast)
                Text(
                  'Event concluded',
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: colors.onSurface3,
                      ),
                )
              else if (event.isFull)
                Text(
                  'Waitlist active',
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: colors.onTintAmber,
                        fontWeight: FontWeight.w600,
                      ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Pulsing green/red live dot matching mockup
class _LiveDot extends StatefulWidget {
  const _LiveDot();

  @override
  State<_LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<_LiveDot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.brandGreen,
            boxShadow: [
              BoxShadow(
                color: colors.brandGreen.withValues(alpha: 0.3 + 0.3 * _controller.value),
                blurRadius: 4 + 4 * _controller.value,
                spreadRadius: 1 + 2 * _controller.value,
              ),
            ],
          ),
        );
      },
    );
  }
}
