import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gdgoc_psit_app/features/core_team/domain/models/manage_event_item.dart';
import 'package:gdgoc_psit_app/features/scanner/data/attendance_repository.dart';
import 'package:gdgoc_psit_app/features/scanner/domain/models/ticket_validation_result.dart';
import 'package:gdgoc_psit_app/features/scanner/presentation/controllers/scanner_controller.dart';
import 'package:gdgoc_psit_app/features/scanner/presentation/screens/attendance_scanner_screen.dart';

void main() {
  group('Screen 23 (Attendance Repository) - Unit & Validation Logic Tests', () {
    late FakeAttendanceRepository repository;

    setUp(() {
      repository = FakeAttendanceRepository();
    });

    test('Validates unregistered ticket and marks attendance successfully', () async {
      final record = await repository.validateAndMarkAttendance(
        eventId: 'evt_kickoff',
        rawQrCode: 'HF26-KICK-0567',
      );

      expect(record.status, TicketValidationStatus.valid);
      expect(record.isSuccess, true);
      expect(record.attendee, isNotNull);
      expect(record.attendee!.name, 'Aarav Sharma');
      expect(record.attendee!.rollNumber, '2501640100567');
      expect(record.attendee!.department, 'CS');
      expect(record.attendee!.year, 3);
    });

    test('Duplicate scan enforcement: scanning same ticket twice returns alreadyUsed status', () async {
      // First scan: marks attendance
      final firstRecord = await repository.validateAndMarkAttendance(
        eventId: 'evt_kickoff',
        rawQrCode: 'HF26-KICK-0153',
      );
      expect(firstRecord.status, TicketValidationStatus.valid);

      // Second scan: duplicate rejection
      final secondRecord = await repository.validateAndMarkAttendance(
        eventId: 'evt_kickoff',
        rawQrCode: 'HF26-KICK-0153',
      );
      expect(secondRecord.status, TicketValidationStatus.alreadyUsed);
      expect(secondRecord.isSuccess, false);
      expect(secondRecord.firstScannedAt, isNotNull);
      expect(secondRecord.attendee?.name, 'Kabir Singh');
    });

    test('Detects pre-checked in attendee as alreadyUsed', () async {
      final record = await repository.validateAndMarkAttendance(
        eventId: 'evt_kickoff',
        rawQrCode: 'HF26-KICK-0100', // Ishita Verma pre-checked in
      );

      expect(record.status, TicketValidationStatus.alreadyUsed);
      expect(record.attendee?.name, 'Ishita Verma');
    });

    test('Rejects ticket registered for another event', () async {
      final record = await repository.validateAndMarkAttendance(
        eventId: 'evt_kickoff',
        rawQrCode: 'FLTR-W14-0259', // Registered for Flutter workshop
      );

      expect(record.status, TicketValidationStatus.invalidEvent);
      expect(record.errorMessage, contains('different GDGoC event'));
    });

    test('Rejects non-existent ticket code', () async {
      final record = await repository.validateAndMarkAttendance(
        eventId: 'evt_kickoff',
        rawQrCode: 'RANDOM-INVALID-TICKET',
      );

      expect(record.status, TicketValidationStatus.notFound);
      expect(record.attendee, isNull);
    });

    test('Extracts ticket code from URL query parameters', () async {
      final record = await repository.validateAndMarkAttendance(
        eventId: 'evt_kickoff',
        rawQrCode: 'https://gdgoc.psit.ac.in/tickets/verify?code=HF26-KICK-0206',
      );

      expect(record.status, TicketValidationStatus.valid);
      expect(record.attendee?.name, 'Ananya Mishra');
      expect(record.attendee?.rollNumber, '2501640100206');
    });

    test('Calculates attendance metrics accurately', () async {
      final stats = await repository.getAttendanceStats('evt_kickoff');
      expect(stats.totalRegistered, 7);
      expect(stats.checkedInCount, 1); // Only pre-checked in Ishita Verma

      // Scan Aarav
      await repository.validateAndMarkAttendance(
        eventId: 'evt_kickoff',
        rawQrCode: 'HF26-KICK-0567',
      );

      final updatedStats = await repository.getAttendanceStats('evt_kickoff');
      expect(updatedStats.checkedInCount, 2);
    });
  });

  group('Screen 23 (ScannerController) - Unit Tests', () {
    test('Initializes event and loads attendance stats', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final controller = container.read(scannerControllerProvider.notifier);
      await controller.initEvent(
        eventId: 'evt_kickoff',
        eventTitle: 'Hacktoberfest 2026 Kickoff',
      );

      final state = container.read(scannerControllerProvider);
      expect(state.eventId, 'evt_kickoff');
      expect(state.eventTitle, 'Hacktoberfest 2026 Kickoff');
      expect(state.stats, isNotNull);
      expect(state.stats!.checkedInCount, 1);
    });

    test('processBarcode updates lastScan, scanHistory, and stats', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final controller = container.read(scannerControllerProvider.notifier);
      await controller.initEvent(
        eventId: 'evt_kickoff',
        eventTitle: 'Kickoff',
      );

      final record = await controller.processBarcode('HF26-KICK-0567');
      expect(record.status, TicketValidationStatus.valid);

      final state = container.read(scannerControllerProvider);
      expect(state.lastScan, isNotNull);
      expect(state.lastScan!.attendee?.name, 'Aarav Sharma');
      expect(state.scanHistory.length, 1);
      expect(state.stats!.checkedInCount, 2);

      // Clear scan
      controller.clearLastScan();
      expect(container.read(scannerControllerProvider).lastScan, isNull);
    });

    test('Toggles torch and camera facing', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final controller = container.read(scannerControllerProvider.notifier);
      expect(container.read(scannerControllerProvider).isTorchOn, false);
      expect(container.read(scannerControllerProvider).isFrontCamera, false);

      controller.toggleTorch();
      expect(container.read(scannerControllerProvider).isTorchOn, true);

      controller.toggleCameraFacing();
      expect(container.read(scannerControllerProvider).isFrontCamera, true);
    });
  });

  group('Screen 23 (AttendanceScannerScreen) - Widget & UI Flow Tests', () {
    testWidgets('Renders top bar, counter, manual entry trigger, and action buttons', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      const testEvent = ManageEventItem(
        id: 'evt_kickoff',
        title: 'Hacktoberfest 2026 Kickoff',
        date: 'Sat 10 Oct',
        time: '11:00 AM',
        venue: 'Seminar Hall',
        registeredSeats: 147,
        totalSeats: 150,
      );

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AttendanceScannerScreen(
              eventId: 'evt_kickoff',
              initialEvent: testEvent,
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Title & Subtitle
      expect(find.text('Hacktoberfest 2026 Kickoff'), findsOneWidget);
      expect(find.text('Core Team Attendance Scanner'), findsOneWidget);

      // Attendance Counter
      expect(find.text('1 / 7'), findsOneWidget); // 1 checked in out of 7 registered

      // Control actions
      expect(find.text('Torch'), findsOneWidget);
      expect(find.text('Flip'), findsOneWidget);
      expect(find.text('Type Code'), findsOneWidget);
      expect(find.text('History'), findsOneWidget);

      // Overlay text
      expect(find.text('Align ticket QR code within the frame'), findsOneWidget);
    });

    testWidgets('Manual code validation flow: valid ticket displays attendee name and roll number', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AttendanceScannerScreen(
              eventId: 'evt_kickoff',
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Tap "Type Code"
      await tester.tap(find.text('Type Code'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('Enter Ticket Code'), findsOneWidget);

      // Enter valid code for Aarav Sharma
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Ticket ID or Code'),
        'HF26-KICK-0567',
      );
      await tester.pump();

      // Submit
      await tester.tap(find.text('Validate & Mark Attendance'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Verify ScanResultSheet pops up with Valid details
      expect(find.text('Attendance Marked'), findsOneWidget);
      expect(find.text('Aarav Sharma'), findsOneWidget);
      expect(find.text('2501640100567'), findsOneWidget);
      expect(find.text('CS · 3rd Year'), findsOneWidget);
      expect(find.text('HF26-KICK-0567'), findsOneWidget);

      // Dismiss / Scan Next
      expect(find.text('Scan Next Attendee'), findsOneWidget);
      await tester.tap(find.text('Scan Next Attendee'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // Sheet dismissed
      expect(find.text('Attendance Marked'), findsNothing);
    });

    testWidgets('Duplicate ticket scan flow: shows already checked in warning', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AttendanceScannerScreen(
              eventId: 'evt_kickoff',
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Tap "Type Code"
      await tester.tap(find.text('Type Code'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Enter pre-checked-in ticket: Ishita Verma (HF26-KICK-0100)
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Ticket ID or Code'),
        'HF26-KICK-0100',
      );
      await tester.pump();

      // Submit
      await tester.tap(find.text('Validate & Mark Attendance'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Verify Duplicate Warning
      expect(find.text('Already Checked In'), findsOneWidget);
      expect(find.text('Ishita Verma'), findsOneWidget);
      expect(find.textContaining('Each ticket can mark attendance only once'), findsOneWidget);
    });

    testWidgets('Invalid ticket scan flow: shows error feedback and try again option', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AttendanceScannerScreen(
              eventId: 'evt_kickoff',
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Tap "Type Code"
      await tester.tap(find.text('Type Code'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Enter unknown code
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Ticket ID or Code'),
        'UNKNOWN-CODE-999',
      );
      await tester.pump();

      // Submit
      await tester.tap(find.text('Validate & Mark Attendance'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Invalid Ticket Code'), findsOneWidget);
      expect(find.textContaining('was not found in registration database'), findsOneWidget);
    });

    testWidgets('Tapping History button displays recent scans in modal sheet', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AttendanceScannerScreen(
              eventId: 'evt_kickoff',
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // First do a scan
      await tester.tap(find.text('Type Code'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Ticket ID or Code'),
        'HF26-KICK-0567',
      );
      await tester.tap(find.text('Validate & Mark Attendance'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Dismiss scan result
      await tester.tap(find.text('Scan Next Attendee'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Open History
      await tester.tap(find.text('History'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.textContaining('Session Scans'), findsOneWidget);
      expect(find.text('Aarav Sharma'), findsOneWidget);
      expect(find.text('2501640100567'), findsOneWidget);
    });
  });
}
