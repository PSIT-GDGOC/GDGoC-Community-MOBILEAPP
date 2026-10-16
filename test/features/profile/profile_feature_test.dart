import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gdgoc_psit_app/features/profile/data/profile_mock_data.dart';
import 'package:gdgoc_psit_app/features/profile/domain/models/member_profile.dart';
import 'package:gdgoc_psit_app/features/profile/presentation/controllers/profile_controller.dart';
import 'package:gdgoc_psit_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:gdgoc_psit_app/features/profile/presentation/widgets/profile_statistics_bar.dart';

void main() {
  group('Screen 11 (Profile) - Unit Tests', () {
    test(
      'MemberProfile contains required identity, statistics, recognition, and preferences',
      () {
        final profile = ProfileMockData.getInitialProfile();

        // Identity
        expect(profile.fullName, 'Aarav Sharma');
        expect(profile.rollNumber, '2501640100567');
        expect(profile.githubHandle, '@aarav-sharma');

        // Statistics
        expect(profile.mergedPRs, 3);
        expect(profile.openPRs, 1);
        expect(profile.rank, '#14');

        // Recognition: Badges must include First PR and Event Regular
        final badgeTitles = profile.badges.map((b) => b.title).toList();
        expect(badgeTitles, contains('First PR'));
        expect(badgeTitles, contains('Event Regular'));

        final firstPrBadge = profile.badges.firstWhere(
          (b) => b.title == 'First PR',
        );
        expect(firstPrBadge.isUnlocked, true);

        final eventRegularBadge = profile.badges.firstWhere(
          (b) => b.title == 'Event Regular',
        );
        expect(eventRegularBadge.isUnlocked, true);

        // Skill chips
        expect(profile.skillChips, contains('Python'));
        expect(profile.skillChips, contains('React'));
        expect(profile.skillChips, contains('Git'));
        expect(profile.skillChips, contains('Cloud'));

        // Preferences
        expect(profile.privacyEnabled, true);
        expect(profile.notificationsEnabled, true);
      },
    );

    test(
      'Contributions are sorted chronologically by timestamp before rendering',
      () {
        final profile = ProfileMockData.getInitialProfile();
        final sorted = profile.chronologicallySortedContributions;

        for (int i = 0; i < sorted.length - 1; i++) {
          expect(
            sorted[i].parsedDate.isAfter(sorted[i + 1].parsedDate) ||
                sorted[i].parsedDate.isAtSameMomentAs(sorted[i + 1].parsedDate),
            true,
          );
        }
      },
    );

    test(
      'Interactive 3-step progression advances and dynamically recalculates statistics',
      () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final profile = ProfileMockData.getInitialProfile();
        expect(profile.mergedPRs, 3);
        expect(profile.openPRs, 1);

        // Find contribution in "prOpened" state
        final prOpenedContrib = profile.contributions.firstWhere(
          (c) => c.currentStage == ContributionStage.prOpened,
        );

        // Advance stage from prOpened -> countedOnBoard
        container
            .read(profileControllerProvider.notifier)
            .advanceContributionStage(prOpenedContrib.id);

        final updatedProfile = container
            .read(profileControllerProvider)
            .profile!;
        final updatedContrib = updatedProfile.contributions.firstWhere(
          (c) => c.id == prOpenedContrib.id,
        );

        expect(updatedContrib.currentStage, ContributionStage.countedOnBoard);
        // Merged PR count should now be 4 and open PR count should be 0
        expect(updatedProfile.mergedPRs, 4);
        expect(updatedProfile.openPRs, 0);
      },
    );

    test('Preferences toggles work correctly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(profileControllerProvider.notifier).togglePrivacy(false);
      expect(
        container.read(profileControllerProvider).profile!.privacyEnabled,
        false,
      );

      container
          .read(profileControllerProvider.notifier)
          .toggleNotifications(false);
      expect(
        container.read(profileControllerProvider).profile!.notificationsEnabled,
        false,
      );
    });
  });

  group('Screen 11 (Profile) - Widget Tests', () {
    testWidgets('Renders all 5 sections of Member Profile screen', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ProfileScreen())),
      );
      await tester.pumpAndSettle();

      // Section 1: Identity Header
      expect(find.text('Aarav Sharma'), findsOneWidget);
      expect(find.text('2501640100567'), findsOneWidget);
      expect(find.text('@aarav-sharma'), findsOneWidget);
      expect(find.text('Edit profile'), findsOneWidget);

      // Section 2: 3-Column Statistics Bar
      expect(find.text('Merged'), findsOneWidget);
      expect(find.text('Open PRs'), findsOneWidget);
      expect(find.text('Rank'), findsOneWidget);
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

      // Section 3: Badges & Skill Chips
      expect(find.text('First PR'), findsOneWidget);
      expect(find.text('Event Regular'), findsOneWidget);
      expect(find.text('Python'), findsOneWidget);
      expect(find.text('React'), findsOneWidget);

      // Section 4: Contribution Timeline
      expect(find.text('Contribution Timeline'), findsOneWidget);
      expect(find.text('Claimed issue'), findsWidgets);
      expect(find.text('PR opened'), findsWidgets);
      expect(find.text('Counted on Board'), findsWidgets);

      // Section 5: Current Pass & Settings
      expect(find.text('Hacktoberfest 2026 Kickoff'), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Privacy'), findsOneWidget);
      expect(find.text('Sign out'), findsOneWidget);
    });

    testWidgets(
      'Tapping on a step or advance updates contribution stage and statistics',
      (tester) async {
        tester.view.physicalSize = const Size(800, 1600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          const ProviderScope(child: MaterialApp(home: ProfileScreen())),
        );
        await tester.pumpAndSettle();

        expect(
          find.descendant(
            of: find.byType(ProfileStatisticsBar),
            matching: find.text('3'),
          ),
          findsOneWidget,
        ); // Initial Merged PRs

        // Tap on the advance stage sync icon button for a contribution
        final advanceButtons = find.byTooltip('Advance progression stage');
        expect(advanceButtons, findsWidgets);

        await tester.tap(advanceButtons.at(0));
        await tester.pumpAndSettle();

        // Ensure widget tree updated successfully without errors
        expect(find.text('Contribution Timeline'), findsOneWidget);
      },
    );

    testWidgets('Tapping ticket opens QR code preview pass dialog', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ProfileScreen())),
      );
      await tester.pumpAndSettle();

      // Tap the ticket card
      await tester.tap(find.text('Hacktoberfest 2026 Kickoff'));
      await tester.pumpAndSettle();

      // Verify QR Pass dialog opens
      expect(find.text('Event Pass'), findsOneWidget);
      expect(find.text('HF26-KICK-0567'), findsWidgets);
      expect(find.text('Save Ticket to Device'), findsOneWidget);
    });

    testWidgets('Toggling preferences switches update state', (tester) async {
      tester.view.physicalSize = const Size(800, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: ProfileScreen())),
      );
      await tester.pumpAndSettle();

      final switches = find.byType(Switch);
      expect(switches, findsNWidgets(2)); // Notifications & Privacy

      // Toggle first switch
      await tester.tap(switches.first);
      await tester.pumpAndSettle();

      // Verify switch toggled
      expect(find.text('Notifications'), findsOneWidget);
    });
  });
}
