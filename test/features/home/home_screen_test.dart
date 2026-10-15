import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gdgoc_psit_app/core/theme/app_theme.dart';
import 'package:gdgoc_psit_app/features/auth/domain/models/auth_user.dart';
import 'package:gdgoc_psit_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:gdgoc_psit_app/features/home/presentation/controllers/home_controller.dart';
import 'package:gdgoc_psit_app/features/home/presentation/screens/home_screen.dart';

void main() {
  group('HomeController Tests', () {
    test('Initial state loads board entries and home data', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Trigger build
      final controller = container.read(homeControllerProvider.notifier);
      await controller.loadHomeData();

      final state = container.read(homeControllerProvider);
      expect(state.isLoading, isFalse);
      expect(state.boardEntries.length, 14);
      expect(state.events.length, 3);
      expect(state.projects.length, 3);
      expect(state.activities.length, 4);
      expect(state.userRank, 14);
    });

    test('toggleBoardExpansion toggles state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final controller = container.read(homeControllerProvider.notifier);
      expect(container.read(homeControllerProvider).isBoardExpanded, isFalse);

      controller.toggleBoardExpansion();
      expect(container.read(homeControllerProvider).isBoardExpanded, isTrue);

      controller.toggleBoardExpansion();
      expect(container.read(homeControllerProvider).isBoardExpanded, isFalse);
    });

    test('setFilter updates selected filter', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final controller = container.read(homeControllerProvider.notifier);
      controller.setFilter('events');
      expect(container.read(homeControllerProvider).selectedFilter, 'events');

      // Tapping same filter clears it back to 'all'
      controller.setFilter('events');
      expect(container.read(homeControllerProvider).selectedFilter, 'all');
    });
  });

  group('HomeScreen Widget Tests', () {
    testWidgets('Renders greeting, hero Board card, top 3 leaders, and sections', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final container = ProviderContainer(
        overrides: [
          authControllerProvider.overrideWith(() => _FakeAuthController()),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const HomeScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Greeting
      expect(find.text('Good morning, Aarav'), findsOneWidget);

      // Hero Board card & user rank
      expect(find.text('Your rank on the Board'), findsOneWidget);
      expect(find.text('#14'), findsOneWidget);
      expect(find.text('410 points'), findsWidgets);

      // Top 3 leaders
      expect(find.text('Ishita Verma'), findsOneWidget);
      expect(find.text('Kabir Singh'), findsOneWidget);
      expect(find.text('Ananya Mishra'), findsOneWidget);

      // Expandable button
      expect(find.text('View full Board'), findsOneWidget);

      // Events strip (appears in filter chip and section header)
      expect(find.text('Events'), findsWidgets);
      expect(find.text('Hacktoberfest 2026 Kickoff'), findsOneWidget);
      expect(find.text('Registered'), findsOneWidget);

      // Projects strip
      expect(find.text('Projects'), findsOneWidget);
      expect(find.text('Web App'), findsOneWidget);
      expect(find.text('Android App'), findsOneWidget);
      expect(find.text('Docs'), findsOneWidget);

      // Activity Grid
      expect(find.text('Activity'), findsOneWidget);
    });

    testWidgets('Tapping "View full Board" expands remaining ranks', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final container = ProviderContainer(
        overrides: [
          authControllerProvider.overrideWith(() => _FakeAuthController()),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const HomeScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Tap View full Board
      await tester.tap(find.text('View full Board'));
      await tester.pumpAndSettle();

      expect(find.text('Collapse'), findsOneWidget);
      // Now ranked #14 Aarav Sharma is in the list
      expect(find.text('Aarav Sharma'), findsOneWidget);
      expect(find.text('Pooja Dwivedi'), findsOneWidget);

      // Collapse back
      await tester.tap(find.text('Collapse'));
      await tester.pumpAndSettle();

      expect(find.text('View full Board'), findsOneWidget);
    });

    testWidgets('Filter chips toggle selection', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final container = ProviderContainer(
        overrides: [
          authControllerProvider.overrideWith(() => _FakeAuthController()),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const HomeScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Events'), findsWidgets);
      expect(find.text('Learning'), findsOneWidget);
      expect(find.text('PRs'), findsOneWidget);

      await tester.tap(find.text('Learning'));
      await tester.pumpAndSettle();

      expect(container.read(homeControllerProvider).selectedFilter, 'learning');
    });
  });
}

class _FakeAuthController extends AuthController {
  @override
  AuthState build() {
    return const AuthState(
      status: AuthStatus.authenticated,
      user: AuthUser(
        id: 'usr_aarav',
        rollNumber: '2501640100567',
        name: 'Aarav Sharma',
        email: 'aarav.2501640100567@psit.ac.in',
        role: UserRole.member,
        department: 'CSE',
        year: 3,
      ),
    );
  }
}
