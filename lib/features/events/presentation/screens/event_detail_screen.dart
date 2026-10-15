import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/shapes.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/gdg_avatar.dart';
import '../../../../core/widgets/gdg_card.dart';
import '../../../../core/widgets/gdg_chip.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/events_repository.dart';
import '../../domain/models/event_item.dart';
import '../controllers/events_controller.dart';
import '../widgets/ticket_sheet.dart';

/// Screen 07: Event Detail Screen with poster carousel, speakers, learnings,
/// glassmorphic bottom bar, and QR ticket sheet.
class EventDetailScreen extends ConsumerStatefulWidget {
  const EventDetailScreen({
    super.key,
    required this.eventId,
    this.initialEvent,
  });

  final String eventId;
  final EventItem? initialEvent;

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen> {
  Color _resolveBrandColor(GdgColors colors, String name) {
    return switch (name) {
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
    final eventsState = ref.watch(eventsControllerProvider);
    final user = ref.watch(authControllerProvider).user;
    final userName = user?.name ?? 'Aarav Sharma';
    final userRoll = user?.rollNumber ?? '2501640100567';

    // Find the current event
    final event = eventsState.allEvents.firstWhere(
      (e) => e.id == widget.eventId,
      orElse: () => widget.initialEvent ?? FakeEventsRepository.defaultEvents.first,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share',
            onPressed: () {
              // ignore: deprecated_member_use
              Share.share(
                'Join ${event.title} at GDG on Campus PSIT!\nDate: ${event.date} · ${event.time}\nVenue: ${event.venue}',
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Scrollable Content
          ListView(
            padding: const EdgeInsets.fromLTRB(
              GdgSpacing.sp4,
              GdgSpacing.sp2,
              GdgSpacing.sp4,
              100, // Space for bottom glass bar
            ),
            children: [
              // Poster Carousel
              _buildPosterCarousel(context, event),
              const SizedBox(height: GdgSpacing.sp4),

              // Title
              Text(
                event.title,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: GdgSpacing.sp2),

              // Metadata Chips
              Wrap(
                spacing: GdgSpacing.sp2,
                runSpacing: GdgSpacing.sp2,
                children: [
                  GdgChipAssist(
                    label: '${event.date} · ${event.time}',
                    icon: const Icon(Icons.schedule, size: 14),
                  ),
                  GdgChipAssist(
                    label: event.venue,
                    icon: const Icon(Icons.location_on, size: 14),
                  ),
                  GdgChipAssist(
                    label: event.seatsInfo,
                    tone: event.isUserRegistered
                        ? GdgChipTone.green
                        : GdgChipTone.blue,
                    icon: event.isUserRegistered
                        ? const Icon(Icons.check, size: 14)
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: GdgSpacing.sp4),

              // About Section
              if (event.about.isNotEmpty) ...[
                GdgCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: GdgSpacing.sp2),
                      Text(
                        event.about,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: colors.onSurface2,
                              height: 1.5,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: GdgSpacing.sp3),
              ],

              // Speakers Section
              if (event.speakers.isNotEmpty) ...[
                GdgCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Speakers',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: GdgSpacing.sp3),
                      for (int i = 0; i < event.speakers.length; i++) ...[
                        Row(
                          children: [
                            GdgAvatar(
                              name: event.speakers[i].name,
                              colorIndex: event.speakers[i].colorIndex,
                              size: GdgAvatarSize.md,
                            ),
                            const SizedBox(width: GdgSpacing.sp3),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.speakers[i].name,
                                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  Text(
                                    event.speakers[i].role,
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                          color: colors.onSurface2,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (i < event.speakers.length - 1)
                          const Divider(height: GdgSpacing.sp4),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: GdgSpacing.sp3),
              ],

              // Learnings Section
              if (event.learnings.isNotEmpty) ...[
                GdgCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "What you'll learn",
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: GdgSpacing.sp3),
                      for (final item in event.learnings) ...[
                        Padding(
                          padding: const EdgeInsets.only(bottom: GdgSpacing.sp2),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 18,
                                color: colors.brandGreen,
                              ),
                              const SizedBox(width: GdgSpacing.sp2),
                              Expanded(
                                child: Text(
                                  item,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: GdgSpacing.sp4),
              ],
            ],
          ),

          // Glassmorphic Floating Bottom Action Bar
          Positioned(
            left: GdgSpacing.sp4,
            right: GdgSpacing.sp4,
            bottom: GdgSpacing.sp4,
            child: ClipRRect(
              borderRadius: GdgShapes.full,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: colors.surface.withAlpha(200),
                    borderRadius: GdgShapes.full,
                    border: Border.all(color: colors.outline.withAlpha(120), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(25),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Primary Action: View Ticket OR Register OR Join Waitlist
                      Expanded(
                        child: event.isUserRegistered
                            ? FilledButton.icon(
                                onPressed: () {
                                  TicketSheet.show(
                                    context,
                                    event: event,
                                    userName: userName,
                                    userRoll: userRoll,
                                  );
                                },
                                icon: const Icon(Icons.qr_code_2, size: 20),
                                label: const Text('View ticket'),
                              )
                            : event.status == EventRegistrationStatus.waitlist
                                ? FilledButton.icon(
                                    onPressed: () async {
                                      await ref
                                          .read(eventsControllerProvider.notifier)
                                          .joinWaitlist(event.id);
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Joined waitlist!'),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      }
                                    },
                                    icon: const Icon(Icons.hourglass_top, size: 18),
                                    label: const Text('Join waitlist'),
                                  )
                                : FilledButton(
                                    onPressed: () async {
                                      final updated = await ref
                                          .read(eventsControllerProvider.notifier)
                                          .register(
                                            event.id,
                                            rollNumber: userRoll,
                                          );
                                      if (context.mounted && updated != null) {
                                        TicketSheet.show(
                                          context,
                                          event: updated,
                                          userName: userName,
                                          userRoll: userRoll,
                                        );
                                      }
                                    },
                                    child: const Text('Register'),
                                  ),
                      ),
                      const SizedBox(width: GdgSpacing.sp1),

                      // Add to calendar button
                      IconButton(
                        icon: const Icon(Icons.event_available_outlined),
                        tooltip: 'Add to calendar',
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Added "${event.title}" to calendar'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),

                      // Share button
                      IconButton(
                        icon: const Icon(Icons.share_outlined),
                        tooltip: 'Share',
                        onPressed: () {
                          // ignore: deprecated_member_use
                          Share.share(
                            'Check out ${event.title} at GDG on Campus PSIT! ${event.dateAndVenue}',
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPosterCarousel(BuildContext context, EventItem event) {
    final colors = context.gdgColors;

    final spotlightCards = [
      (
        title: 'Kickoff',
        c1: _resolveBrandColor(colors, event.brandColor1),
        c2: _resolveBrandColor(colors, event.brandColor2),
        icon: event.icon,
      ),
      (
        title: 'Speakers',
        c1: colors.brandRed,
        c2: colors.brandYellow,
        icon: Icons.mic_outlined,
      ),
      (
        title: 'Agenda',
        c1: colors.brandGreen,
        c2: colors.brandBlue,
        icon: Icons.event_note_outlined,
      ),
      (
        title: 'Venue',
        c1: colors.brandYellow,
        c2: colors.brandRed,
        icon: Icons.location_on_outlined,
      ),
    ];

    return SizedBox(
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: spotlightCards.length,
        separatorBuilder: (_, _) => const SizedBox(width: GdgSpacing.sp3),
        itemBuilder: (context, index) {
          final card = spotlightCards[index];
          return Container(
            width: 260,
            decoration: BoxDecoration(
              borderRadius: GdgShapes.lg,
              border: Border.all(color: colors.outline, width: 1),
              gradient: RadialGradient(
                center: const Alignment(-0.8, -0.8),
                radius: 1.2,
                colors: [
                  card.c1.withAlpha(55),
                  card.c2.withAlpha(35),
                  colors.surfaceAlt,
                ],
              ),
            ),
            padding: const EdgeInsets.all(GdgSpacing.sp4),
            child: Stack(
              children: [
                Positioned(
                  right: -16,
                  top: -8,
                  child: Opacity(
                    opacity: 0.16,
                    child: Icon(
                      card.icon,
                      size: 110,
                      color: card.c1,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      Icon(card.icon, color: card.c1, size: 22),
                      const SizedBox(width: GdgSpacing.sp2),
                      Text(
                        card.title,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
