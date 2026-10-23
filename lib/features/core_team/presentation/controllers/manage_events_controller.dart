import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/core_team_repository.dart';
import '../../domain/models/manage_event_item.dart';
import 'core_dashboard_controller.dart';

enum ManageEventsTab {
  upcoming,
  past;

  String get displayName => switch (this) {
        ManageEventsTab.upcoming => 'Upcoming',
        ManageEventsTab.past => 'Past',
      };
}

class ManageEventsState {
  const ManageEventsState({
    this.isLoading = false,
    this.selectedTab = ManageEventsTab.upcoming,
    this.upcomingEvents = const [],
    this.pastEvents = const [],
    this.isLiveNowPreviewActive = false,
    this.errorMessage,
  });

  final bool isLoading;
  final ManageEventsTab selectedTab;
  final List<ManageEventItem> upcomingEvents;
  final List<ManageEventItem> pastEvents;
  final bool isLiveNowPreviewActive;
  final String? errorMessage;

  List<ManageEventItem> get currentEvents =>
      selectedTab == ManageEventsTab.upcoming ? upcomingEvents : pastEvents;

  ManageEventsState copyWith({
    bool? isLoading,
    ManageEventsTab? selectedTab,
    List<ManageEventItem>? upcomingEvents,
    List<ManageEventItem>? pastEvents,
    bool? isLiveNowPreviewActive,
    String? errorMessage,
  }) {
    return ManageEventsState(
      isLoading: isLoading ?? this.isLoading,
      selectedTab: selectedTab ?? this.selectedTab,
      upcomingEvents: upcomingEvents ?? this.upcomingEvents,
      pastEvents: pastEvents ?? this.pastEvents,
      isLiveNowPreviewActive:
          isLiveNowPreviewActive ?? this.isLiveNowPreviewActive,
      errorMessage: errorMessage,
    );
  }
}

final manageEventsControllerProvider =
    NotifierProvider<ManageEventsController, ManageEventsState>(
  ManageEventsController.new,
);

class ManageEventsController extends Notifier<ManageEventsState> {
  @override
  ManageEventsState build() {
    final defaultUpcoming = FakeCoreTeamRepository.defaultEvents
        .where((e) => !e.isPast)
        .toList();
    final defaultPast = FakeCoreTeamRepository.defaultEvents
        .where((e) => e.isPast)
        .toList();

    return ManageEventsState(
      upcomingEvents: defaultUpcoming,
      pastEvents: defaultPast,
    );
  }

  CoreTeamRepository get _repository => ref.read(coreTeamRepositoryProvider);

  Future<void> loadEvents() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final upcoming = await _repository.getManageEvents(isPast: false);
      final past = await _repository.getManageEvents(isPast: true);

      state = state.copyWith(
        isLoading: false,
        upcomingEvents: upcoming,
        pastEvents: past,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void setTab(ManageEventsTab tab) {
    state = state.copyWith(selectedTab: tab);
  }

  void toggleLiveNowPreview() {
    state = state.copyWith(
      isLiveNowPreviewActive: !state.isLiveNowPreviewActive,
    );
  }

  Future<void> addEvent(ManageEventItem event) async {
    final created = await _repository.createEvent(event);
    if (created.isPast) {
      state = state.copyWith(
        pastEvents: [created, ...state.pastEvents],
      );
    } else {
      state = state.copyWith(
        upcomingEvents: [created, ...state.upcomingEvents],
      );
    }
  }

  Future<void> updateEvent(ManageEventItem event) async {
    final updated = await _repository.updateEvent(event);
    if (updated.isPast) {
      final newPast = state.pastEvents.map((e) => e.id == updated.id ? updated : e).toList();
      state = state.copyWith(pastEvents: newPast);
    } else {
      final newUpcoming = state.upcomingEvents.map((e) => e.id == updated.id ? updated : e).toList();
      state = state.copyWith(upcomingEvents: newUpcoming);
    }
  }

  Future<void> toggleLiveStatus(String eventId) async {
    final updated = await _repository.toggleLiveNow(eventId);
    final newUpcoming = state.upcomingEvents.map((e) => e.id == updated.id ? updated : e).toList();
    state = state.copyWith(upcomingEvents: newUpcoming);
  }

  Future<void> deleteEvent(String id) async {
    await _repository.deleteEvent(id);
    state = state.copyWith(
      upcomingEvents: state.upcomingEvents.where((e) => e.id != id).toList(),
      pastEvents: state.pastEvents.where((e) => e.id != id).toList(),
    );
  }
}
