import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/learn_mock_data.dart';
import '../../data/learn_repository.dart';
import '../../domain/models/learning_path.dart';
import '../../domain/models/learning_resource.dart';
import '../../domain/models/workshop_session.dart';

class LearnState {
  const LearnState({
    this.selectedTab = 0,
    this.paths = const [],
    this.resources = const [],
    this.selectedTopic = 'All',
    this.sessions = const [],
    this.activePreviewSession,
    this.isLoading = false,
    this.errorMessage,
  });

  final int selectedTab; // 0: Paths, 1: Resources, 2: Sessions
  final List<LearningPath> paths;
  final List<ResourceItem> resources;
  final String selectedTopic;
  final List<WorkshopSession> sessions;
  final WorkshopSession? activePreviewSession;
  final bool isLoading;
  final String? errorMessage;

  List<ResourceItem> get filteredResources {
    if (selectedTopic == 'All') return resources;
    return resources
        .where((r) => r.topic.toLowerCase() == selectedTopic.toLowerCase())
        .toList();
  }

  LearnState copyWith({
    int? selectedTab,
    List<LearningPath>? paths,
    List<ResourceItem>? resources,
    String? selectedTopic,
    List<WorkshopSession>? sessions,
    WorkshopSession? Function()? activePreviewSession,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LearnState(
      selectedTab: selectedTab ?? this.selectedTab,
      paths: paths ?? this.paths,
      resources: resources ?? this.resources,
      selectedTopic: selectedTopic ?? this.selectedTopic,
      sessions: sessions ?? this.sessions,
      activePreviewSession: activePreviewSession != null
          ? activePreviewSession()
          : this.activePreviewSession,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class LearnController extends Notifier<LearnState> {
  @override
  LearnState build() {
    return LearnState(
      paths: LearnMockData.getInitialPaths(),
      resources: LearnMockData.getInitialResources(),
      sessions: LearnMockData.getInitialSessions(),
      isLoading: false,
    );
  }

  Future<void> reloadData() async {
    final repo = ref.read(learnRepositoryProvider);
    try {
      final paths = await repo.getLearningPaths();
      final resources = await repo.getResources();
      final sessions = await repo.getSessions();
      state = state.copyWith(
        paths: paths,
        resources: resources,
        sessions: sessions,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load learning data: $e',
      );
    }
  }

  void setTab(int tabIndex) {
    if (state.selectedTab == tabIndex) return;
    state = state.copyWith(selectedTab: tabIndex);
  }

  void setSelectedTopic(String topic) {
    state = state.copyWith(selectedTopic: topic);
  }

  /// Toggles completion of a specific module within a learning path.
  /// Dynamically recalculates path completion statistics and progress bar fill.
  void toggleModule(String pathId, String moduleId) {
    final updatedPaths = state.paths.map((path) {
      if (path.id != pathId) return path;

      final updatedModules = path.modules.map((mod) {
        if (mod.id != moduleId) return mod;
        return mod.copyWith(isCompleted: !mod.isCompleted);
      }).toList();

      return path.copyWith(modules: updatedModules);
    }).toList();

    state = state.copyWith(paths: updatedPaths);
  }

  void openSessionPreview(WorkshopSession session) {
    state = state.copyWith(activePreviewSession: () => session);
  }

  void closeSessionPreview() {
    state = state.copyWith(activePreviewSession: () => null);
  }
}

final learnControllerProvider = NotifierProvider<LearnController, LearnState>(
  LearnController.new,
);
