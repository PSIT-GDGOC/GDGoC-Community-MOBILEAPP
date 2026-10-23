import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/core_team_repository.dart';
import '../../domain/models/core_dashboard_data.dart';
import '../../../home/domain/models/board_entry.dart';

class CoreDashboardState {
  const CoreDashboardState({
    this.isLoading = false,
    this.kpis = const [],
    this.attentionItems = const [],
    this.teamMembers = const [],
    this.totalTeamCount = 14,
    this.boardEntries = const [],
    this.userRank = 4,
    this.userPoints = 905,
    this.isBoardExpanded = false,
    this.selectedBoardFilter = 'all',
    this.errorMessage,
  });

  final bool isLoading;
  final List<CoreKpiItem> kpis;
  final List<AttentionItem> attentionItems;
  final List<CoreTeamMember> teamMembers;
  final int totalTeamCount;
  final List<BoardEntry> boardEntries;
  final int userRank;
  final int userPoints;
  final bool isBoardExpanded;
  final String selectedBoardFilter;
  final String? errorMessage;

  CoreDashboardState copyWith({
    bool? isLoading,
    List<CoreKpiItem>? kpis,
    List<AttentionItem>? attentionItems,
    List<CoreTeamMember>? teamMembers,
    int? totalTeamCount,
    List<BoardEntry>? boardEntries,
    int? userRank,
    int? userPoints,
    bool? isBoardExpanded,
    String? selectedBoardFilter,
    String? errorMessage,
  }) {
    return CoreDashboardState(
      isLoading: isLoading ?? this.isLoading,
      kpis: kpis ?? this.kpis,
      attentionItems: attentionItems ?? this.attentionItems,
      teamMembers: teamMembers ?? this.teamMembers,
      totalTeamCount: totalTeamCount ?? this.totalTeamCount,
      boardEntries: boardEntries ?? this.boardEntries,
      userRank: userRank ?? this.userRank,
      userPoints: userPoints ?? this.userPoints,
      isBoardExpanded: isBoardExpanded ?? this.isBoardExpanded,
      selectedBoardFilter: selectedBoardFilter ?? this.selectedBoardFilter,
      errorMessage: errorMessage,
    );
  }
}

final coreTeamRepositoryProvider = Provider<CoreTeamRepository>((ref) {
  return FakeCoreTeamRepository();
});

final coreDashboardControllerProvider =
    NotifierProvider<CoreDashboardController, CoreDashboardState>(
  CoreDashboardController.new,
);

class CoreDashboardController extends Notifier<CoreDashboardState> {
  @override
  CoreDashboardState build() {
    return const CoreDashboardState(
      kpis: FakeCoreTeamRepository.defaultKpis,
      attentionItems: FakeCoreTeamRepository.defaultAttentionItems,
      teamMembers: FakeCoreTeamRepository.defaultTeamMembers,
      totalTeamCount: FakeCoreTeamRepository.defaultTotalTeamCount,
      boardEntries: FakeCoreTeamRepository.defaultBoardEntries,
    );
  }

  CoreTeamRepository get _repository => ref.read(coreTeamRepositoryProvider);

  Future<void> loadDashboard() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final results = await Future.wait([
        _repository.getDashboardKpis(),
        _repository.getAttentionItems(),
        _repository.getTeamMembers(),
        _repository.getTotalTeamCount(),
        _repository.getBoardEntries(filter: state.selectedBoardFilter),
      ]);

      state = state.copyWith(
        isLoading: false,
        kpis: results[0] as List<CoreKpiItem>,
        attentionItems: results[1] as List<AttentionItem>,
        teamMembers: results[2] as List<CoreTeamMember>,
        totalTeamCount: results[3] as int,
        boardEntries: results[4] as List<BoardEntry>,
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

  Future<void> setBoardFilter(String filter) async {
    state = state.copyWith(selectedBoardFilter: filter);
    final entries = await _repository.getBoardEntries(filter: filter);
    state = state.copyWith(boardEntries: entries);
  }
}
