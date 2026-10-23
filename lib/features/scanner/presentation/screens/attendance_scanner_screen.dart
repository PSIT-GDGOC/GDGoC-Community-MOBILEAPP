import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/shapes.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/gdg_chip.dart';
import '../../../core_team/domain/models/manage_event_item.dart';
import '../controllers/scanner_controller.dart';
import '../../domain/models/ticket_validation_result.dart';
import '../widgets/manual_code_dialog.dart';
import '../widgets/scan_history_sheet.dart';
import '../widgets/scan_result_sheet.dart';
import '../widgets/scanner_overlay.dart';

/// Screen 23: Attendance QR Scanner with ticket validation for Core Team organizers.
class AttendanceScannerScreen extends ConsumerStatefulWidget {
  const AttendanceScannerScreen({
    super.key,
    required this.eventId,
    this.initialEvent,
  });

  final String eventId;
  final ManageEventItem? initialEvent;

  @override
  ConsumerState<AttendanceScannerScreen> createState() =>
      _AttendanceScannerScreenState();
}

class _AttendanceScannerScreenState
    extends ConsumerState<AttendanceScannerScreen> {
  MobileScannerController? _scannerController;
  bool _isSheetOpen = false;

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      formats: const [BarcodeFormat.qrCode],
      detectionSpeed: DetectionSpeed.normal,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final title = widget.initialEvent?.title ?? 'Hacktoberfest 2026 Kickoff';
      ref.read(scannerControllerProvider.notifier).initEvent(
            eventId: widget.eventId,
            eventTitle: title,
          );
    });
  }

  @override
  void dispose() {
    _scannerController?.dispose();
    super.dispose();
  }

  Future<void> _handleBarcodeDetected(String rawCode) async {
    if (_isSheetOpen) return;

    final controller = ref.read(scannerControllerProvider.notifier);
    final record = await controller.processBarcode(rawCode);

    if (!mounted) return;
    _showResult(record);
  }

  void _showResult(ScanRecord record) {
    setState(() => _isSheetOpen = true);

    ScanResultSheet.show(
      context,
      record: record,
      onScanNext: () {
        if (mounted) {
          setState(() => _isSheetOpen = false);
          ref.read(scannerControllerProvider.notifier).clearLastScan();
        }
      },
    ).then((_) {
      if (mounted) {
        setState(() => _isSheetOpen = false);
        ref.read(scannerControllerProvider.notifier).clearLastScan();
      }
    });
  }

  void _openManualEntry() {
    ManualCodeDialog.show(
      context,
      onSubmit: (code) => _handleBarcodeDetected(code),
    );
  }

  void _openHistory(List<ScanRecord> history) {
    ScanHistorySheet.show(context, history: history);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;
    final state = ref.watch(scannerControllerProvider);
    final stats = state.stats;

    final checkedIn = stats?.checkedInCount ?? 1;
    final total = stats?.totalRegistered ?? 147;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Camera Feed
          _buildCameraFeed(),

          // Material 3 Viewfinder Overlay
          const ScannerOverlay(),

          // Top Navigation & Stats Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildTopBar(context, colors, checkedIn, total),
          ),

          // Bottom Control Actions Toolbar
          Positioned(
            bottom: 32,
            left: 20,
            right: 20,
            child: _buildBottomControls(context, colors, state),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraFeed() {
    return MobileScanner(
      controller: _scannerController,
      onDetect: (capture) {
        final barcodes = capture.barcodes;
        for (final barcode in barcodes) {
          final code = barcode.rawValue;
          if (code != null && code.isNotEmpty) {
            _handleBarcodeDetected(code);
            break;
          }
        }
      },
      errorBuilder: (context, error) {
        return Container(
          color: Colors.black87,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(GdgSpacing.sp4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.videocam_off_outlined, color: Colors.white54, size: 48),
              const SizedBox(height: GdgSpacing.sp2),
              const Text(
                'Camera simulator or permission needed',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: GdgSpacing.sp2),
              TextButton(
                onPressed: _openManualEntry,
                child: const Text('Use Manual Ticket Entry'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopBar(
    BuildContext context,
    GdgColors colors,
    int checkedIn,
    int total,
  ) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: GdgSpacing.sp3,
        right: GdgSpacing.sp4,
        bottom: GdgSpacing.sp3,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.8),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: GdgSpacing.sp1),

          // Event Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.initialEvent?.title ?? 'Hacktoberfest 2026 Kickoff',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Core Team Attendance Scanner',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: GdgSpacing.sp2),

          // Attendance Counter Badge
          GdgChipAssist(
            label: '$checkedIn / $total',
            tone: GdgChipTone.green,
            icon: const Icon(Icons.how_to_reg, size: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls(
    BuildContext context,
    GdgColors colors,
    ScannerState state,
  ) {
    final controller = ref.read(scannerControllerProvider.notifier);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF202124).withValues(alpha: 0.85),
        borderRadius: GdgShapes.full,
        border: Border.all(color: Colors.white24, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Torch Button
          _ActionButton(
            icon: state.isTorchOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
            label: 'Torch',
            isActive: state.isTorchOn,
            onTap: () {
              controller.toggleTorch();
              _scannerController?.toggleTorch();
            },
          ),

          // Flip Camera Button
          _ActionButton(
            icon: Icons.flip_camera_ios_outlined,
            label: 'Flip',
            onTap: () {
              controller.toggleCameraFacing();
              _scannerController?.switchCamera();
            },
          ),

          // Manual Code Entry
          _ActionButton(
            icon: Icons.keyboard_outlined,
            label: 'Type Code',
            onTap: _openManualEntry,
          ),

          // Scanned History
          Stack(
            clipBehavior: Clip.none,
            children: [
              _ActionButton(
                icon: Icons.history_rounded,
                label: 'History',
                onTap: () => _openHistory(state.scanHistory),
              ),
              if (state.scanHistory.isNotEmpty)
                Positioned(
                  top: -2,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: colors.brandBlue,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '${state.scanHistory.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: GdgShapes.full,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? const Color(0xFF4285F4) : Colors.white,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? const Color(0xFF4285F4) : Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
