import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/shapes.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/gdg_avatar.dart';
import '../../../../core/widgets/gdg_chip.dart';
import '../../domain/models/ticket_validation_result.dart';

/// Sheet displaying recently scanned attendee passes.
class ScanHistorySheet extends StatelessWidget {
  const ScanHistorySheet({
    super.key,
    required this.history,
  });

  final List<ScanRecord> history;

  static Future<void> show(
    BuildContext context, {
    required List<ScanRecord> history,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ScanHistorySheet(history: history),
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
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: GdgSpacing.sp5,
            vertical: GdgSpacing.sp3,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: GdgSpacing.sp3),
                  decoration: BoxDecoration(
                    color: colors.outline,
                    borderRadius: GdgShapes.full,
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    'Session Scans (${history.length})',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: GdgSpacing.sp3),
              if (history.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(GdgSpacing.sp8),
                  child: Center(
                    child: Text(
                      'No tickets scanned yet in this session.',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: colors.onSurface3,
                          ),
                    ),
                  ),
                )
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: history.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      color: colors.surfaceAlt,
                    ),
                    itemBuilder: (context, index) {
                      final item = history[index];
                      final attendee = item.attendee;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: GdgSpacing.sp3,
                        ),
                        child: Row(
                          children: [
                            GdgAvatar(
                              name: attendee?.name ?? '?',
                              colorIndex: attendee?.colorIndex ?? 0,
                              size: GdgAvatarSize.md,
                            ),
                            const SizedBox(width: GdgSpacing.sp3),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    attendee?.name ?? item.ticketCode,
                                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  Text(
                                    attendee?.rollNumber ?? 'Unknown roll',
                                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                          fontFamily: 'monospace',
                                          color: colors.onSurface2,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GdgChipAssist(
                                  label: item.status.title,
                                  tone: item.status.isSuccess
                                      ? GdgChipTone.green
                                      : GdgChipTone.red,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  timeFormat.format(item.scannedAt),
                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                        color: colors.onSurface3,
                                        fontSize: 10,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
