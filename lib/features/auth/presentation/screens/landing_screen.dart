import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/shapes.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/widgets/gdg_button.dart';
import '../../../../core/widgets/gdg_card.dart';
import '../../../../core/widgets/gdg_logo.dart';
import '../widgets/activity_ticker.dart';

/// Screen 01: Landing Screen with live chapter statistics and activity marquee.
class LandingScreen extends StatefulWidget {
  const LandingScreen({
    super.key,
    required this.onJoinPressed,
    this.isTickerAutoScroll = true,
  });

  final VoidCallback onJoinPressed;
  final bool isTickerAutoScroll;

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showStickyBar = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    if (offset > 240 && !_showStickyBar) {
      setState(() => _showStickyBar = true);
    } else if (offset <= 240 && _showStickyBar) {
      setState(() => _showStickyBar = false);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;

    return Scaffold(
      appBar: AppBar(
        title: const GdgLogo(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: GdgSpacing.sp3),
            child: TextButton(
              onPressed: widget.onJoinPressed,
              child: const Text('Join'),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            controller: _scrollController,
            padding: EdgeInsets.zero,
            children: [
              // Hero Section
              Container(
                padding: const EdgeInsets.fromLTRB(
                  GdgSpacing.sp5,
                  GdgSpacing.sp6,
                  GdgSpacing.sp5,
                  GdgSpacing.sp8,
                ),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(1.0, -0.6),
                    radius: 1.2,
                    colors: [
                      colors.brandBlue.withAlpha(36),
                      colors.brandYellow.withAlpha(20),
                      colors.surface,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GDG on\nCampus\nPSIT',
                      style: Theme.of(context).textTheme.displayMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            height: 1.1,
                          ),
                    ),
                    const SizedBox(height: GdgSpacing.sp3),
                    Text(
                      'Learn, build and ship with your chapter.\nWorkshops, study jams and open-source projects, all year.',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: colors.onSurface2,
                          ),
                    ),
                    const SizedBox(height: GdgSpacing.sp6),
                    GdgFilledButton(
                      isWide: true,
                      onPressed: widget.onJoinPressed,
                      child: const Text('Join the chapter'),
                    ),
                    const SizedBox(height: GdgSpacing.sp2),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          _scrollController.animateTo(
                            380,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOut,
                          );
                        },
                        child: const Text('See how it works'),
                      ),
                    ),
                    const SizedBox(height: GdgSpacing.sp4),

                    // Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat(context, '214', 'students'),
                        _buildStat(context, '3', 'projects'),
                        _buildStat(context, '87', 'merged PRs'),
                      ],
                    ),
                  ],
                ),
              ),

              Padding(
                padding: GdgSpacing.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // What is GDG on Campus?
                    Text(
                      'What is GDG on Campus?',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: GdgSpacing.sp4),
                    _buildPillarItem(
                      context,
                      icon: Icons.school_outlined,
                      color: colors.brandBlue,
                      title: 'Learn',
                      description: 'Study jams and learning paths in Android, web, ML and cloud.',
                    ),
                    const SizedBox(height: GdgSpacing.sp3),
                    _buildPillarItem(
                      context,
                      icon: Icons.build_outlined,
                      color: colors.brandGreen,
                      title: 'Build',
                      description: 'Work on real projects with mentors and teammates.',
                    ),
                    const SizedBox(height: GdgSpacing.sp3),
                    _buildPillarItem(
                      context,
                      icon: Icons.rocket_launch_outlined,
                      color: colors.brandRed,
                      title: 'Ship',
                      description: 'Demo your work and earn points on the Board.',
                    ),
                    const SizedBox(height: GdgSpacing.sp8),

                    // How to get involved
                    Text(
                      'How to get involved',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: GdgSpacing.sp4),
                    for (int i = 0; i < 4; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: GdgSpacing.sp3),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: colors.primary,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${i + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: GdgSpacing.sp3),
                            Expanded(
                              child: Text(
                                [
                                  'Join the chapter',
                                  'Pick an event or project',
                                  'Contribute and learn',
                                  'Earn points on the Board',
                                ][i],
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: GdgSpacing.sp8),

                    // Coming up Event Card
                    Text(
                      'Coming up',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: GdgSpacing.sp3),
                    GdgCard(
                      isHero: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 140,
                            decoration: BoxDecoration(
                              color: colors.tintBlue,
                              borderRadius: GdgShapes.lg,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.emoji_events_outlined,
                                size: 56,
                                color: colors.brandBlue,
                              ),
                            ),
                          ),
                          const SizedBox(height: GdgSpacing.sp4),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: colors.brandGreen,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: GdgSpacing.sp2),
                              Text(
                                'Hacktoberfest 2026 Kickoff',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: GdgSpacing.sp1),
                          Text(
                            'Sat 10 Oct · 11:00 AM · Seminar Hall',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: colors.onSurface2,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: GdgSpacing.sp8),

                    // Happening in the chapter
                    Text(
                      'Happening in the chapter',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: GdgSpacing.sp3),
                    ActivityTicker(autoScroll: widget.isTickerAutoScroll),
                    const SizedBox(height: GdgSpacing.sp10),

                    // Footer
                    Center(
                      child: Column(
                        children: [
                          const GdgLogo(width: 56, height: 28),
                          const SizedBox(height: GdgSpacing.sp4),
                          Text(
                            '© 2026 GDG on Campus PSIT',
                            style: GdgTypography.mono(
                              context,
                              color: colors.onSurface3,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 80), // Padding for sticky button
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Sticky bottom bar
          if (_showStickyBar)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: GdgSpacing.sp5,
                  vertical: GdgSpacing.sp3,
                ),
                decoration: BoxDecoration(
                  color: colors.surface.withAlpha(242),
                  border: Border(
                    top: BorderSide(color: colors.outline, width: 1),
                  ),
                ),
                child: GdgFilledButton(
                  isWide: true,
                  onPressed: widget.onJoinPressed,
                  child: const Text('Join the chapter'),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStat(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GdgTypography.mono(
            context,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildPillarItem(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    final colors = context.gdgColors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withAlpha(30),
            borderRadius: GdgShapes.md,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: GdgSpacing.sp3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: colors.onSurface2,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
