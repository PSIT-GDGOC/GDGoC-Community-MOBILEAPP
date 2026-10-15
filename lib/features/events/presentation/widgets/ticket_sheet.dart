import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/shapes.dart';
import '../../../../core/theme/spacing.dart';
import '../../domain/models/event_item.dart';

class TicketSheet extends StatelessWidget {
  const TicketSheet({
    super.key,
    required this.event,
    required this.userName,
    required this.userRoll,
  });

  final EventItem event;
  final String userName;
  final String userRoll;

  static void show(
    BuildContext context, {
    required EventItem event,
    required String userName,
    required String userRoll,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TicketSheet(
        event: event,
        userName: userName,
        userRoll: userRoll,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;
    final last4 = userRoll.length >= 4 ? userRoll.substring(userRoll.length - 4) : '0567';
    final ticketCode = event.ticketCode ?? '${event.eventCode}-$last4';

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(
        GdgSpacing.sp5,
        GdgSpacing.sp3,
        GdgSpacing.sp5,
        GdgSpacing.sp8,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Handle bar
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: GdgSpacing.sp4),
              decoration: BoxDecoration(
                color: colors.outline,
                borderRadius: GdgShapes.full,
              ),
            ),

            // Header status
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: colors.tintGreen,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: colors.onTintGreen,
                    size: 20,
                  ),
                ),
                const SizedBox(width: GdgSpacing.sp3),
                Text(
                  "You're registered",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: GdgSpacing.sp4),

            // Ticket QR Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(GdgSpacing.sp4),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: GdgShapes.lg,
                border: Border.all(
                  color: colors.outline,
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  // QR Container
                  Container(
                    padding: const EdgeInsets.all(GdgSpacing.sp3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: GdgShapes.md,
                      border: Border.all(color: colors.outline, width: 1),
                    ),
                    child: QrImageView(
                      data: ticketCode,
                      version: QrVersions.auto,
                      size: 180.0,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: Color(0xFF202124),
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: Color(0xFF202124),
                      ),
                    ),
                  ),
                  const SizedBox(height: GdgSpacing.sp3),

                  // Name
                  Text(
                    userName,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 2),

                  // Roll number & ticket ID
                  Text(
                    '$userRoll · $ticketCode',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontFamily: 'monospace',
                          color: colors.onSurface2,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: GdgSpacing.sp2),
                  Text(
                    '${event.title} · ${event.date}',
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: colors.onSurface3,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: GdgSpacing.sp5),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: ticketCode));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Ticket code copied: $ticketCode'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.download_rounded, size: 18),
                    label: const Text('Save ticket'),
                  ),
                ),
                const SizedBox(width: GdgSpacing.sp3),
                TextButton.icon(
                  onPressed: () {
                    // ignore: deprecated_member_use
                    Share.share(
                      'I registered for ${event.title} at GDG on Campus PSIT! Ticket: $ticketCode',
                    );
                  },
                  icon: const Icon(Icons.share_outlined, size: 18),
                  label: const Text('Share'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
