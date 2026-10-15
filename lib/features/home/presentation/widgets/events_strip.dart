import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/shapes.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/gdg_chip.dart';
import '../../domain/models/home_data.dart';

/// Screen 05: Horizontal Events strip with featured kickoff card and peeking event posters.
class EventsStrip extends StatelessWidget {
  const EventsStrip({
    super.key,
    required this.events,
    this.onSeeAllPressed,
    this.onViewTicketPressed,
    this.onEventTapped,
  });

  final List<HomeEventSummary> events;
  final VoidCallback? onSeeAllPressed;
  final VoidCallback? onViewTicketPressed;
  final ValueChanged<HomeEventSummary>? onEventTapped;

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
    if (events.isEmpty) return const SizedBox.shrink();

    final primaryEvent = events.first;
    final secondaryEvents = events.skip(1).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Events',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (onSeeAllPressed != null)
              TextButton(
                onPressed: onSeeAllPressed,
                child: const Text('See all'),
              ),
          ],
        ),
        const SizedBox(height: GdgSpacing.sp3),

        // Horizontal Carousel
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Large Featured Event Card (260dp)
              _buildPrimaryCard(context, primaryEvent),
              const SizedBox(width: GdgSpacing.sp3),

              // Secondary Event Cards (132dp)
              for (final evt in secondaryEvents) ...[
                _buildSecondaryCard(context, evt),
                const SizedBox(width: GdgSpacing.sp3),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryCard(BuildContext context, HomeEventSummary event) {
    final colors = context.gdgColors;
    final c1 = _resolveBrandColor(colors, event.brandColor1);
    final c2 = _resolveBrandColor(colors, event.brandColor2);

    return InkWell(
      onTap: () => onEventTapped?.call(event),
      borderRadius: GdgShapes.lg,
      child: SizedBox(
        width: 260,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster
            Container(
              height: 150,
              padding: const EdgeInsets.all(GdgSpacing.sp3),
              decoration: BoxDecoration(
                borderRadius: GdgShapes.lg,
                gradient: RadialGradient(
                  center: const Alignment(-0.8, -0.8),
                  radius: 1.2,
                  colors: [
                    c1.withAlpha(50),
                    c2.withAlpha(30),
                    colors.surfaceAlt,
                  ],
                ),
              ),
              alignment: Alignment.bottomLeft,
              child: Row(
                children: [
                  if (event.isLive) ...[
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: colors.brandGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
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
            ),
            const SizedBox(height: GdgSpacing.sp2),

            // Card Bottom Actions
            Row(
              children: [
                if (event.isRegistered)
                  const GdgChipAssist(
                    label: 'Registered',
                    tone: GdgChipTone.green,
                    icon: Icon(Icons.check, size: 14),
                  )
                else
                  GdgChipAssist(
                    label: event.status,
                    tone: GdgChipTone.blue,
                  ),
                const Spacer(),
                if (event.isRegistered)
                  IconButton(
                    icon: const Icon(Icons.qr_code_2),
                    tooltip: 'View ticket',
                    color: colors.primary,
                    onPressed: onViewTicketPressed,
                  ),
              ],
            ),
            Text(
              event.dateAndVenue,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: colors.onSurface2,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryCard(BuildContext context, HomeEventSummary event) {
    final colors = context.gdgColors;
    final c1 = _resolveBrandColor(colors, event.brandColor1);
    final c2 = _resolveBrandColor(colors, event.brandColor2);

    return InkWell(
      onTap: () => onEventTapped?.call(event),
      borderRadius: GdgShapes.lg,
      child: SizedBox(
        width: 132,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 96,
              decoration: BoxDecoration(
                borderRadius: GdgShapes.lg,
                gradient: RadialGradient(
                  center: const Alignment(-0.8, -0.8),
                  radius: 1.2,
                  colors: [
                    c1.withAlpha(50),
                    c2.withAlpha(30),
                    colors.surfaceAlt,
                  ],
                ),
              ),
              child: Center(
                child: Icon(
                  event.icon,
                  size: 36,
                  color: c1,
                ),
              ),
            ),
            const SizedBox(height: GdgSpacing.sp2),
            Text(
              event.title,
              style: Theme.of(context).textTheme.titleSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              event.dateAndVenue.split(' · ').first,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: colors.onSurface2,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
