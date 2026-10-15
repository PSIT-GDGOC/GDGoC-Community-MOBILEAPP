import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/shapes.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/state_views.dart';
import '../controllers/events_controller.dart';
import '../widgets/swipeable_card_deck.dart';

/// Screen 06: Events Deck with swipeable cards and category filters.
class EventsScreen extends ConsumerWidget {
  const EventsScreen({super.key});

  static const List<String> _filters = [
    'All',
    'Open',
    'Registered',
    'Waitlist',
    'Past',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsState = ref.watch(eventsControllerProvider);
    final controller = ref.read(eventsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: eventsState.isLoading
            ? const LoadingStateView()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: GdgSpacing.sp2),

                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: GdgSpacing.sp4),
                    child: Row(
                      children: [
                        for (final filter in _filters) ...[
                          _buildFilterChip(
                            context,
                            label: filter,
                            isSelected: eventsState.selectedFilter.toLowerCase() ==
                                filter.toLowerCase(),
                            onTap: () => controller.setFilter(filter),
                          ),
                          const SizedBox(width: GdgSpacing.sp2),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: GdgSpacing.sp3),

                  // Swipeable Deck
                  Expanded(
                    child: SwipeableCardDeck(
                      events: eventsState.events,
                      currentIndex: eventsState.currentIndex,
                      onCardChanged: (index) => controller.goToCard(index),
                      onViewDetails: (event) {
                        context.push('/member/events/${event.id}');
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colors = context.gdgColors;

    return InkWell(
      onTap: onTap,
      borderRadius: GdgShapes.full,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: GdgSpacing.sp4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? colors.tintBlue : colors.surface,
          borderRadius: GdgShapes.full,
          border: Border.all(
            color: isSelected ? Colors.transparent : colors.outline,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color: isSelected ? colors.onTintBlue : colors.onSurface2,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
        ),
      ),
    );
  }
}
