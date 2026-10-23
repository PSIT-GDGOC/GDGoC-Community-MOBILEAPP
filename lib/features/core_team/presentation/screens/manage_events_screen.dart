import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/shapes.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/state_views.dart';
import '../controllers/manage_events_controller.dart';
import '../../domain/models/manage_event_item.dart';
import '../widgets/create_edit_event_sheet.dart';
import '../widgets/manage_event_card.dart';

/// Screen 13: Manage Events screen for Core Team.
class ManageEventsScreen extends ConsumerWidget {
  const ManageEventsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(manageEventsControllerProvider);
    final controller = ref.read(manageEventsControllerProvider.notifier);
    final colors = context.gdgColors;

    final events = state.currentEvents;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(
              state.isLiveNowPreviewActive
                  ? Icons.sensors
                  : Icons.sensors_off_outlined,
              color: state.isLiveNowPreviewActive
                  ? colors.brandRed
                  : colors.onSurface3,
            ),
            tooltip: state.isLiveNowPreviewActive
                ? 'Live preview active'
                : 'Toggle live preview',
            onPressed: () => controller.toggleLiveNowPreview(),
          ),
          const SizedBox(width: GdgSpacing.sp2),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: GdgSpacing.sp2),

            // Upcoming / Past Toggle Button Group (M3 button group)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: GdgSpacing.sp4),
              child: _buildTabButtonGroup(context, state, controller, colors),
            ),
            const SizedBox(height: GdgSpacing.sp3),

            // Events List
            Expanded(
              child: state.isLoading
                  ? const LoadingStateView()
                  : state.errorMessage != null
                      ? ErrorStateView(
                          title: "Couldn't load events",
                          message: state.errorMessage!,
                          onRetry: () => controller.loadEvents(),
                        )
                      : events.isEmpty
                          ? EmptyStateView(
                              title: state.selectedTab == ManageEventsTab.upcoming
                                  ? 'No upcoming events'
                                  : 'No past events',
                              message: state.selectedTab == ManageEventsTab.upcoming
                                  ? 'Create a new workshop or study jam using the button below.'
                                  : 'Past event archives will appear here once events conclude.',
                              actionLabel: state.selectedTab == ManageEventsTab.upcoming
                                  ? 'Create Event'
                                  : null,
                              onAction: state.selectedTab == ManageEventsTab.upcoming
                                  ? () => _openCreateEventSheet(context, controller)
                                  : null,
                            )
                          : RefreshIndicator(
                              onRefresh: () => controller.loadEvents(),
                              child: ListView.separated(
                                padding: const EdgeInsets.only(
                                  left: GdgSpacing.sp4,
                                  right: GdgSpacing.sp4,
                                  top: GdgSpacing.sp2,
                                  bottom: 96, // FAB clearance
                                ),
                                itemCount: events.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: GdgSpacing.sp3),
                                itemBuilder: (context, index) {
                                  final event = events[index];
                                  final effectiveEvent = state.isLiveNowPreviewActive && index == 0
                                      ? event.copyWith(isLiveNow: true)
                                      : event;

                                  return ManageEventCard(
                                    event: effectiveEvent,
                                    onEdit: () => _openEditEventSheet(
                                      context,
                                      controller,
                                      event,
                                    ),
                                    onScanTickets: () {
                                      // Connects seamlessly to Screen 23 (Attendance scanning)
                                      context.push(
                                        '/core/events/${event.id}/scan',
                                        extra: event,
                                      );
                                    },
                                    onToggleLive: () =>
                                        controller.toggleLiveStatus(event.id),
                                  );
                                },
                              ),
                            ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFab(context, controller, colors),
    );
  }

  Widget _buildTabButtonGroup(
    BuildContext context,
    ManageEventsState state,
    ManageEventsController controller,
    GdgColors colors,
  ) {
    return Row(
      children: [
        Expanded(
          child: _TabButton(
            label: 'Upcoming',
            isSelected: state.selectedTab == ManageEventsTab.upcoming,
            isFirst: true,
            onTap: () => controller.setTab(ManageEventsTab.upcoming),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: _TabButton(
            label: 'Past',
            isSelected: state.selectedTab == ManageEventsTab.past,
            isLast: true,
            onTap: () => controller.setTab(ManageEventsTab.past),
          ),
        ),
      ],
    );
  }

  Widget _buildFab(
    BuildContext context,
    ManageEventsController controller,
    GdgColors colors,
  ) {
    return FloatingActionButton.extended(
      elevation: 3,
      highlightElevation: 1,
      backgroundColor: colors.tintBlue,
      foregroundColor: colors.onTintBlue,
      shape: const RoundedRectangleBorder(borderRadius: GdgShapes.lg),
      icon: const Icon(Icons.add_rounded),
      label: Text(
        'New event',
        style: TextStyle(
          color: colors.onTintBlue,
          fontWeight: FontWeight.w600,
        ),
      ),
      onPressed: () => _openCreateEventSheet(context, controller),
    );
  }

  void _openCreateEventSheet(
    BuildContext context,
    ManageEventsController controller,
  ) {
    CreateEditEventSheet.show(
      context,
      onSave: (newEvent) {
        controller.addEvent(newEvent);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Created "${newEvent.title}"'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }

  void _openEditEventSheet(
    BuildContext context,
    ManageEventsController controller,
    ManageEventItem event,
  ) {
    CreateEditEventSheet.show(
      context,
      initialEvent: event,
      onSave: (updatedEvent) {
        controller.updateEvent(updatedEvent);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Updated "${updatedEvent.title}"'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;

    final borderRadius = BorderRadius.only(
      topLeft: isFirst ? const Radius.circular(GdgShapes.radiusFull) : const Radius.circular(12),
      bottomLeft: isFirst ? const Radius.circular(GdgShapes.radiusFull) : const Radius.circular(12),
      topRight: isLast ? const Radius.circular(GdgShapes.radiusFull) : const Radius.circular(12),
      bottomRight: isLast ? const Radius.circular(GdgShapes.radiusFull) : const Radius.circular(12),
    );

    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? colors.tintBlue : colors.surfaceAlt,
          borderRadius: borderRadius,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                color: isSelected ? colors.onTintBlue : colors.onSurface2,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
        ),
      ),
    );
  }
}
