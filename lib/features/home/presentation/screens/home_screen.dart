import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/gdg_logo.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/home_controller.dart';
import '../widgets/activity_grid.dart';
import '../widgets/board_card.dart';
import '../widgets/events_strip.dart';
import '../widgets/project_shortcuts.dart';

/// Screen 05: Member Home Screen with Chapter Leaderboard ("Board").
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeControllerProvider);
    final user = ref.watch(authControllerProvider).user;
    final firstName = user?.name.split(' ').first ?? 'Aarav';

    if (homeState.isLoading) {
      return const Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: _HomeAppBar(),
        ),
        body: LoadingStateView(),
      );
    }

    if (homeState.errorMessage != null) {
      return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: _HomeAppBar(),
        ),
        body: ErrorStateView(
          title: "Couldn't load chapter updates",
          message: homeState.errorMessage!,
          onRetry: () => ref.read(homeControllerProvider.notifier).loadHomeData(),
        ),
      );
    }

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: _HomeAppBar(),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(homeControllerProvider.notifier).loadHomeData(),
          child: ListView(
            padding: GdgSpacing.screenPadding,
            children: [
              // Personalized Greeting
              Text(
                'Good morning, $firstName',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: GdgSpacing.sp4),

              // Board Hero Card
              BoardCard(
                userRank: homeState.userRank,
                userPoints: homeState.userPoints,
                entries: homeState.boardEntries,
                isExpanded: homeState.isBoardExpanded,
                selectedFilter: homeState.selectedFilter,
                onToggleExpand: () =>
                    ref.read(homeControllerProvider.notifier).toggleBoardExpansion(),
                onFilterSelected: (filter) =>
                    ref.read(homeControllerProvider.notifier).setFilter(filter),
              ),
              const SizedBox(height: GdgSpacing.sp6),

              // Events Strip
              EventsStrip(
                events: homeState.events,
                onSeeAllPressed: () => context.go('/member/events'),
                onViewTicketPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ticket: HF26-KICK-0567 · Sat 10 Oct'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                onEventTapped: (evt) => context.go('/member/events'),
              ),
              const SizedBox(height: GdgSpacing.sp6),

              // Projects Shortcuts
              ProjectShortcutsStrip(
                projects: homeState.projects,
                onProjectTapped: (prj) => context.go('/member/projects'),
              ),
              const SizedBox(height: GdgSpacing.sp6),

              // Activity Grid
              ActivityGrid(activities: homeState.activities),
              const SizedBox(height: GdgSpacing.sp6),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeAppBar extends StatelessWidget {
  const _HomeAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const GdgLogo(),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded),
          tooltip: 'Notifications',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No new notifications'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
      ],
    );
  }
}
