import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/shapes.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/gdg_avatar.dart';
import '../../../../core/widgets/gdg_button.dart';
import '../../../../core/widgets/gdg_chip.dart';
import '../../domain/models/ticket_validation_result.dart';

/// Modal bottom sheet displaying detailed attendance validation feedback.
class ScanResultSheet extends StatelessWidget {
  const ScanResultSheet({
    super.key,
    required this.record,
    required this.onScanNext,
  });

  final ScanRecord record;
  final VoidCallback onScanNext;

  static Future<void> show(
    BuildContext context, {
    required ScanRecord record,
    required VoidCallback onScanNext,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ScanResultSheet(
        record: record,
        onScanNext: onScanNext,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;
    final timeFormat = DateFormat('hh:mm a');

    return Material(
      color: colors.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            GdgSpacing.sp5,
            GdgSpacing.sp3,
            GdgSpacing.sp5,
            GdgSpacing.sp6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Handle Bar
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: GdgSpacing.sp4),
                decoration: BoxDecoration(
                  color: colors.outline,
                  borderRadius: GdgShapes.full,
                ),
              ),

              // Status Icon & Title
              _buildStatusHeader(context, colors),
              const SizedBox(height: GdgSpacing.sp4),

              // Content based on status
              if (record.status == TicketValidationStatus.valid)
                _buildValidAttendeeCard(context, colors, timeFormat)
              else if (record.status == TicketValidationStatus.alreadyUsed)
                _buildDuplicateCard(context, colors, timeFormat)
              else
                _buildErrorCard(context, colors),

              const SizedBox(height: GdgSpacing.sp6),

              // Action Button
              GdgFilledButton(
                isWide: true,
                onPressed: () {
                  Navigator.of(context).pop();
                  onScanNext();
                },
                child: Text(
                  record.status.isSuccess ? 'Scan Next Attendee' : 'Dismiss & Continue',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusHeader(BuildContext context, GdgColors colors) {
    final (Color bg, Color fg, IconData icon) = switch (record.status) {
      TicketValidationStatus.valid => (
          colors.tintGreen,
          colors.onTintGreen,
          Icons.check_circle_rounded,
        ),
      TicketValidationStatus.alreadyUsed => (
          colors.tintYellow,
          colors.onTintAmber,
          Icons.warning_rounded,
        ),
      TicketValidationStatus.invalidEvent ||
      TicketValidationStatus.notFound => (
          colors.tintRed,
          colors.onTintRed,
          Icons.cancel_rounded,
        ),
    };

    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: bg,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: fg, size: 32),
        ),
        const SizedBox(height: GdgSpacing.sp2),
        Text(
          record.status.title,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
        ),
      ],
    );
  }

  Widget _buildValidAttendeeCard(
    BuildContext context,
    GdgColors colors,
    DateFormat timeFormat,
  ) {
    final attendee = record.attendee!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(GdgSpacing.sp4),
      decoration: BoxDecoration(
        color: colors.surfaceAlt,
        borderRadius: GdgShapes.lg,
        border: Border.all(color: colors.outline, width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GdgAvatar(
                name: attendee.name,
                colorIndex: attendee.colorIndex,
                size: GdgAvatarSize.lg,
              ),
              const SizedBox(width: GdgSpacing.sp4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      attendee.name,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      attendee.rollNumber,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontFamily: 'monospace',
                            color: colors.onSurface2,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: GdgSpacing.sp2),
                    Wrap(
                      spacing: 6,
                      children: [
                        GdgChipAssist(
                          label: attendee.academicInfo,
                          tone: GdgChipTone.blue,
                        ),
                        GdgChipAssist(
                          label: attendee.ticketCode,
                          tone: GdgChipTone.neutral,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: GdgSpacing.sp3),
          Divider(color: colors.outline, height: 1),
          const SizedBox(height: GdgSpacing.sp3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Checked in at',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: colors.onSurface3,
                    ),
              ),
              Text(
                timeFormat.format(record.scannedAt),
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colors.onSurface2,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDuplicateCard(
    BuildContext context,
    GdgColors colors,
    DateFormat timeFormat,
  ) {
    final attendee = record.attendee;
    final firstTime = record.firstScannedAt != null
        ? timeFormat.format(record.firstScannedAt!)
        : 'earlier today';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(GdgSpacing.sp4),
      decoration: BoxDecoration(
        color: colors.tintYellow,
        borderRadius: GdgShapes.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history, color: colors.onTintAmber, size: 20),
              const SizedBox(width: GdgSpacing.sp2),
              Expanded(
                child: Text(
                  'Original Check-in: $firstTime',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: colors.onTintAmber,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: GdgSpacing.sp2),
          Text(
            'This ticket has already been validated. Each ticket can mark attendance only once.',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: colors.onTintAmber,
                ),
          ),
          if (attendee != null) ...[
            const SizedBox(height: GdgSpacing.sp3),
            Divider(color: colors.outline, height: 1),
            const SizedBox(height: GdgSpacing.sp3),
            Text(
              attendee.name,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              '${attendee.rollNumber} · ${attendee.ticketCode}',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontFamily: 'monospace',
                    color: colors.onSurface2,
                  ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, GdgColors colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(GdgSpacing.sp4),
      decoration: BoxDecoration(
        color: colors.tintRed,
        borderRadius: GdgShapes.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            record.errorMessage ?? 'The scanned QR code is not valid for this event.',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: colors.onTintRed,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: GdgSpacing.sp2),
          Text(
            'Scanned code: ${record.ticketCode}',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontFamily: 'monospace',
                  color: colors.onTintRed.withValues(alpha: 0.8),
                ),
          ),
        ],
      ),
    );
  }
}
