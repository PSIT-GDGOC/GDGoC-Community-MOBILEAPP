import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/attendance_repository.dart';
import '../../domain/models/ticket_validation_result.dart';

class ScannerState {
  const ScannerState({
    this.eventId = 'evt_kickoff',
    this.eventTitle = 'Hacktoberfest 2026 Kickoff',
    this.isTorchOn = false,
    this.isFrontCamera = false,
    this.isProcessing = false,
    this.lastScan,
    this.stats,
    this.scanHistory = const [],
    this.errorMessage,
  });

  final String eventId;
  final String eventTitle;
  final bool isTorchOn;
  final bool isFrontCamera;
  final bool isProcessing;
  final ScanRecord? lastScan;
  final AttendanceStats? stats;
  final List<ScanRecord> scanHistory;
  final String? errorMessage;

  ScannerState copyWith({
    String? eventId,
    String? eventTitle,
    bool? isTorchOn,
    bool? isFrontCamera,
    bool? isProcessing,
    ScanRecord? lastScan,
    bool clearLastScan = false,
    AttendanceStats? stats,
    List<ScanRecord>? scanHistory,
    String? errorMessage,
  }) {
    return ScannerState(
      eventId: eventId ?? this.eventId,
      eventTitle: eventTitle ?? this.eventTitle,
      isTorchOn: isTorchOn ?? this.isTorchOn,
      isFrontCamera: isFrontCamera ?? this.isFrontCamera,
      isProcessing: isProcessing ?? this.isProcessing,
      lastScan: clearLastScan ? null : (lastScan ?? this.lastScan),
      stats: stats ?? this.stats,
      scanHistory: scanHistory ?? this.scanHistory,
      errorMessage: errorMessage,
    );
  }
}

final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  return FakeAttendanceRepository();
});

final scannerControllerProvider =
    NotifierProvider<ScannerController, ScannerState>(ScannerController.new);

class ScannerController extends Notifier<ScannerState> {
  @override
  ScannerState build() {
    return const ScannerState();
  }

  AttendanceRepository get _repository => ref.read(attendanceRepositoryProvider);

  Future<void> initEvent({
    required String eventId,
    required String eventTitle,
  }) async {
    state = state.copyWith(
      eventId: eventId,
      eventTitle: eventTitle,
      clearLastScan: true,
    );
    await refreshStats();
  }

  Future<void> refreshStats() async {
    try {
      final stats = await _repository.getAttendanceStats(state.eventId);
      final history = await _repository.getAttendanceHistory(state.eventId);
      state = state.copyWith(stats: stats, scanHistory: history);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<ScanRecord> processBarcode(String rawCode) async {
    if (state.isProcessing) {
      return state.lastScan!;
    }

    state = state.copyWith(isProcessing: true, errorMessage: null);

    try {
      final record = await _repository.validateAndMarkAttendance(
        eventId: state.eventId,
        rawQrCode: rawCode,
      );

      final stats = await _repository.getAttendanceStats(state.eventId);
      final history = await _repository.getAttendanceHistory(state.eventId);

      state = state.copyWith(
        isProcessing: false,
        lastScan: record,
        stats: stats,
        scanHistory: history,
      );
      return record;
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        errorMessage: e.toString(),
      );
      rethrow;
    }
  }

  void toggleTorch() {
    state = state.copyWith(isTorchOn: !state.isTorchOn);
  }

  void toggleCameraFacing() {
    state = state.copyWith(isFrontCamera: !state.isFrontCamera);
  }

  void clearLastScan() {
    state = state.copyWith(clearLastScan: true);
  }
}
