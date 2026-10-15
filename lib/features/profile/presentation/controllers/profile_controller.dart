import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/profile_mock_data.dart';
import '../../data/profile_repository.dart';
import '../../domain/models/member_profile.dart';

class ProfileState {
  const ProfileState({
    this.profile,
    this.isMentorView = false,
    this.isLoading = false,
    this.errorMessage,
  });

  final MemberProfile? profile;
  final bool isMentorView;
  final bool isLoading;
  final String? errorMessage;

  ProfileState copyWith({
    MemberProfile? profile,
    bool? isMentorView,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isMentorView: isMentorView ?? this.isMentorView,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ProfileController extends Notifier<ProfileState> {
  @override
  ProfileState build() {
    return ProfileState(
      profile: ProfileMockData.getInitialProfile(),
      isLoading: false,
    );
  }

  Future<void> reloadProfile() async {
    final repo = ref.read(profileRepositoryProvider);
    try {
      final profile = await repo.getProfile();
      state = state.copyWith(profile: profile, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load member profile: $e',
      );
    }
  }

  void toggleMentorView() {
    state = state.copyWith(isMentorView: !state.isMentorView);
  }

  void togglePrivacy(bool value) {
    if (state.profile == null) return;
    final updated = state.profile!.copyWith(privacyEnabled: value);
    state = state.copyWith(profile: updated);
    ref.read(profileRepositoryProvider).updatePrivacy(value);
  }

  void toggleNotifications(bool value) {
    if (state.profile == null) return;
    final updated = state.profile!.copyWith(notificationsEnabled: value);
    state = state.copyWith(profile: updated);
    ref.read(profileRepositoryProvider).updateNotifications(value);
  }

  /// Interactively transitions contribution through stages:
  /// Claimed issue -> PR opened -> Counted on Board
  void advanceContributionStage(String contributionId) {
    if (state.profile == null) return;

    final updatedContributions = state.profile!.contributions.map((c) {
      if (c.id != contributionId) return c;

      final nextStage = switch (c.currentStage) {
        ContributionStage.claimedIssue => ContributionStage.prOpened,
        ContributionStage.prOpened => ContributionStage.countedOnBoard,
        ContributionStage.countedOnBoard => ContributionStage.claimedIssue,
      };

      final updatedTimestamps = Map<String, String>.from(c.timestamps);
      if (nextStage == ContributionStage.prOpened &&
          !updatedTimestamps.containsKey('PR opened')) {
        updatedTimestamps['PR opened'] = 'Just now';
      } else if (nextStage == ContributionStage.countedOnBoard &&
          !updatedTimestamps.containsKey('Counted on Board')) {
        updatedTimestamps['Counted on Board'] = 'Just now';
      }

      return c.copyWith(currentStage: nextStage, timestamps: updatedTimestamps);
    }).toList();

    // Dynamically recalculate stats
    final mergedCount = updatedContributions
        .where((c) => c.currentStage == ContributionStage.countedOnBoard)
        .length;
    final openCount = updatedContributions
        .where((c) => c.currentStage == ContributionStage.prOpened)
        .length;

    final updated = state.profile!.copyWith(
      contributions: updatedContributions,
      mergedPRs: mergedCount,
      openPRs: openCount,
    );

    state = state.copyWith(profile: updated);
  }

  void setContributionStage(String contributionId, ContributionStage stage) {
    if (state.profile == null) return;

    final updatedContributions = state.profile!.contributions.map((c) {
      if (c.id != contributionId) return c;
      return c.copyWith(currentStage: stage);
    }).toList();

    final mergedCount = updatedContributions
        .where((c) => c.currentStage == ContributionStage.countedOnBoard)
        .length;
    final openCount = updatedContributions
        .where((c) => c.currentStage == ContributionStage.prOpened)
        .length;

    final updated = state.profile!.copyWith(
      contributions: updatedContributions,
      mergedPRs: mergedCount,
      openPRs: openCount,
    );

    state = state.copyWith(profile: updated);
  }

  void updateIdentity({
    required String fullName,
    required String githubHandle,
  }) {
    if (state.profile == null) return;
    final updated = state.profile!.copyWith(
      fullName: fullName,
      githubHandle: githubHandle.startsWith('@')
          ? githubHandle
          : '@$githubHandle',
    );
    state = state.copyWith(profile: updated);
  }

  void addSkill(String skill) {
    if (state.profile == null || skill.trim().isEmpty) return;
    final trimmed = skill.trim();
    if (state.profile!.skillChips.contains(trimmed)) return;
    final updatedSkills = [...state.profile!.skillChips, trimmed];
    state = state.copyWith(
      profile: state.profile!.copyWith(skillChips: updatedSkills),
    );
  }

  void removeSkill(String skill) {
    if (state.profile == null) return;
    final updatedSkills = state.profile!.skillChips
        .where((s) => s != skill)
        .toList();
    state = state.copyWith(
      profile: state.profile!.copyWith(skillChips: updatedSkills),
    );
  }
}

final profileControllerProvider =
    NotifierProvider<ProfileController, ProfileState>(ProfileController.new);
