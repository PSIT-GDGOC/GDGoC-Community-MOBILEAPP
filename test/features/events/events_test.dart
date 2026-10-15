import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gdgoc_psit_app/core/theme/app_theme.dart';
import 'package:gdgoc_psit_app/features/auth/domain/models/auth_user.dart';
import 'package:gdgoc_psit_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:gdgoc_psit_app/features/events/data/events_repository.dart';
import 'package:gdgoc_psit_app/features/events/domain/models/event_item.dart';
import 'package:gdgoc_psit_app/features/events/presentation/controllers/events_controller.dart';
import 'package:gdgoc_psit_app/features/events/presentation/screens/event_detail_screen.dart';
import 'package:gdgoc_psit_app/features/events/presentation/screens/events_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  group('Events Repository & Controller Tests', () {
    test('FakeEventsRepository filters and registers properly', () async {
      final repo = FakeEventsRepository();

      final all = await repo.getEvents(filter: 'all');
      expect(all.length, 6);

      final openEvents = await repo.getEvents(filter: 'open');
      expect(openEvents.every((e) => e.status == EventRegistrationStatus.open), isTrue);

      final registeredEvents = await repo.getEvents(filter: 'registered');
      expect(registeredEvents.length, 1);
      expect(registeredEvents.first.id, 'evt_kickoff');

      // Register for an open event
      final registered = await repo.registerForEvent('evt_gcp', rollNumber: '2501640100567');
      expect(registered.status, EventRegistrationStatus.registered);
      expect(registered.ticketCode, 'GCP-JAM-0567');
      expect(registered.isUserRegistered, isTrue);

      // Join waitlist
      final waitlisted = await repo.joinWaitlist('evt_build_night');
      expect(waitlisted.status, EventRegistrationStatus.waitlist);
    });

    test('EventsController state transitions', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final controller = container.read(eventsControllerProvider.notifier);
      expect(container.read(eventsControllerProvider).events.length, 6);
      expect(container.read(eventsControllerProvider).currentIndex, 0);

      // Next card
      controller.nextCard();
      expect(container.read(eventsControllerProvider).currentIndex, 1);

      // Previous card
      controller.previousCard();
      expect(container.read(eventsControllerProvider).currentIndex, 0);

      // Set filter
      await controller.setFilter('open');
      expect(container.read(eventsControllerProvider).selectedFilter, 'open');
      expect(container.read(eventsControllerProvider).currentIndex, 0);
      expect(container.read(eventsControllerProvider).events.length, 3);
    });
  });

  group('Screen 06: EventsScreen Widget Tests', () {
    testWidgets('Renders filters, deck, counter, and advances cards on chevron click', (tester) async {
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
            home: const EventsScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Title & Filters
      expect(find.text('Events'), findsOneWidget);
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Open'), findsOneWidget);
      expect(find.text('Registered'), findsWidgets);
      expect(find.text('Waitlist'), findsWidgets);
      expect(find.text('Past'), findsOneWidget);

      // Card counter & first event
      expect(find.text('1 of 6'), findsOneWidget);
      expect(find.text('Hacktoberfest 2026 Kickoff'), findsOneWidget);
      expect(find.text('Sat 10 Oct · 11:00 AM'), findsOneWidget);
      expect(find.text('Seminar Hall'), findsOneWidget);

      // Advance with right chevron
      await tester.tap(find.byTooltip('Next event'));
      await tester.pumpAndSettle();

      expect(find.text('2 of 6'), findsOneWidget);
      expect(find.text('Intro to Flutter Workshop'), findsOneWidget);

      // Go back with left chevron
      await tester.tap(find.byTooltip('Previous event'));
      await tester.pumpAndSettle();

      expect(find.text('1 of 6'), findsOneWidget);
      expect(find.text('Hacktoberfest 2026 Kickoff'), findsOneWidget);

      // Filter to Waitlist (first is the filter chip in the horizontal row)
      await tester.tap(find.text('Waitlist').first);
      await tester.pumpAndSettle();

      expect(find.text('1 of 1'), findsOneWidget);
      expect(find.text('Intro to Flutter Workshop'), findsOneWidget);
    });

    testWidgets('Swiping card horizontally advances deck', (tester) async {
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
            home: const EventsScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Drag card to the left
      await tester.drag(find.text('Hacktoberfest 2026 Kickoff'), const Offset(-250, 0));
      await tester.pumpAndSettle();

      expect(find.text('2 of 6'), findsOneWidget);
      expect(find.text('Intro to Flutter Workshop'), findsOneWidget);
    });
  });

  group('Screen 07: EventDetailScreen & TicketSheet Tests', () {
    testWidgets('Renders event details, speakers, and opens ticket sheet with QR code', (tester) async {
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
            home: const EventDetailScreen(
              eventId: 'evt_kickoff',
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Title & Posters
      expect(find.text('Hacktoberfest 2026 Kickoff'), findsOneWidget);
      expect(find.text('Kickoff'), findsOneWidget);
      expect(find.text('Speakers'), findsWidgets);
      expect(find.text('Agenda'), findsOneWidget);
      expect(find.text('Seminar Hall'), findsOneWidget);

      // About & Speakers
      expect(find.text('About'), findsOneWidget);
      expect(find.text('Rohan Gupta'), findsOneWidget);
      expect(find.text('Dr. Neha Agarwal'), findsOneWidget);

      // Learnings
      expect(find.text("What you'll learn"), findsOneWidget);
      expect(find.text('Fork, branch and open a pull request'), findsOneWidget);

      // Glassmorphic action bar has View ticket
      expect(find.text('View ticket'), findsOneWidget);

      // Tap View ticket
      await tester.tap(find.text('View ticket'));
      await tester.pumpAndSettle();

      // Ticket sheet should now be visible
      expect(find.text("You're registered"), findsOneWidget);
      expect(find.byType(QrImageView), findsOneWidget);
      expect(find.text('Aarav Sharma'), findsOneWidget);
      expect(find.text('2501640100567 · HF26-KICK-0567'), findsOneWidget);
      expect(find.text('Save ticket'), findsOneWidget);

      // Save ticket tap
      await tester.tap(find.text('Save ticket'));
      await tester.pumpAndSettle();

      expect(find.text('Ticket code copied: HF26-KICK-0567'), findsOneWidget);
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
