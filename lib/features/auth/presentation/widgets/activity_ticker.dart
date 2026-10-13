import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/shapes.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/widgets/gdg_avatar.dart';

class ActivityItem {
  const ActivityItem({
    required this.name,
    required this.action,
    required this.timeAgo,
    required this.colorIndex,
  });

  final String name;
  final String action;
  final String timeAgo;
  final int colorIndex;
}

/// Screen 01 Live Activity Marquee Ticker.
class ActivityTicker extends StatefulWidget {
  const ActivityTicker({
    super.key,
    this.autoScroll = true,
  });

  final bool autoScroll;

  static const List<ActivityItem> feed = [
    ActivityItem(name: 'Ishita Verma', action: 'merged a PR', timeAgo: '2m', colorIndex: 0),
    ActivityItem(name: 'Rudransh Singh', action: 'joined the chapter', timeAgo: 'just now', colorIndex: 1),
    ActivityItem(name: 'Kabir Singh', action: 'joined Android App', timeAgo: '1h', colorIndex: 2),
    ActivityItem(name: 'Ananya Mishra', action: 'registered for Kickoff', timeAgo: '3h', colorIndex: 3),
    ActivityItem(name: 'Sanya Khan', action: 'completed Android module 3', timeAgo: '5h', colorIndex: 0),
    ActivityItem(name: 'Priya Tripathi', action: 'opened a docs PR', timeAgo: '6h', colorIndex: 1),
    ActivityItem(name: 'Vivek Yadav', action: 'earned First PR badge', timeAgo: '8h', colorIndex: 2),
    ActivityItem(name: 'Meera Joshi', action: 'attended Cloud Study Jam', timeAgo: 'yesterday', colorIndex: 3),
  ];

  @override
  State<ActivityTicker> createState() => _ActivityTickerState();
}

class _ActivityTickerState extends State<ActivityTicker> {
  late final ScrollController _scrollController;
  Timer? _scrollTimer;
  Timer? _pauseTimer;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    if (widget.autoScroll) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startAutoScroll();
      });
    }
  }

  void _startAutoScroll() {
    _scrollTimer?.cancel();
    _scrollTimer = Timer.periodic(const Duration(milliseconds: 30), (_) {
      if (!mounted || _isPaused || !_scrollController.hasClients) return;
      final maxScroll = _scrollController.position.maxScrollExtent;
      final current = _scrollController.offset;
      if (current >= maxScroll - 2) {
        _scrollController.jumpTo(0);
      } else {
        _scrollController.jumpTo(current + 1.2);
      }
    });
  }

  void _onCardTapped() {
    setState(() => _isPaused = true);
    _pauseTimer?.cancel();
    _pauseTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _isPaused = false);
    });
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _pauseTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;
    final items = [...ActivityTicker.feed, ...ActivityTicker.feed];

    return SizedBox(
      height: 64,
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: GdgSpacing.sp3),
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: _onCardTapped,
            child: Container(
              width: 220,
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: GdgSpacing.sp3),
              decoration: BoxDecoration(
                color: colors.surfaceAlt,
                borderRadius: GdgShapes.full,
              ),
              child: Row(
                children: [
                  GdgAvatar(
                    name: item.name,
                    colorIndex: item.colorIndex,
                    size: GdgAvatarSize.sm,
                  ),
                  const SizedBox(width: GdgSpacing.sp2),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: GdgTypography.mono(
                            context,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${item.action} · ${item.timeAgo}',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: colors.onSurface2,
                                fontSize: 11,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
