import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/shapes.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/gdg_chip.dart';
import '../../domain/models/event_item.dart';

class EventDeckCard extends StatelessWidget {
  const EventDeckCard({
    super.key,
    required this.event,
    required this.onViewDetails,
  });

  final EventItem event;
  final VoidCallback onViewDetails;

  Color _resolveBrandColor(GdgColors colors, String name) {
    return switch (name) {
      'blue' => colors.brandBlue,
      'green' => colors.brandGreen,
      'red' => colors.brandRed,
      'yellow' => colors.brandYellow,
      _ => colors.brandBlue,
    };
  }

  GdgChipTone _resolveTone(EventRegistrationStatus status) {
    return switch (status) {
      EventRegistrationStatus.registered => GdgChipTone.green,
      EventRegistrationStatus.waitlist => GdgChipTone.yellow,
      EventRegistrationStatus.open => GdgChipTone.blue,
      EventRegistrationStatus.attended => GdgChipTone.blue,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;
    final c1 = _resolveBrandColor(colors, event.brandColor1);
    final c2 = _resolveBrandColor(colors, event.brandColor2);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: GdgShapes.lg,
        border: Border.all(color: colors.outline, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Poster (Top)
          Expanded(
            child: Stack(
              children: [
                // Background Gradient
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(-0.8, -0.8),
                        radius: 1.3,
                        colors: [
                          c1.withAlpha(50),
                          c2.withAlpha(35),
                          colors.surfaceAlt,
                        ],
                      ),
                    ),
                  ),
                ),

                // Large decorative watermark icon
                Positioned(
                  right: -24,
                  top: -12,
                  child: Opacity(
                    opacity: 0.18,
                    child: Icon(
                      event.icon,
                      size: 150,
                      color: c1,
                    ),
                  ),
                ),

                // Title and Live indicator at bottom of poster
                Positioned(
                  left: GdgSpacing.sp4,
                  right: GdgSpacing.sp4,
                  bottom: GdgSpacing.sp3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (event.isLive) ...[
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: colors.brandGreen,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'LIVE NOW',
                              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                                    color: colors.brandGreen,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                      ],
                      Text(
                        event.title,
                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Info (Bottom)
          Padding(
            padding: const EdgeInsets.all(GdgSpacing.sp3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Schedule & Venue Chips
                Wrap(
                  spacing: GdgSpacing.sp2,
                  runSpacing: GdgSpacing.sp1,
                  children: [
                    GdgChipAssist(
                      label: '${event.date} · ${event.time}',
                      icon: const Icon(Icons.schedule, size: 14),
                    ),
                    GdgChipAssist(
                      label: event.venue,
                      icon: const Icon(Icons.location_on, size: 14),
                    ),
                  ],
                ),
                const SizedBox(height: GdgSpacing.sp2),

                // Capacity / Seats info
                Text(
                  event.status == EventRegistrationStatus.attended
                      ? 'Past event · you attended'
                      : '${event.seatsInfo} registered',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: colors.onSurface2,
                      ),
                ),
                const SizedBox(height: GdgSpacing.sp2),

                // Status and Details Button
                Row(
                  children: [
                    GdgChipAssist(
                      label: event.status.displayName,
                      tone: _resolveTone(event.status),
                      icon: event.status == EventRegistrationStatus.registered
                          ? const Icon(Icons.check, size: 14)
                          : null,
                    ),
                    const Spacer(),
                    FilledButton(
                      onPressed: onViewDetails,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(100, 36),
                        padding: const EdgeInsets.symmetric(horizontal: GdgSpacing.sp3),
                      ),
                      child: const Text('View details'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
