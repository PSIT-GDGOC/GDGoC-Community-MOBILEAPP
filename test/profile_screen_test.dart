import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gdgoc_psit_app/features/profile/domain/models/member_profile.dart';
import 'package:gdgoc_psit_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:gdgoc_psit_app/features/profile/presentation/widgets/badges_skills_section.dart';
import 'package:gdgoc_psit_app/features/profile/presentation/widgets/profile_statistics_bar.dart';

void main() {
  group('Screen 11 (Profile) - Automated Test Suite', () {
    // ------------------------------------------------------------------------
    // 1. Identity & Statistics Rendering Test
    // ------------------------------------------------------------------------
    testWidgets(
      'Identity & Statistics Rendering: renders avatar, roll number, GitHub handle, and 3-column stats',
      (tester) async {
        tester.view.physicalSize = const Size(800, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          const ProviderScope(child: MaterialApp(home: ProfileScreen())),
        );
        await tester.pumpAndSettle();

        // Identity Section
        expect(find.text('Aarav Sharma'), findsOneWidget);
        expect(find.text('2501640100567'), findsOneWidget);
        expect(find.text('@aarav-sharma'), findsOneWidget);
        expect(find.text('Edit profile'), findsOneWidget);

        // 3-Column Statistics Bar
        expect(find.text('Merged'), findsOneWidget);
        expect(find.text('Open PRs'), findsOneWidget);
        expect(find.text('Rank'), findsOneWidget);

        // Verify exact numerical values in Statistics Bar
        expect(
          find.descendant(
            of: find.byType(ProfileStatisticsBar),
            matching: find.text('3'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: find.byType(ProfileStatisticsBar),
            matching: find.text('1'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: find.byType(ProfileStatisticsBar),
            matching: find.text('#14'),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Identity & Stats Edge Cases: renders correctly with zero values and high volume metrics',
      (tester) async {
        // Edge Case A: Zero stats profile
        const zeroProfile = MemberProfile(
          id: 'u_zero',
          fullName: 'New Member',
          rollNumber: '2501640100999',
          githubHandle: '@new-contributor',
          department: 'IT',
          year: 1,
          mergedPRs: 0,
          openPRs: 0,
          rank: 'Unranked',
          points: 0,
          badges: [],
          skillChips: [],
          contributions: [],
        );

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ProfileStatisticsBar(profile: zeroProfile),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('0'), findsNWidgets(2)); // Merged: 0, Open: 0
        expect(find.text('Unranked'), findsOneWidget);

        // Edge Case B: High volume stats profile
        const highProfile = MemberProfile(
          id: 'u_high',
          fullName: 'Super Member',
          rollNumber: '2501640100001',
          githubHandle: '@super-dev',
          department: 'CSE',
          year: 4,
          mergedPRs: 48,
          openPRs: 12,
          rank: '#1',
          points: 3200,
          badges: [],
          skillChips: [],
          contributions: [],
        );

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ProfileStatisticsBar(profile: highProfile),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('48'), findsOneWidget);
        expect(find.text('12'), findsOneWidget);
        expect(find.text('#1'), findsOneWidget);
      },
    );

    // ------------------------------------------------------------------------
    // 2. Badges & Skill Chips Test (With Layout Overflow Check on Narrow Viewports)
    // ------------------------------------------------------------------------
    testWidgets(
      'Badges & Skill Chips: renders badges including First PR and Event Regular, and skill chips with zero layout overflow',
      (tester) async {
        tester.view.physicalSize = const Size(800, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          const ProviderScope(child: MaterialApp(home: ProfileScreen())),
        );
        await tester.pumpAndSettle();

        // Required Badges
        expect(find.text('First PR'), findsOneWidget);
        expect(find.text('Event Regular'), findsOneWidget);
        expect(find.text('Bug Hunter'), findsOneWidget);
        expect(find.text('Hacktoberfest 2026'), findsOneWidget);

        // Skill Chips
        expect(find.text('Python'), findsOneWidget);
        expect(find.text('React'), findsOneWidget);
        expect(find.text('Git'), findsOneWidget);
        expect(find.text('Cloud'), findsOneWidget);
        expect(find.text('Flutter'), findsOneWidget);

        // Assert no RenderFlex or layout overflow exceptions occurred
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Badges & Skill Chips Narrow Viewport: wraps cleanly on 320px narrow screens without RenderFlex overflow',
      (tester) async {
        // Set narrow viewport (320px width - small Android device)
        tester.view.physicalSize = const Size(320, 1600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final badges = [
          const ProfileBadge(
            id: 'b1',
            title: 'First PR',
            description: 'First accepted pull request',
            iconName: 'workspace_premium',
            isUnlocked: true,
          ),
          const ProfileBadge(
            id: 'b2',
            title: 'Event Regular',
            description: 'Attended 3+ workshops',
            iconName: 'event',
            isUnlocked: true,
          ),
        ];

        final skills = [
          'Python',
          'React',
          'Git',
          'Cloud',
          'Flutter',
          'Android',
          'Docker',
          'Kubernetes',
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: BadgesSkillsSection(
                  badges: badges,
                  skillChips: skills,
                  onAddSkill: (_) {},
                  onRemoveSkill: (_) {},
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Verify chips and badges render
        expect(find.text('First PR'), findsOneWidget);
        expect(find.text('Event Regular'), findsOneWidget);
        expect(find.text('Kubernetes'), findsOneWidget);

        // Crucial: Assert zero RenderFlex overflow on narrow viewport
        expect(tester.takeException(), isNull);
      },
    );

    // ------------------------------------------------------------------------
    // 3. Acceptance Criterion 2 (Chronological Contribution Timeline Stress Test)
    // ------------------------------------------------------------------------
    test(
      'Acceptance Criterion 2: Out-of-order contribution entries spanning 6 months sort strictly newest-first',
      () {
        // Unsorted list of 6 contributions spanning multiple dates
        final rawContributions = [
          const ContributionEntry(
            id: 'c-aug',
            issueTitle: 'August Issue',
            repoName: 'gdgoc-psit/repo-a',
            currentStage: ContributionStage.countedOnBoard,
            timestamps: {'Counted on Board': '15 Aug'},
            isoDate: '2026-08-15T10:00:00Z',
          ),
          const ContributionEntry(
            id: 'c-nov',
            issueTitle: 'November Issue',
            repoName: 'gdgoc-psit/repo-b',
            currentStage: ContributionStage.claimedIssue,
            timestamps: {'Claimed issue': '05 Nov'},
            isoDate: '2026-11-05T12:00:00Z',
          ),
          const ContributionEntry(
            id: 'c-jul',
            issueTitle: 'July Issue',
            repoName: 'gdgoc-psit/repo-c',
            currentStage: ContributionStage.countedOnBoard,
            timestamps: {'Counted on Board': '20 Jul'},
            isoDate: '2026-07-20T08:30:00Z',
          ),
          const ContributionEntry(
            id: 'c-oct-late',
            issueTitle: 'Late October Issue',
            repoName: 'gdgoc-psit/repo-d',
            currentStage: ContributionStage.prOpened,
            timestamps: {'PR opened': '28 Oct'},
            isoDate: '2026-10-28T16:45:00Z',
          ),
          const ContributionEntry(
            id: 'c-sep',
            issueTitle: 'September Issue',
            repoName: 'gdgoc-psit/repo-e',
            currentStage: ContributionStage.prOpened,
            timestamps: {'PR opened': '14 Sep'},
            isoDate: '2026-09-14T11:20:00Z',
          ),
          const ContributionEntry(
            id: 'c-oct-early',
            issueTitle: 'Early October Issue',
            repoName: 'gdgoc-psit/repo-f',
            currentStage: ContributionStage.countedOnBoard,
            timestamps: {'Counted on Board': '02 Oct'},
            isoDate: '2026-10-02T09:00:00Z',
          ),
        ];

        final profile = MemberProfile(
          id: 'user-stress-test',
          fullName: 'Stress Test User',
          rollNumber: '2501640100000',
          githubHandle: '@stresstest',
          department: 'CSE',
          year: 3,
          mergedPRs: 3,
          openPRs: 2,
          rank: '#5',
          points: 800,
          badges: const [],
          skillChips: const [],
          contributions: rawContributions, // Unsorted
        );

        final sorted = profile.chronologicallySortedContributions;
        expect(sorted.length, 6);

        // Strict newest to oldest order: Nov -> Late Oct -> Early Oct -> Sep -> Aug -> Jul
        expect(sorted[0].id, 'c-nov');
        expect(sorted[1].id, 'c-oct-late');
        expect(sorted[2].id, 'c-oct-early');
        expect(sorted[3].id, 'c-sep');
        expect(sorted[4].id, 'c-aug');
        expect(sorted[5].id, 'c-jul');

        // Every adjacent pair satisfies parsedDate[i] >= parsedDate[i+1]
        for (int i = 0; i < sorted.length - 1; i++) {
          expect(
            sorted[i].parsedDate.isAfter(sorted[i + 1].parsedDate) ||
                sorted[i].parsedDate.isAtSameMomentAs(sorted[i + 1].parsedDate),
            true,
          );
        }
      },
    );

    testWidgets(
      'Acceptance Criterion 2: Interactive 3-step progression renders in sequence and responds to interactions',
      (tester) async {
        tester.view.physicalSize = const Size(800, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          const ProviderScope(child: MaterialApp(home: ProfileScreen())),
        );
        await tester.pumpAndSettle();

        // Verify timeline section header
        expect(find.text('Contribution Timeline'), findsOneWidget);
        expect(find.text('Chronological'), findsOneWidget);

        // Verify the 3 progression step labels render in sequence
        expect(find.text('Claimed issue'), findsWidgets);
        expect(find.text('PR opened'), findsWidgets);
        expect(find.text('Counted on Board'), findsWidgets);

        // Verify initial statistics: 3 merged, 1 open
        expect(
          find.descendant(
            of: find.byType(ProfileStatisticsBar),
            matching: find.text('3'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: find.byType(ProfileStatisticsBar),
            matching: find.text('1'),
          ),
          findsOneWidget,
        );

        // Find all advance buttons
        final advanceButtons = find.byTooltip('Advance progression stage');
        expect(advanceButtons, findsWidgets);

        // 1. Advance first contribution (contrib_5) from Claimed Issue -> PR Opened
        await tester.tap(advanceButtons.first);
        await tester.pumpAndSettle();

        // Open PRs should increase from 1 to 2
        expect(
          find.descendant(
            of: find.byType(ProfileStatisticsBar),
            matching: find.text('2'),
          ),
          findsOneWidget,
        );

        // 2. Advance first contribution again from PR Opened -> Counted on Board
        await tester.tap(advanceButtons.first);
        await tester.pumpAndSettle();

        // Merged PRs should now increase from 3 to 4, and Open PRs return to 1
        expect(
          find.descendant(
            of: find.byType(ProfileStatisticsBar),
            matching: find.text('4'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: find.byType(ProfileStatisticsBar),
            matching: find.text('1'),
          ),
          findsOneWidget,
        );

        // 3. Tap a stage node directly (e.g. stage node inside ContributionTimelineCard to reset to Claimed issue)
        await tester.tap(find.text('Claimed issue').first);
        await tester.pumpAndSettle();

        // Merged PRs should decrement back to 3
        expect(
          find.descendant(
            of: find.byType(ProfileStatisticsBar),
            matching: find.text('3'),
          ),
          findsOneWidget,
        );

        // Verify no exceptions thrown during interaction
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Timeline Stage Transitions: nodes display distinct visual indicators, timestamps, and advance dynamically on tap',
      (tester) async {
        tester.view.physicalSize = const Size(800, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          const ProviderScope(child: MaterialApp(home: ProfileScreen())),
        );
        await tester.pumpAndSettle();

        // Verify stage nodes for the first contribution (contrib_5 in claimedIssue stage)
        // Stage 1 (Claimed issue) is active/completed with timestamp "10 Oct"
        expect(find.text('10 Oct'), findsOneWidget);
        // Stage 2 (PR opened) displays timestamp "In progress"
        expect(find.text('In progress'), findsOneWidget);
        // Stage 3 (Counted on Board) displays timestamp "Pending PR"
        expect(find.text('Pending PR'), findsOneWidget);

        // Tap on Stage 2 node "PR opened" directly
        await tester.tap(find.text('PR opened').first);
        await tester.pumpAndSettle();

        // Open PRs should increment from 1 to 2
        expect(
          find.descendant(
            of: find.byType(ProfileStatisticsBar),
            matching: find.text('2'),
          ),
          findsOneWidget,
        );

        // Tap on Stage 3 node "Counted on Board" directly
        await tester.tap(find.text('Counted on Board').first);
        await tester.pumpAndSettle();

        // Merged PR count should now be 4
        expect(
          find.descendant(
            of: find.byType(ProfileStatisticsBar),
            matching: find.text('4'),
          ),
          findsOneWidget,
        );
      },
    );


    // ------------------------------------------------------------------------
    // 4. Settings Toggles Persistence Test
    // ------------------------------------------------------------------------
    testWidgets(
      'Settings Toggle Persistence: multiple toggles update boolean states reliably on every tap',
      (tester) async {
        tester.view.physicalSize = const Size(800, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          const ProviderScope(child: MaterialApp(home: ProfileScreen())),
        );
        await tester.pumpAndSettle();

        final switches = find.byType(Switch);
        expect(switches, findsNWidgets(2)); // Notifications & Privacy switches

        // Cycle through 4 toggles on each switch to verify full state persistence
        for (int cycle = 0; cycle < 2; cycle++) {
          // Toggle off
          await tester.tap(switches.at(0));
          await tester.tap(switches.at(1));
          await tester.pumpAndSettle();

          expect(tester.widget<Switch>(switches.at(0)).value, false);
          expect(tester.widget<Switch>(switches.at(1)).value, false);

          // Toggle back on
          await tester.tap(switches.at(0));
          await tester.tap(switches.at(1));
          await tester.pumpAndSettle();

          expect(tester.widget<Switch>(switches.at(0)).value, true);
          expect(tester.widget<Switch>(switches.at(1)).value, true);
        }
      },
    );
  });
}
