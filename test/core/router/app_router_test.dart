import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gdgoc_psit_app/features/auth/data/auth_repository.dart';
import 'package:gdgoc_psit_app/features/auth/domain/models/auth_user.dart';
import 'package:gdgoc_psit_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:gdgoc_psit_app/main.dart';

void main() {
  group('GoRouter Role Shell & Navigation Tests', () {
    testWidgets('Unauthenticated user is redirected to /landing', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: GdgApp(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('GDG on\nCampus\nPSIT'), findsOneWidget);
      expect(find.text('Join the chapter'), findsWidgets);
    });

    testWidgets('Authenticated Member is routed to Member Shell with 5 bottom tabs', (tester) async {
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            FakeAuthRepository(demoRole: UserRole.member),
          ),
        ],
      );
      addTearDown(container.dispose);

      // Authenticate as Member
      await container.read(authControllerProvider.notifier).verifyOtp(otp: '123456');

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const GdgApp(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Member Shell tabs
      expect(find.text('Home'), findsWidgets);
      expect(find.text('Events'), findsWidgets);
      expect(find.text('Projects'), findsWidgets);
      expect(find.text('Learn'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);

      // Verify active tab content is Home
      expect(find.text('Good morning, Aarav'), findsOneWidget);
      expect(find.text('Your rank on the Board'), findsOneWidget);

      // Switch to Events tab
      await tester.tap(find.byIcon(Icons.calendar_month_outlined));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Events Portal'), findsOneWidget);
    });

    testWidgets('Authenticated Core Team is routed to Core Shell with 5 bottom tabs', (tester) async {
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            FakeAuthRepository(demoRole: UserRole.coreTeam),
          ),
        ],
      );
      addTearDown(container.dispose);

      // Authenticate as Core Team
      await container.read(authControllerProvider.notifier).verifyOtp(otp: '123456');

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const GdgApp(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Core Team Shell tabs
      expect(find.text('Dashboard'), findsWidgets);
      expect(find.text('Events'), findsOneWidget);
      expect(find.text('Projects'), findsOneWidget);
      expect(find.text('Members'), findsOneWidget);
      expect(find.text('Me'), findsOneWidget);
      expect(find.text('Dashboard Portal'), findsOneWidget);
    });

    testWidgets('Authenticated Mentor is routed to Mentor Shell with 4 bottom tabs', (tester) async {
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(
            FakeAuthRepository(demoRole: UserRole.mentor),
          ),
        ],
      );
      addTearDown(container.dispose);

      // Authenticate as Mentor
      await container.read(authControllerProvider.notifier).verifyOtp(otp: '123456');

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const GdgApp(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Mentor Shell tabs
      expect(find.text('Overview'), findsOneWidget);
      expect(find.text('Students'), findsOneWidget);
      expect(find.text('Projects'), findsOneWidget);
      expect(find.text('Insights'), findsOneWidget);
      expect(find.text('Chapter Overview Portal'), findsOneWidget);
    });
  });
}
