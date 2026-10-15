import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/shapes.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/gdg_chip.dart';
import '../../../../core/widgets/gdg_logo.dart';
import '../../domain/models/learning_path.dart';
import '../../domain/models/workshop_session.dart';
import '../controllers/learn_controller.dart';
import '../widgets/learning_path_card.dart';
import '../widgets/module_checklist_sheet.dart';
import '../widgets/resource_card.dart';
import '../widgets/session_card.dart';
import '../widgets/video_player_modal.dart';

/// Screen 10: Learn Screen with Paths, Resources, and Sessions tabs.
class LearnScreen extends ConsumerStatefulWidget {
  const LearnScreen({super.key});

  @override
  ConsumerState<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends ConsumerState<LearnScreen> {
  static const List<String> _tabs = ['Paths', 'Resources', 'Sessions'];
  static const List<String> _resourceTopics = [
    'All',
    'Android',
    'Web',
    'Flutter',
    'Cloud',
    'ML',
    'Git',
  ];

  void _showModuleSheet(LearningPath path) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Consumer(
          builder: (context, ref, _) {
            final currentPaths = ref.watch(learnControllerProvider).paths;
            final updatedPath = currentPaths.firstWhere(
              (p) => p.id == path.id,
              orElse: () => path,
            );

            return ModuleChecklistSheet(
              path: updatedPath,
              onToggleModule: (moduleId) {
                ref
                    .read(learnControllerProvider.notifier)
                    .toggleModule(path.id, moduleId);
              },
            );
          },
        );
      },
    );
  }

  void _showSessionModal(WorkshopSession session) {
    ref.read(learnControllerProvider.notifier).openSessionPreview(session);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return VideoPlayerModal(
          session: session,
          onClose: () {
            ref.read(learnControllerProvider.notifier).closeSessionPreview();
            Navigator.of(ctx).pop();
          },
        );
      },
    ).whenComplete(() {
      ref.read(learnControllerProvider.notifier).closeSessionPreview();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(learnControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const GdgLogo(),
            const SizedBox(width: GdgSpacing.sp3),
            Text(
              'Learn',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            tooltip: 'Search topics',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Search and discovery catalog'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Tab Switcher matching mockup: Paths, Resources, Sessions
            Padding(
              padding: const EdgeInsets.fromLTRB(
                GdgSpacing.sp5,
                GdgSpacing.sp2,
                GdgSpacing.sp5,
                GdgSpacing.sp3,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_tabs.length, (index) {
                    final label = _tabs[index];
                    final isSelected = state.selectedTab == index;

                    return Padding(
                      padding: const EdgeInsets.only(right: GdgSpacing.sp2),
                      child: GdgChipFilter(
                        label: label,
                        isSelected: isSelected,
                        onSelected: (_) {
                          ref
                              .read(learnControllerProvider.notifier)
                              .setTab(index);
                        },
                      ),
                    );
                  }),
                ),
              ),
            ),

            // Tab Content Body
            Expanded(
              child: IndexedStack(
                index: state.selectedTab.clamp(0, 2),
                children: [
                  _buildPathsTab(state),
                  _buildResourcesTab(state),
                  _buildSessionsTab(state),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 1. Paths Tab
  Widget _buildPathsTab(LearnState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.separated(
      key: const ValueKey('paths_tab'),
      padding: GdgSpacing.screenPadding,
      itemCount: state.paths.length,
      separatorBuilder: (_, _) => const SizedBox(height: GdgSpacing.sp3),
      itemBuilder: (context, index) {
        final path = state.paths[index];
        return LearningPathCard(
          path: path,
          onTap: () => _showModuleSheet(path),
        );
      },
    );
  }

  /// 2. Resources Tab with Topic Filtering
  Widget _buildResourcesTab(LearnState state) {
    final colors = context.gdgColors;

    return Column(
      key: const ValueKey('resources_tab'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Topic Filter Chips Row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: GdgSpacing.sp5),
          child: Row(
            children: _resourceTopics.map((topic) {
              final isSelected = state.selectedTopic == topic;
              return Padding(
                padding: const EdgeInsets.only(right: GdgSpacing.sp2),
                child: FilterChip(
                  label: Text(topic),
                  selected: isSelected,
                  onSelected: (_) {
                    ref
                        .read(learnControllerProvider.notifier)
                        .setSelectedTopic(topic);
                  },
                  backgroundColor: colors.surface,
                  selectedColor: colors.tintBlue,
                  labelStyle: TextStyle(
                    color: isSelected ? colors.onTintBlue : colors.onSurface2,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                  side: BorderSide(
                    color: isSelected ? colors.brandBlue : colors.outline,
                    width: 1,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: GdgShapes.full,
                  ),
                  showCheckmark: false,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: GdgSpacing.sp3),

        // Curated Materials List
        Expanded(
          child: state.filteredResources.isEmpty
              ? Center(
                  child: Text(
                    'No resources found for "${state.selectedTopic}"',
                    style: TextStyle(color: colors.onSurface2),
                  ),
                )
              : ListView.separated(
                  padding: GdgSpacing.screenPadding,
                  itemCount: state.filteredResources.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: GdgSpacing.sp3),
                  itemBuilder: (context, index) {
                    final item = state.filteredResources[index];
                    return ResourceCard(
                      resource: item,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Opening documentation: ${item.url}'),
                            behavior: SnackBarBehavior.floating,
                            action: SnackBarAction(
                              label: 'OK',
                              onPressed: () {},
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  /// 3. Sessions Tab (Recorded Sessions Archive)
  Widget _buildSessionsTab(LearnState state) {
    final colors = context.gdgColors;

    return ListView(
      key: const ValueKey('sessions_tab'),
      padding: GdgSpacing.screenPadding,
      children: [
        // Section Header matching mockup: "Past sessions"
        Row(
          children: [
            Text(
              'Past sessions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(width: GdgSpacing.sp2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: colors.tintBlue,
                borderRadius: GdgShapes.full,
              ),
              child: Text(
                '${state.sessions.length} recordings',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colors.onTintBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: GdgSpacing.sp3),

        ...state.sessions.map((session) {
          return Padding(
            padding: const EdgeInsets.only(bottom: GdgSpacing.sp3),
            child: SessionCard(
              session: session,
              onPlayTap: () => _showSessionModal(session),
            ),
          );
        }),
      ],
    );
  }
}
