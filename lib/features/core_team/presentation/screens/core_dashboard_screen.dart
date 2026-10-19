import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/shapes.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/gdg_logo.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../home/presentation/widgets/board_card.dart';
import '../controllers/core_dashboard_controller.dart';
import '../widgets/attention_section.dart';
import '../widgets/create_edit_event_sheet.dart';
import '../widgets/kpi_card_grid.dart';
import '../widgets/team_summary_card.dart';

/// Screen 12: Organizer Dashboard for Core Team.
class CoreDashboardScreen extends ConsumerWidget {
  const CoreDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(coreDashboardControllerProvider);
    final controller = ref.read(coreDashboardControllerProvider.notifier);
    final colors = context.gdgColors;

    if (state.isLoading) {
      return Scaffold(
        appBar: const _CoreDashboardAppBar(),
        body: const LoadingStateView(),
      );
    }

    if (state.errorMessage != null) {
      return Scaffold(
        appBar: const _CoreDashboardAppBar(),
        body: ErrorStateView(
          title: "Couldn't load dashboard",
          message: state.errorMessage!,
          onRetry: () => controller.loadDashboard(),
        ),
      );
    }

    return Scaffold(
      appBar: const _CoreDashboardAppBar(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => controller.loadDashboard(),
          child: ListView(
            padding: GdgSpacing.screenPadding,
            children: [
              // 4 KPI Cards (Upcoming events, Registered students, Projects, Merged PRs)
              KpiCardGrid(
                kpis: state.kpis,
                onKpiTap: (kpi) {
                  if (kpi.label.contains('events')) {
                    context.go('/core/events');
                  } else if (kpi.label.contains('Projects') || kpi.label.contains('PRs')) {
                    context.go('/core/projects');
                  } else if (kpi.label.contains('students')) {
                    context.go('/core/members');
                  }
                },
              ),
              const SizedBox(height: GdgSpacing.sp6),

              // "Needs your attention"
              AttentionSection(
                items: state.attentionItems,
                onItemTap: (item) {
                  if (item.route != null) {
                    context.go(item.route!);
                  }
                },
              ),
              const SizedBox(height: GdgSpacing.sp6),

              // The Board (Chapter Leaderboard)
              BoardCard(
                userRank: state.userRank,
                userPoints: state.userPoints,
                entries: state.boardEntries,
                isExpanded: state.isBoardExpanded,
                selectedFilter: state.selectedBoardFilter,
                onToggleExpand: () => controller.toggleBoardExpansion(),
                onFilterSelected: (filter) => controller.setBoardFilter(filter),
              ),
              const SizedBox(height: GdgSpacing.sp6),

              // Team Card
              TeamSummaryCard(
                members: state.teamMembers,
                totalCount: state.totalTeamCount,
                onTap: () => context.go('/core/members'),
              ),
              const SizedBox(height: 96), // Clearance for FAB
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFab(context, colors),
    );
  }

  Widget _buildFab(BuildContext context, GdgColors colors) {
    return Container(
      margin: const EdgeInsets.only(bottom: GdgSpacing.sp2),
      child: FloatingActionButton.extended(
        elevation: 3,
        highlightElevation: 1,
        backgroundColor: colors.tintBlue,
        foregroundColor: colors.onTintBlue,
        shape: const RoundedRectangleBorder(borderRadius: GdgShapes.lg),
        icon: const Icon(Icons.add_rounded),
        label: Text(
          'New',
          style: TextStyle(
            color: colors.onTintBlue,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () => _showQuickActionSheet(context),
      ),
    );
  }

  void _showQuickActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(GdgSpacing.sp5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: GdgSpacing.sp4),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: context.gdgColors.tintBlue,
                    borderRadius: GdgShapes.md,
                  ),
                  child: Icon(Icons.event_available, color: context.gdgColors.onTintBlue),
                ),
                title: const Text('New Event'),
                subtitle: const Text('Schedule a meetup, workshop or study jam'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  CreateEditEventSheet.show(
                    context,
                    onSave: (newEvent) {
                      context.go('/core/events');
                    },
                  );
                },
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: context.gdgColors.tintGreen,
                    borderRadius: GdgShapes.md,
                  ),
                  child: Icon(Icons.qr_code_scanner, color: context.gdgColors.onTintGreen),
                ),
                title: const Text('Scan Attendance'),
                subtitle: const Text('Validate member tickets at the door'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  context.go('/core/events');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CoreDashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CoreDashboardAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;

    return AppBar(
      leadingWidth: 72,
      leading: const Padding(
        padding: EdgeInsets.only(left: GdgSpacing.sp4),
        child: Align(
          alignment: Alignment.centerLeft,
          child: GdgLogo(height: 22),
        ),
      ),
      title: Text(
        'Dashboard',
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          tooltip: 'Notifications',
          color: colors.onSurface2,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No new notifications'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        ),
        const SizedBox(width: GdgSpacing.sp2),
      ],
    );
  }
}
