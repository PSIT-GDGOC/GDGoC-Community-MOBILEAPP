import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/shapes.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/widgets/gdg_card.dart';
import '../../../../core/widgets/gdg_logo.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/models/member_profile.dart';
import '../controllers/profile_controller.dart';
import '../widgets/badges_skills_section.dart';
import '../widgets/contribution_timeline_card.dart';
import '../widgets/profile_identity_header.dart';
import '../widgets/profile_statistics_bar.dart';
import '../widgets/ticket_preview_dialog.dart';

/// Screen 11: Member Profile Screen structured into 5 distinct sections.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  void _showEditProfileDialog(MemberProfile profile) {
    final nameController = TextEditingController(text: profile.fullName);
    final githubController = TextEditingController(text: profile.githubHandle);

    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: GdgShapes.lg),
          title: const Text('Edit Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: GdgSpacing.sp3),
              TextField(
                controller: githubController,
                decoration: const InputDecoration(
                  labelText: 'GitHub Handle',
                  hintText: '@username',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final name = nameController.text.trim();
                final gh = githubController.text.trim();
                if (name.isNotEmpty && gh.isNotEmpty) {
                  ref
                      .read(profileControllerProvider.notifier)
                      .updateIdentity(fullName: name, githubHandle: gh);
                }
                Navigator.of(ctx).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showTicketDialog(MemberProfile profile) {
    if (profile.currentTicket == null) return;
    showDialog<void>(
      context: context,
      builder: (_) =>
          TicketPreviewDialog(ticket: profile.currentTicket!, profile: profile),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;
    final state = ref.watch(profileControllerProvider);
    final profile = state.profile;

    if (state.isLoading || profile == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Row(
            children: [
              GdgLogo(),
              SizedBox(width: GdgSpacing.sp3),
              Text('Profile'),
            ],
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final sortedContributions = profile.chronologicallySortedContributions;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const GdgLogo(),
            const SizedBox(width: GdgSpacing.sp3),
            Text(
              'Profile',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            tooltip: 'Share profile',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Sharing ${profile.fullName}\'s GDGoC PSIT profile!',
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Sign out',
            onPressed: () {
              ref.read(authControllerProvider.notifier).reset();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: GdgSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. SECTION 1: Identity Header
              ProfileIdentityHeader(
                profile: profile,
                isMentorView: state.isMentorView,
                onToggleMentorView: () {
                  ref
                      .read(profileControllerProvider.notifier)
                      .toggleMentorView();
                },
                onEditProfile: () => _showEditProfileDialog(profile),
              ),
              const SizedBox(height: GdgSpacing.sp5),

              // 2. SECTION 2: 3-Column Statistics Bar (Merged PRs, Open PRs, Rank)
              ProfileStatisticsBar(profile: profile),
              const SizedBox(height: GdgSpacing.sp5),

              // 3. SECTION 3: Badges & Skill Chips
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Achievements & Skills',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors.onSurface,
                    ),
                  ),
                  Text(
                    '${profile.badges.where((b) => b.isUnlocked).length} badges',
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: colors.onSurface3),
                  ),
                ],
              ),
              const SizedBox(height: GdgSpacing.sp2),
              BadgesSkillsSection(
                badges: profile.badges,
                skillChips: profile.skillChips,
                onAddSkill: (skill) {
                  ref.read(profileControllerProvider.notifier).addSkill(skill);
                },
                onRemoveSkill: (skill) {
                  ref
                      .read(profileControllerProvider.notifier)
                      .removeSkill(skill);
                },
              ),
              const SizedBox(height: GdgSpacing.sp5),

              // 4. SECTION 4: Interactive Contribution Timeline (Chronologically Sorted)
              Row(
                children: [
                  Text(
                    'Contribution Timeline',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(width: GdgSpacing.sp2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: colors.tintBlue,
                      borderRadius: GdgShapes.full,
                    ),
                    child: Text(
                      'Chronological',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: colors.onTintBlue,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: GdgSpacing.sp1),
              Text(
                'Tap nodes or cycle to update 3-step contribution progress',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: colors.onSurface3),
              ),
              const SizedBox(height: GdgSpacing.sp3),

              ...sortedContributions.map((contribution) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: GdgSpacing.sp3),
                  child: ContributionTimelineCard(
                    contribution: contribution,
                    onAdvanceStage: () {
                      ref
                          .read(profileControllerProvider.notifier)
                          .advanceContributionStage(contribution.id);
                    },
                    onSelectStage: (stage) {
                      ref
                          .read(profileControllerProvider.notifier)
                          .setContributionStage(contribution.id, stage);
                    },
                  ),
                );
              }),

              const SizedBox(height: GdgSpacing.sp4),

              // 5. SECTION 5: Preferences & Active Ticket (Own Profile Only)
              if (!state.isMentorView) ...[
                Text(
                  'Current Pass & Settings',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: GdgSpacing.sp3),

                // Active Ticket Card
                if (profile.currentTicket != null)
                  GdgCard(
                    onTap: () => _showTicketDialog(profile),
                    padding: const EdgeInsets.all(GdgSpacing.sp4),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: colors.tintBlue,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.confirmation_number_rounded,
                            color: colors.brandBlue,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: GdgSpacing.sp3),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile.currentTicket!.eventName,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                profile.currentTicket!.ticketCode,
                                style: GdgTypography.mono(
                                  context,
                                  color: colors.onSurface2,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.qr_code_2_rounded,
                          color: colors.primary,
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: GdgSpacing.sp3),

                // Settings Card with Switches
                GdgCard(
                  padding: const EdgeInsets.all(GdgSpacing.sp2),
                  child: Material(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        SwitchListTile(
                          value: profile.notificationsEnabled,
                          activeThumbColor: colors.primary,
                          title: const Text('Notifications'),
                          subtitle: const Text(
                            'Event reminders & review notifications',
                          ),
                          secondary: Icon(
                            Icons.notifications_outlined,
                            color: colors.onSurface2,
                          ),
                          onChanged: (val) {
                            ref
                                .read(profileControllerProvider.notifier)
                                .toggleNotifications(val);
                          },
                        ),
                        const Divider(height: 1),
                        SwitchListTile(
                          value: profile.privacyEnabled,
                          activeThumbColor: colors.primary,
                          title: const Text('Privacy'),
                          subtitle: const Text(
                            'Profile visible to chapter mentors',
                          ),
                          secondary: Icon(
                            Icons.lock_outline_rounded,
                            color: colors.onSurface2,
                          ),
                          onChanged: (val) {
                            ref
                                .read(profileControllerProvider.notifier)
                                .togglePrivacy(val);
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: GdgSpacing.sp4),

                // Sign Out Row
                GdgCard(
                  onTap: () {
                    ref.read(authControllerProvider.notifier).reset();
                  },
                  padding: const EdgeInsets.all(GdgSpacing.sp3),
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout_rounded,
                        color: colors.brandRed,
                        size: 20,
                      ),
                      const SizedBox(width: GdgSpacing.sp3),
                      Text(
                        'Sign out',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: colors.brandRed,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: GdgSpacing.sp6),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
