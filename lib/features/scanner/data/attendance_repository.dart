import '../domain/models/ticket_validation_result.dart';

abstract interface class AttendanceRepository {
  Future<ScanRecord> validateAndMarkAttendance({
    required String eventId,
    required String rawQrCode,
  });

  Future<List<ScanRecord>> getAttendanceHistory(String eventId);

  Future<AttendanceStats> getAttendanceStats(String eventId);
}

class FakeAttendanceRepository implements AttendanceRepository {
  FakeAttendanceRepository({
    Map<String, List<AttendeeInfo>>? initialAttendees,
    Map<String, DateTime>? initialCheckIns,
  })  : _attendees = initialAttendees != null
            ? Map<String, List<AttendeeInfo>>.from(initialAttendees)
            : Map<String, List<AttendeeInfo>>.from(_defaultAttendees),
        _checkIns = initialCheckIns != null
            ? Map<String, DateTime>.from(initialCheckIns)
            : Map<String, DateTime>.from(_defaultCheckIns);

  final Map<String, List<AttendeeInfo>> _attendees;
  final Map<String, DateTime> _checkIns; // ticketCode -> checkInTime
  final List<ScanRecord> _scanHistory = [];

  static final Map<String, List<AttendeeInfo>> _defaultAttendees = {
    'evt_kickoff': [
      const AttendeeInfo(
        name: 'Aarav Sharma',
        rollNumber: '2501640100567',
        department: 'CS',
        year: 3,
        ticketCode: 'HF26-KICK-0567',
        email: 'aarav.sharma@gmail.com',
        colorIndex: 0,
      ),
      const AttendeeInfo(
        name: 'Ishita Verma',
        rollNumber: '2501640100100',
        department: 'CS',
        year: 3,
        ticketCode: 'HF26-KICK-0100',
        email: 'ishita.verma@gmail.com',
        colorIndex: 1,
      ),
      const AttendeeInfo(
        name: 'Kabir Singh',
        rollNumber: '2501640100153',
        department: 'IT',
        year: 3,
        ticketCode: 'HF26-KICK-0153',
        email: 'kabir.singh@gmail.com',
        colorIndex: 2,
      ),
      const AttendeeInfo(
        name: 'Ananya Mishra',
        rollNumber: '2501640100206',
        department: 'ECE',
        year: 2,
        ticketCode: 'HF26-KICK-0206',
        email: 'ananya.mishra@gmail.com',
        colorIndex: 3,
      ),
      const AttendeeInfo(
        name: 'Priya Tripathi',
        rollNumber: '2501640100312',
        department: 'CS',
        year: 3,
        ticketCode: 'HF26-KICK-0312',
        email: 'priya.tripathi@gmail.com',
        colorIndex: 0,
      ),
      const AttendeeInfo(
        name: 'Vivek Yadav',
        rollNumber: '2501640100365',
        department: 'CS',
        year: 4,
        ticketCode: 'HF26-KICK-0365',
        email: 'vivek.yadav@gmail.com',
        colorIndex: 1,
      ),
      const AttendeeInfo(
        name: 'Sanya Khan',
        rollNumber: '2501640100418',
        department: 'IT',
        year: 3,
        ticketCode: 'HF26-KICK-0418',
        email: 'sanya.khan@gmail.com',
        colorIndex: 2,
      ),
    ],
    'evt_flutter': [
      const AttendeeInfo(
        name: 'Aarav Sharma',
        rollNumber: '2501640100567',
        department: 'CS',
        year: 3,
        ticketCode: 'FLTR-W14-0567',
        email: 'aarav.sharma@gmail.com',
        colorIndex: 0,
      ),
      const AttendeeInfo(
        name: 'Rohan Gupta',
        rollNumber: '2501640100259',
        department: 'CS',
        year: 3,
        ticketCode: 'FLTR-W14-0259',
        email: 'rohan.gupta@gmail.com',
        colorIndex: 3,
      ),
    ],
  };

  // Pre-checked in sample: Ishita Verma checked in earlier today
  static final Map<String, DateTime> _defaultCheckIns = {
    'HF26-KICK-0100': DateTime.now().subtract(const Duration(minutes: 35)),
  };

  String _extractTicketCode(String raw) {
    final trimmed = raw.trim();
    // Handle URI style payloads: gdgoc://ticket?code=HF26-KICK-0567
    if (trimmed.contains('code=')) {
      final uri = Uri.tryParse(trimmed);
      if (uri != null && uri.queryParameters.containsKey('code')) {
        return uri.queryParameters['code']!;
      }
    }
    return trimmed;
  }

  @override
  Future<ScanRecord> validateAndMarkAttendance({
    required String eventId,
    required String rawQrCode,
  }) async {
    final ticketCode = _extractTicketCode(rawQrCode);
    final now = DateTime.now();

    // 1. Find if this ticket belongs to any known attendee across events
    AttendeeInfo? attendee;
    String? matchedEventId;

    for (final entry in _attendees.entries) {
      final match = entry.value.where((a) => a.ticketCode.toUpperCase() == ticketCode.toUpperCase());
      if (match.isNotEmpty) {
        attendee = match.first;
        matchedEventId = entry.key;
        break;
      }
    }

    // Ticket code not recognized
    if (attendee == null) {
      final record = ScanRecord(
        ticketCode: ticketCode,
        status: TicketValidationStatus.notFound,
        scannedAt: now,
        errorMessage: 'Ticket code "$ticketCode" was not found in registration database.',
        eventId: eventId,
      );
      _scanHistory.insert(0, record);
      return record;
    }

    // Ticket belongs to a different event
    if (matchedEventId != eventId) {
      final record = ScanRecord(
        ticketCode: ticketCode,
        status: TicketValidationStatus.invalidEvent,
        attendee: attendee,
        scannedAt: now,
        errorMessage: 'This ticket is registered for a different GDGoC event ($matchedEventId).',
        eventId: eventId,
      );
      _scanHistory.insert(0, record);
      return record;
    }

    // Check duplicate check-in
    if (_checkIns.containsKey(attendee.ticketCode)) {
      final priorCheckIn = _checkIns[attendee.ticketCode]!;
      final record = ScanRecord(
        ticketCode: attendee.ticketCode,
        status: TicketValidationStatus.alreadyUsed,
        attendee: attendee,
        scannedAt: now,
        firstScannedAt: priorCheckIn,
        errorMessage: 'Attendance already recorded previously.',
        eventId: eventId,
      );
      _scanHistory.insert(0, record);
      return record;
    }

    // Valid check-in: mark attendance once
    _checkIns[attendee.ticketCode] = now;
    final successRecord = ScanRecord(
      ticketCode: attendee.ticketCode,
      status: TicketValidationStatus.valid,
      attendee: attendee,
      scannedAt: now,
      eventId: eventId,
    );
    _scanHistory.insert(0, successRecord);
    return successRecord;
  }

  @override
  Future<List<ScanRecord>> getAttendanceHistory(String eventId) async {
    return _scanHistory.where((r) => r.eventId == eventId).toList();
  }

  @override
  Future<AttendanceStats> getAttendanceStats(String eventId) async {
    final list = _attendees[eventId] ?? [];
    final total = list.length;
    final checkedIn = list.where((a) => _checkIns.containsKey(a.ticketCode)).length;

    return AttendanceStats(
      eventId: eventId,
      totalRegistered: total > 0 ? total : 147, // default kickoff baseline
      checkedInCount: checkedIn,
    );
  }
}
