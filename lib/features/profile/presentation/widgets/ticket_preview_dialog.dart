import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/shapes.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/widgets/gdg_button.dart';
import '../../domain/models/member_profile.dart';

class TicketPreviewDialog extends StatelessWidget {
  const TicketPreviewDialog({
    super.key,
    required this.ticket,
    required this.profile,
  });

  final EventTicket ticket;
  final MemberProfile profile;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;

    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: GdgShapes.xl),
      backgroundColor: colors.surface,
      insetPadding: const EdgeInsets.all(GdgSpacing.sp4),
      child: Padding(
        padding: const EdgeInsets.all(GdgSpacing.sp5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(Icons.confirmation_number_rounded, color: colors.primary),
                const SizedBox(width: GdgSpacing.sp2),
                Text(
                  'Event Pass',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
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

            // QR Code Container
            Container(
              padding: const EdgeInsets.all(GdgSpacing.sp3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: GdgShapes.lg,
                border: Border.all(color: colors.outline, width: 1),
                boxShadow: [
                  const BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: QrImageView(
                data: ticket.qrData ?? ticket.ticketCode,
                version: QrVersions.auto,
                size: 180,
                eyeStyle: QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: colors.onSurface,
                ),
                dataModuleStyle: QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: colors.onSurface,
                ),
              ),
            ),
            const SizedBox(height: GdgSpacing.sp4),

            Text(
              ticket.eventName,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: GdgSpacing.sp1),

            // Ticket Code in Monospace
            Text(
              ticket.ticketCode,
              style: GdgTypography.mono(
                context,
                color: colors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: GdgSpacing.sp3),

            Container(
              padding: const EdgeInsets.all(GdgSpacing.sp3),
              decoration: BoxDecoration(
                color: colors.surfaceAlt,
                borderRadius: GdgShapes.md,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Attendee',
                        style: TextStyle(
                          color: colors.onSurface2,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        profile.fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Roll No.',
                        style: TextStyle(
                          color: colors.onSurface2,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        profile.rollNumber,
                        style: GdgTypography.mono(context, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Date',
                        style: TextStyle(
                          color: colors.onSurface2,
                          fontSize: 12,
                        ),
                      ),
                      Text(ticket.date, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Venue',
                        style: TextStyle(
                          color: colors.onSurface2,
                          fontSize: 12,
                        ),
                      ),
                      Text(ticket.venue, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: GdgSpacing.sp4),

            GdgFilledButton(
              isWide: true,
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Ticket saved to wallet'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Save Ticket to Device'),
            ),
          ],
        ),
      ),
    );
  }
}
