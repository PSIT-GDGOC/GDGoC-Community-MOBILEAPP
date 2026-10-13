import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import 'gdg_button.dart';
import 'gdg_card.dart';
import 'gdg_chip.dart';
import 'gdg_logo.dart';
import '../../features/auth/domain/models/auth_user.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';

/// Screen displayed inside shell tabs until their dedicated feature issues are implemented.
class TabPlaceholderScreen extends ConsumerWidget {
  const TabPlaceholderScreen({
    super.key,
    required this.title,
    required this.role,
    this.issueNumber,
  });

  final String title;
  final UserRole role;
  final int? issueNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.gdgColors;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const GdgLogo(),
            const SizedBox(width: GdgSpacing.sp3),
            Text(title),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Sign Out',
            onPressed: () {
              ref.read(authControllerProvider.notifier).reset();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: GdgSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GdgCard(
                isHero: true,
                tint: switch (role) {
                  UserRole.member => GdgCardTint.blue,
                  UserRole.coreTeam => GdgCardTint.yellow,
                  UserRole.mentor => GdgCardTint.green,
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GdgChipAssist(
                          label: role.displayName,
                          tone: switch (role) {
                            UserRole.member => GdgChipTone.blue,
                            UserRole.coreTeam => GdgChipTone.yellow,
                            UserRole.mentor => GdgChipTone.green,
                          },
                        ),
                        if (issueNumber != null) ...[
                          const SizedBox(width: GdgSpacing.sp2),
                          GdgChipAssist(
                            label: 'Issue #$issueNumber',
                            tone: GdgChipTone.neutral,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: GdgSpacing.sp3),
                    Text(
                      '$title Portal',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: GdgSpacing.sp2),
                    Text(
                      'Shell container and navigation routing active. Feature interface planned for Issue #${issueNumber ?? "TBD"}.',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: colors.onSurface2,
                          ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GdgOutlinedButton(
                isSmall: false,
                onPressed: () {
                  ref.read(authControllerProvider.notifier).reset();
                },
                child: const Text('Sign Out / Test Auth Flow'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
