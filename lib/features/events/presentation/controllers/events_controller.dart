import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/events_repository.dart';
import '../../domain/models/event_item.dart';

class EventsState {
  const EventsState({
    this.events = const [],
    this.allEvents = const [],
    this.selectedFilter = 'all',
    this.currentIndex = 0,
    this.isLoading = false,
    this.errorMessage,
  });

  final List<EventItem> events;
  final List<EventItem> allEvents;
  final String selectedFilter;
  final int currentIndex;
  final bool isLoading;
  final String? errorMessage;

  EventsState copyWith({
    List<EventItem>? events,
    List<EventItem>? allEvents,
    String? selectedFilter,
    int? currentIndex,
    bool? isLoading,
    String? errorMessage,
  }) {
    return EventsState(
      events: events ?? this.events,
      allEvents: allEvents ?? this.allEvents,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      currentIndex: currentIndex ?? this.currentIndex,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

final eventsRepositoryProvider = Provider<EventsRepository>((ref) {
  return FakeEventsRepository();
});

final eventsControllerProvider =
    NotifierProvider<EventsController, EventsState>(EventsController.new);

class EventsController extends Notifier<EventsState> {
  @override
  EventsState build() {
    return const EventsState(
      events: FakeEventsRepository.defaultEvents,
      allEvents: FakeEventsRepository.defaultEvents,
    );
  }

  EventsRepository get _repository => ref.read(eventsRepositoryProvider);

  Future<void> loadEvents() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final all = await _repository.getEvents(filter: 'all');
      final filtered = await _repository.getEvents(filter: state.selectedFilter);

      state = state.copyWith(
        isLoading: false,
        allEvents: all,
        events: filtered,
        currentIndex: state.currentIndex.clamp(0, filtered.isEmpty ? 0 : filtered.length - 1),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> setFilter(String filter) async {
    final lower = filter.toLowerCase();
    state = state.copyWith(selectedFilter: lower);
    final filtered = await _repository.getEvents(filter: lower);

    state = state.copyWith(
      events: filtered,
      currentIndex: 0,
    );
  }

  void nextCard() {
    if (state.currentIndex < state.events.length - 1) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
    }
  }

  void previousCard() {
    if (state.currentIndex > 0) {
      state = state.copyWith(currentIndex: state.currentIndex - 1);
    }
  }

  void goToCard(int index) {
    if (index >= 0 && index < state.events.length) {
      state = state.copyWith(currentIndex: index);
    }
  }

  Future<EventItem?> register(String eventId, {required String rollNumber}) async {
    try {
      final updated = await _repository.registerForEvent(eventId, rollNumber: rollNumber);
      await loadEvents();
      return updated;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return null;
    }
  }

  Future<EventItem?> joinWaitlist(String eventId) async {
    try {
      final updated = await _repository.joinWaitlist(eventId);
      await loadEvents();
      return updated;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return null;
    }
  }
}
