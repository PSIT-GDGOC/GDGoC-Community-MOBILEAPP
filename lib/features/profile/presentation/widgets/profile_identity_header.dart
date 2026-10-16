import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/widgets/gdg_avatar.dart';
import '../../../../core/widgets/gdg_button.dart';
import '../../../../core/widgets/gdg_chip.dart';
import '../../domain/models/member_profile.dart';

class ProfileIdentityHeader extends StatelessWidget {
  const ProfileIdentityHeader({
    super.key,
    required this.profile,
    required this.isMentorView,
    required this.onToggleMentorView,
    required this.onEditProfile,
  });

  final MemberProfile profile;
  final bool isMentorView;
  final VoidCallback onToggleMentorView;
  final VoidCallback onEditProfile;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 72dp Avatar matching mockup
        GdgAvatar(
          name: profile.fullName,
          size: GdgAvatarSize.lg,
          colorIndex: 0,
        ),
        const SizedBox(height: GdgSpacing.sp3),

        // Full Name
        Text(
          profile.fullName,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: GdgSpacing.sp1),

        // Roll Number in Monospace font
        Text(
          profile.rollNumber,
          style: GdgTypography.mono(
            context,
            color: colors.onSurface2,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: GdgSpacing.sp2),

        // Clickable GitHub Handle
        InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Opening https://github.com/${profile.githubHandle.replaceAll('@', '')}',
                ),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
          },
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.link_rounded, size: 16, color: colors.primary),
                const SizedBox(width: 4),
                Text(
                  profile.githubHandle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: GdgSpacing.sp3),

        // Actions: Edit profile (Own) vs Mentor View
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isMentorView) ...[
              GdgOutlinedButton(
                onPressed: onEditProfile,
                icon: const Icon(Icons.edit_outlined, size: 16),
                child: const Text('Edit profile'),
              ),
              const SizedBox(width: GdgSpacing.sp2),
            ],
            if (isMentorView) ...[
              const GdgChipAssist(
                label: 'Mentor view',
                tone: GdgChipTone.blue,
                icon: Icon(Icons.visibility_outlined, size: 14),
              ),
              const SizedBox(width: GdgSpacing.sp2),
              GdgOutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Viewing ${profile.githubHandle} on GitHub',
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.open_in_new_rounded, size: 16),
                child: const Text('View on GitHub'),
              ),
              const SizedBox(width: GdgSpacing.sp2),
            ],
            // Quick toggle button for testing between own and mentor perspective
            IconButton(
              tooltip: isMentorView
                  ? 'Switch to Member view'
                  : 'Preview Mentor view',
              icon: Icon(
                isMentorView
                    ? Icons.person_rounded
                    : Icons.supervisor_account_rounded,
                color: colors.onSurface2,
              ),
              onPressed: onToggleMentorView,
            ),
          ],
        ),
      ],
    );
  }
}
