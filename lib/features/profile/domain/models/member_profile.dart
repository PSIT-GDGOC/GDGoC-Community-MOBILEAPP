/// The three distinct stages of an open source contribution in GDGoC.
enum ContributionStage {
  claimedIssue('Claimed issue', 0),
  prOpened('PR opened', 1),
  countedOnBoard('Counted on Board', 2);

  const ContributionStage(this.label, this.order);
  final String label;
  final int order;

  static ContributionStage fromLabel(String label) {
    for (final stage in ContributionStage.values) {
      if (stage.label.toLowerCase() == label.toLowerCase()) {
        return stage;
      }
    }
    return ContributionStage.claimedIssue;
  }
}

/// Represents an individual contribution item with a 3-step progression timeline.
class ContributionEntry {
  const ContributionEntry({
    required this.id,
    required this.issueTitle,
    required this.repoName,
    required this.currentStage,
    required this.timestamps,
    required this.isoDate,
    this.issueNumber,
  });

  final String id;
  final String issueTitle;
  final String repoName;
  final ContributionStage currentStage;
  final Map<String, String> timestamps;
  final String isoDate;
  final String? issueNumber;

  DateTime get parsedDate => DateTime.tryParse(isoDate) ?? DateTime(2026);

  ContributionEntry copyWith({
    String? id,
    String? issueTitle,
    String? repoName,
    ContributionStage? currentStage,
    Map<String, String>? timestamps,
    String? isoDate,
    String? issueNumber,
  }) {
    return ContributionEntry(
      id: id ?? this.id,
      issueTitle: issueTitle ?? this.issueTitle,
      repoName: repoName ?? this.repoName,
      currentStage: currentStage ?? this.currentStage,
      timestamps: timestamps ?? this.timestamps,
      isoDate: isoDate ?? this.isoDate,
      issueNumber: issueNumber ?? this.issueNumber,
    );
  }
}

/// Recognition badge awarded to chapter members.
class ProfileBadge {
  const ProfileBadge({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    this.isUnlocked = true,
    this.unlockedAt,
    this.colorTone = 'blue',
  });

  final String id;
  final String title;
  final String description;
  final String iconName;
  final bool isUnlocked;
  final String? unlockedAt;
  final String colorTone;

  ProfileBadge copyWith({
    String? id,
    String? title,
    String? description,
    String? iconName,
    bool? isUnlocked,
    String? unlockedAt,
    String? colorTone,
  }) {
    return ProfileBadge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      colorTone: colorTone ?? this.colorTone,
    );
  }
}

/// Current active event ticket.
class EventTicket {
  const EventTicket({
    required this.eventName,
    required this.ticketCode,
    required this.date,
    required this.venue,
    this.qrData,
  });

  final String eventName;
  final String ticketCode;
  final String date;
  final String venue;
  final String? qrData;
}

/// Complete member profile model with identity, statistics, recognition, contribution history, and preferences.
class MemberProfile {
  const MemberProfile({
    required this.id,
    required this.fullName,
    required this.rollNumber,
    required this.githubHandle,
    this.avatarUrl,
    required this.department,
    required this.year,
    required this.mergedPRs,
    required this.openPRs,
    required this.rank,
    required this.points,
    required this.badges,
    required this.skillChips,
    required this.contributions,
    this.privacyEnabled = true,
    this.notificationsEnabled = true,
    this.currentTicket,
  });

  final String id;
  final String fullName;
  final String rollNumber;
  final String githubHandle;
  final String? avatarUrl;
  final String department;
  final int year;

  final int mergedPRs;
  final int openPRs;
  final String rank;
  final int points;

  final List<ProfileBadge> badges;
  final List<String> skillChips;
  final List<ContributionEntry> contributions;

  final bool privacyEnabled;
  final bool notificationsEnabled;
  final EventTicket? currentTicket;

  /// Chronologically sorted contributions (newest first).
  List<ContributionEntry> get chronologicallySortedContributions {
    final list = List<ContributionEntry>.from(contributions);
    list.sort((a, b) => b.parsedDate.compareTo(a.parsedDate));
    return list;
  }

  MemberProfile copyWith({
    String? id,
    String? fullName,
    String? rollNumber,
    String? githubHandle,
    String? avatarUrl,
    String? department,
    int? year,
    int? mergedPRs,
    int? openPRs,
    String? rank,
    int? points,
    List<ProfileBadge>? badges,
    List<String>? skillChips,
    List<ContributionEntry>? contributions,
    bool? privacyEnabled,
    bool? notificationsEnabled,
    EventTicket? currentTicket,
  }) {
    return MemberProfile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      rollNumber: rollNumber ?? this.rollNumber,
      githubHandle: githubHandle ?? this.githubHandle,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      department: department ?? this.department,
      year: year ?? this.year,
      mergedPRs: mergedPRs ?? this.mergedPRs,
      openPRs: openPRs ?? this.openPRs,
      rank: rank ?? this.rank,
      points: points ?? this.points,
      badges: badges ?? this.badges,
      skillChips: skillChips ?? this.skillChips,
      contributions: contributions ?? this.contributions,
      privacyEnabled: privacyEnabled ?? this.privacyEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      currentTicket: currentTicket ?? this.currentTicket,
    );
  }
}
