import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/home_repository.dart';
import '../../domain/models/board_entry.dart';
import '../../domain/models/home_data.dart';

class HomeState {
  const HomeState({
    this.isLoading = false,
    this.isBoardExpanded = false,
    this.selectedFilter = 'all',
    this.boardEntries = const [],
    this.events = const [],
    this.projects = const [],
    this.activities = const [],
    this.userRank = 14,
    this.userPoints = 410,
    this.errorMessage,
  });

  final bool isLoading;
  final bool isBoardExpanded;
  final String selectedFilter;
  final List<BoardEntry> boardEntries;
  final List<HomeEventSummary> events;
  final List<ProjectShortcut> projects;
  final List<ActivityCardItem> activities;
  final int userRank;
  final int userPoints;
  final String? errorMessage;

  HomeState copyWith({
    bool? isLoading,
    bool? isBoardExpanded,
    String? selectedFilter,
    List<BoardEntry>? boardEntries,
    List<HomeEventSummary>? events,
    List<ProjectShortcut>? projects,
    List<ActivityCardItem>? activities,
    int? userRank,
    int? userPoints,
    String? errorMessage,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      isBoardExpanded: isBoardExpanded ?? this.isBoardExpanded,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      boardEntries: boardEntries ?? this.boardEntries,
      events: events ?? this.events,
      projects: projects ?? this.projects,
      activities: activities ?? this.activities,
      userRank: userRank ?? this.userRank,
      userPoints: userPoints ?? this.userPoints,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return const FakeHomeRepository();
});

final homeControllerProvider =
    NotifierProvider<HomeController, HomeState>(HomeController.new);

class HomeController extends Notifier<HomeState> {
  @override
  HomeState build() {
    return const HomeState(
      boardEntries: FakeHomeRepository.defaultBoardEntries,
      events: FakeHomeRepository.defaultEvents,
      projects: FakeHomeRepository.defaultProjects,
      activities: FakeHomeRepository.defaultActivities,
    );
  }

  HomeRepository get _repository => ref.read(homeRepositoryProvider);

  Future<void> loadHomeData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final results = await Future.wait([
        _repository.getBoardEntries(filter: state.selectedFilter),
        _repository.getUpcomingEvents(),
        _repository.getProjectShortcuts(),
        _repository.getRecentActivities(),
      ]);

      state = state.copyWith(
        isLoading: false,
        boardEntries: results[0] as List<BoardEntry>,
        events: results[1] as List<HomeEventSummary>,
        projects: results[2] as List<ProjectShortcut>,
        activities: results[3] as List<ActivityCardItem>,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void toggleBoardExpansion() {
    state = state.copyWith(isBoardExpanded: !state.isBoardExpanded);
  }

  void setFilter(String filter) {
    if (state.selectedFilter == filter) {
      state = state.copyWith(selectedFilter: 'all');
    } else {
      state = state.copyWith(selectedFilter: filter);
    }
    loadHomeData();
  }
}
