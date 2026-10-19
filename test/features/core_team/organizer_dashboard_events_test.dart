import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gdgoc_psit_app/features/core_team/domain/models/manage_event_item.dart';
import 'package:gdgoc_psit_app/features/core_team/presentation/controllers/core_dashboard_controller.dart';
import 'package:gdgoc_psit_app/features/core_team/presentation/controllers/manage_events_controller.dart';
import 'package:gdgoc_psit_app/features/core_team/presentation/widgets/kpi_card_grid.dart';
import 'package:gdgoc_psit_app/features/core_team/presentation/screens/core_dashboard_screen.dart';
import 'package:gdgoc_psit_app/features/core_team/presentation/screens/manage_events_screen.dart';

void main() {
  group('Screen 12 (Organizer Dashboard) - Widget & Feature Tests', () {
    testWidgets('Renders all dashboard sections: KPIs, Attention items, Board, Team & FAB', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            themeMode: ThemeMode.light,
            home: CoreDashboardScreen(),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // App Bar
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);

      // 4 KPI Cards
      expect(find.descendant(of: find.byType(KpiCardGrid), matching: find.text('5')), findsOneWidget);
      expect(find.text('Upcoming events'), findsOneWidget);

      expect(find.descendant(of: find.byType(KpiCardGrid), matching: find.text('163')), findsOneWidget);
      expect(find.text('Registered students'), findsOneWidget);

      expect(find.descendant(of: find.byType(KpiCardGrid), matching: find.text('3')), findsOneWidget);
      expect(find.text('Projects'), findsOneWidget);

      expect(find.descendant(of: find.byType(KpiCardGrid), matching: find.text('87')), findsOneWidget);
      expect(find.text('Merged PRs'), findsOneWidget);

      // "Needs your attention" items
      expect(find.text('Needs your attention'), findsOneWidget);
      expect(find.text('8 PRs awaiting review'), findsOneWidget);
      expect(find.text('Across 3 projects'), findsOneWidget);

      expect(find.text('Kickoff is 3 seats from full'), findsOneWidget);
      expect(find.text('147 of 150 registered'), findsOneWidget);

      expect(find.text('Workshop waitlist is open'), findsOneWidget);
      expect(find.text('Intro to Flutter · 100 of 100'), findsOneWidget);

      // Leaderboard ("The Board")
      expect(find.text('Your rank on the Board'), findsOneWidget);
      expect(find.text('#4'), findsOneWidget);
      expect(find.text('905 points'), findsWidgets);

      // Team card
      expect(find.text('Team'), findsOneWidget);
      expect(find.text('Rohan Gupta and 13 others'), findsOneWidget);

      // Extended FAB "New"
      expect(find.text('New'), findsOneWidget);
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);
    });

    testWidgets('Tapping FAB "New" opens Quick Action Sheet', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            themeMode: ThemeMode.light,
            home: CoreDashboardScreen(),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      await tester.tap(find.text('New'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Quick Actions'), findsOneWidget);
      expect(find.text('New Event'), findsOneWidget);
      expect(find.text('Scan Attendance'), findsOneWidget);
    });

    testWidgets('Tapping Board toggle expands and collapses leaderboard entries', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            themeMode: ThemeMode.light,
            home: CoreDashboardScreen(),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('View full Board'), findsOneWidget);
      expect(find.text('Ishita Verma'), findsOneWidget); // top 3
      expect(find.text('Kabir Singh'), findsOneWidget); // top 3
      expect(find.text('Ananya Mishra'), findsOneWidget); // top 3

      // Expand Board
      await tester.tap(find.text('View full Board'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Collapse'), findsOneWidget);
      expect(find.text('Priya Tripathi'), findsOneWidget); // rank 5
    });
  });

  group('Screen 13 (Manage Events) - Widget & Feature Tests', () {
    testWidgets('Renders Upcoming events, progress bars, and ratio text', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            themeMode: ThemeMode.light,
            home: ManageEventsScreen(),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Header
      expect(find.text('Events'), findsOneWidget);
      expect(find.text('Upcoming'), findsOneWidget);
      expect(find.text('Past'), findsOneWidget);

      // Event titles
      expect(find.text('Hacktoberfest 2026 Kickoff'), findsOneWidget);
      expect(find.text('147 / 150 registered'), findsOneWidget);
      expect(find.text('Live now'), findsOneWidget);

      expect(find.text('Intro to Flutter Workshop'), findsOneWidget);
      expect(find.text('100 / 100 registered'), findsOneWidget);

      // FAB
      expect(find.text('New event'), findsOneWidget);
    });

    testWidgets('Switches to Past events tab and displays concluded events', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            themeMode: ThemeMode.light,
            home: ManageEventsScreen(),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Tap "Past" tab
      await tester.tap(find.text('Past'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Android Basics Bootcamp'), findsOneWidget);
      expect(find.text('Event concluded'), findsOneWidget);
      expect(find.text('150 / 150 registered'), findsOneWidget);
    });

    testWidgets('Tapping live preview icon toggles preview state', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            themeMode: ThemeMode.light,
            home: ManageEventsScreen(),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      final previewButton = find.byTooltip('Toggle live preview');
      expect(previewButton, findsOneWidget);

      await tester.tap(previewButton);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byTooltip('Live preview active'), findsOneWidget);
    });

    testWidgets('Tapping FAB "New event" opens CreateEditEventSheet and adds an event', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            themeMode: ThemeMode.light,
            home: ManageEventsScreen(),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      await tester.tap(find.text('New event'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('New Event'), findsOneWidget);
      expect(find.text('Create Event'), findsOneWidget);

      // Enter event title
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Event Title'),
        'Google Cloud Day 2026',
      );
      await tester.pump();

      // Submit
      await tester.tap(find.text('Create Event'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Verify new event is in list
      expect(find.text('Google Cloud Day 2026'), findsOneWidget);
    });

    testWidgets('Tapping Edit event button opens sheet prefilled and updates event', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            themeMode: ThemeMode.light,
            home: ManageEventsScreen(),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Tap first Edit event button
      final editButtons = find.byTooltip('Edit event');
      expect(editButtons, findsWidgets);

      await tester.tap(editButtons.first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Edit Event'), findsOneWidget);
      expect(find.text('Save Changes'), findsOneWidget);

      // Modify title
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Event Title'),
        'Hacktoberfest 2026 Kickoff - Extended',
      );
      await tester.pump();

      // Submit changes
      await tester.tap(find.text('Save Changes'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Verify updated title
      expect(find.text('Hacktoberfest 2026 Kickoff - Extended'), findsOneWidget);
    });
  });

  group('Core Controllers Unit Tests', () {
    test('CoreDashboardController loadDashboard updates state accurately', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final controller = container.read(coreDashboardControllerProvider.notifier);
      await controller.loadDashboard();

      final state = container.read(coreDashboardControllerProvider);
      expect(state.isLoading, false);
      expect(state.kpis.length, 4);
      expect(state.attentionItems.length, 3);
      expect(state.teamMembers.length, 3);
      expect(state.totalTeamCount, 14);
      expect(state.boardEntries.isNotEmpty, true);
    });

    test('ManageEventsController toggles tabs, live status, and modifies events', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final controller = container.read(manageEventsControllerProvider.notifier);
      expect(container.read(manageEventsControllerProvider).selectedTab, ManageEventsTab.upcoming);

      controller.setTab(ManageEventsTab.past);
      expect(container.read(manageEventsControllerProvider).selectedTab, ManageEventsTab.past);

      controller.toggleLiveNowPreview();
      expect(container.read(manageEventsControllerProvider).isLiveNowPreviewActive, true);

      // Add event
      const newEvt = ManageEventItem(
        id: 'test_123',
        title: 'Unit Test Event',
        date: 'Sun 25 Oct',
        time: '10:00 AM',
        venue: 'Room 101',
        registeredSeats: 10,
        totalSeats: 50,
      );
      await controller.addEvent(newEvt);

      controller.setTab(ManageEventsTab.upcoming);
      expect(
        container.read(manageEventsControllerProvider).upcomingEvents.any((e) => e.title == 'Unit Test Event'),
        true,
      );

      // Update event
      final updated = newEvt.copyWith(title: 'Updated Test Event');
      await controller.updateEvent(updated);
      expect(
        container.read(manageEventsControllerProvider).upcomingEvents.any((e) => e.title == 'Updated Test Event'),
        true,
      );

      // Delete event
      await controller.deleteEvent('test_123');
      expect(
        container.read(manageEventsControllerProvider).upcomingEvents.any((e) => e.id == 'test_123'),
        false,
      );
    });
  });
}
