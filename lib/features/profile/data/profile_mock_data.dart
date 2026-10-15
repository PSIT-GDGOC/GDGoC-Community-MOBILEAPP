import '../domain/models/member_profile.dart';

abstract final class ProfileMockData {
  static MemberProfile getInitialProfile() {
    return MemberProfile(
      id: 'usr_0567',
      fullName: 'Aarav Sharma',
      rollNumber: '2501640100567',
      githubHandle: '@aarav-sharma',
      avatarUrl: null,
      department: 'Computer Science',
      year: 3,
      mergedPRs: 3,
      openPRs: 1,
      rank: '#14',
      points: 410,
      badges: const [
        ProfileBadge(
          id: 'badge_first_pr',
          title: 'First PR',
          description:
              'Successfully opened and merged your first accepted pull request in Open Source October.',
          iconName: 'workspace_premium',
          isUnlocked: true,
          unlockedAt: '3 Oct',
          colorTone: 'yellow',
        ),
        ProfileBadge(
          id: 'badge_event_regular',
          title: 'Event Regular',
          description:
              'Attended 3+ GDGoC PSIT workshops and study jams with verified QR attendance.',
          iconName: 'event',
          isUnlocked: true,
          unlockedAt: '18 Sep',
          colorTone: 'blue',
        ),
        ProfileBadge(
          id: 'badge_bug_hunter',
          title: 'Bug Hunter',
          description:
              'Reported and claimed verified issues in chapter repositories.',
          iconName: 'bug_report',
          isUnlocked: true,
          unlockedAt: '28 Sep',
          colorTone: 'green',
        ),
        ProfileBadge(
          id: 'badge_hacktober_finisher',
          title: 'Hacktoberfest 2026',
          description:
              'Complete 4 accepted pull requests during Open Source October.',
          iconName: 'celebration',
          isUnlocked: false,
          colorTone: 'red',
        ),
      ],
      skillChips: const [
        'Android',
        'Next.js',
        'Python',
        'React',
        'Git',
        'Cloud',
        'Flutter',
      ],
      contributions: const [
        ContributionEntry(
          id: 'contrib_1',
          issueTitle: 'Paginate the attendee list',
          repoName: 'gdgoc-web-app',
          issueNumber: '#236',
          currentStage: ContributionStage.countedOnBoard,
          timestamps: {
            'Claimed issue': '2 Oct',
            'PR opened': '4 Oct',
            'Counted on Board': '5 Oct',
          },
          isoDate: '2026-10-05T14:30:00Z',
        ),
        ContributionEntry(
          id: 'contrib_2',
          issueTitle: 'Implement Material 3 Linear Progress Bar',
          repoName: 'gdgoc-mobile-app',
          issueNumber: '#114',
          currentStage: ContributionStage.countedOnBoard,
          timestamps: {
            'Claimed issue': '28 Sep',
            'PR opened': '30 Sep',
            'Counted on Board': '3 Oct',
          },
          isoDate: '2026-10-03T11:00:00Z',
        ),
        ContributionEntry(
          id: 'contrib_3',
          issueTitle: 'Fix bottom navigation indicator padding',
          repoName: 'gdgoc-mobile-app',
          issueNumber: '#108',
          currentStage: ContributionStage.countedOnBoard,
          timestamps: {
            'Claimed issue': '25 Sep',
            'PR opened': '27 Sep',
            'Counted on Board': '28 Sep',
          },
          isoDate: '2026-10-01T09:20:00Z',
        ),
        ContributionEntry(
          id: 'contrib_4',
          issueTitle: 'Add QR code scanner camera overlay',
          repoName: 'gdgoc-mobile-app',
          issueNumber: '#249',
          currentStage: ContributionStage.prOpened,
          timestamps: {
            'Claimed issue': '6 Oct',
            'PR opened': '8 Oct',
            'Counted on Board': 'In review',
          },
          isoDate: '2026-10-08T18:45:00Z',
        ),
        ContributionEntry(
          id: 'contrib_5',
          issueTitle: 'Setup Cloud Run automated CI deployment',
          repoName: 'gdgoc-backend',
          issueNumber: '#312',
          currentStage: ContributionStage.claimedIssue,
          timestamps: {
            'Claimed issue': '10 Oct',
            'PR opened': 'In progress',
            'Counted on Board': 'Pending PR',
          },
          isoDate: '2026-10-10T16:15:00Z',
        ),
      ],
      privacyEnabled: true,
      notificationsEnabled: true,
      currentTicket: const EventTicket(
        eventName: 'Hacktoberfest 2026 Kickoff',
        ticketCode: 'HF26-KICK-0567',
        date: '18 Oct 2026 · 10:00 AM',
        venue: 'PSIT Main Auditorium',
        qrData: 'GDGOC-PSIT:HF26-KICK-0567:2501640100567',
      ),
    );
  }
}
