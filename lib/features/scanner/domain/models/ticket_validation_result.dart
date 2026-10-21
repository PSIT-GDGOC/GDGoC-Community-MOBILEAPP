enum TicketValidationStatus {
  valid,
  alreadyUsed,
  invalidEvent,
  notFound;

  String get title => switch (this) {
        TicketValidationStatus.valid => 'Attendance Marked',
        TicketValidationStatus.alreadyUsed => 'Already Checked In',
        TicketValidationStatus.invalidEvent => 'Wrong Event Ticket',
        TicketValidationStatus.notFound => 'Invalid Ticket Code',
      };

  bool get isSuccess => this == TicketValidationStatus.valid;
}

/// Information about the ticket holder (Member)
class AttendeeInfo {
  const AttendeeInfo({
    required this.name,
    required this.rollNumber,
    required this.department,
    required this.year,
    required this.ticketCode,
    this.email = '',
    this.colorIndex = 0,
  });

  final String name;
  final String rollNumber;
  final String department;
  final int year;
  final String ticketCode;
  final String email;
  final int colorIndex;

  String get academicInfo => '$department · ${year}rd Year';
}

/// A completed attendance scan record
class ScanRecord {
  const ScanRecord({
    required this.ticketCode,
    required this.status,
    this.attendee,
    required this.scannedAt,
    this.firstScannedAt,
    this.errorMessage,
    this.eventId = '',
    this.eventTitle = '',
  });

  final String ticketCode;
  final TicketValidationStatus status;
  final AttendeeInfo? attendee;
  final DateTime scannedAt;
  final DateTime? firstScannedAt;
  final String? errorMessage;
  final String eventId;
  final String eventTitle;

  bool get isSuccess => status == TicketValidationStatus.valid;
}

/// Attendance metrics for an event
class AttendanceStats {
  const AttendanceStats({
    required this.eventId,
    required this.totalRegistered,
    required this.checkedInCount,
  });

  final String eventId;
  final int totalRegistered;
  final int checkedInCount;

  double get percentage =>
      totalRegistered > 0 ? (checkedInCount / totalRegistered).clamp(0.0, 1.0) : 0.0;

  String get summaryText => '$checkedInCount of $totalRegistered checked in';
}
