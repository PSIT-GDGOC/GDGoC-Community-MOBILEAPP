import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/shapes.dart';
import '../../../../core/theme/spacing.dart';
import '../../domain/models/event_item.dart';
import 'event_deck_card.dart';

class SwipeableCardDeck extends StatefulWidget {
  const SwipeableCardDeck({
    super.key,
    required this.events,
    required this.currentIndex,
    required this.onCardChanged,
    required this.onViewDetails,
  });

  final List<EventItem> events;
  final int currentIndex;
  final ValueChanged<int> onCardChanged;
  final ValueChanged<EventItem> onViewDetails;

  @override
  State<SwipeableCardDeck> createState() => _SwipeableCardDeckState();
}

class _SwipeableCardDeckState extends State<SwipeableCardDeck>
    with SingleTickerProviderStateMixin {
  double _dragOffset = 0.0;
  late final AnimationController _animController;
  late Animation<double> _settleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _animController.addListener(() {
      setState(() {
        _dragOffset = _settleAnimation.value;
      });
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (_animController.isAnimating) return;
    setState(() {
      _dragOffset += details.primaryDelta ?? 0.0;
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_animController.isAnimating) return;

    final velocity = details.primaryVelocity ?? 0.0;
    final isFast = velocity.abs() > 300;
    final isRight = _dragOffset > 80 || (isFast && velocity > 0);
    final isLeft = _dragOffset < -80 || (isFast && velocity < 0);

    if (isLeft && widget.currentIndex < widget.events.length - 1) {
      _animateSwipe(target: -400, onComplete: () {
        widget.onCardChanged(widget.currentIndex + 1);
        _dragOffset = 0.0;
      });
    } else if (isRight && widget.currentIndex > 0) {
      _animateSwipe(target: 400, onComplete: () {
        widget.onCardChanged(widget.currentIndex - 1);
        _dragOffset = 0.0;
      });
    } else {
      _animateSettle(target: 0.0);
    }
  }

  void _animateSwipe({required double target, required VoidCallback onComplete}) {
    _settleAnimation = Tween<double>(
      begin: _dragOffset,
      end: target,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    ));

    _animController.forward(from: 0.0).then((_) {
      if (mounted) {
        onComplete();
        setState(() {
          _dragOffset = 0.0;
        });
      }
    });
  }

  void _animateSettle({required double target}) {
    _settleAnimation = Tween<double>(
      begin: _dragOffset,
      end: target,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));

    _animController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;

    if (widget.events.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(GdgSpacing.sp8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.event_busy, size: 56, color: colors.onSurface3),
              const SizedBox(height: GdgSpacing.sp3),
              Text(
                'No events in this category',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: colors.onSurface2,
                    ),
              ),
            ],
          ),
        ),
      );
    }

    final currentIndex = widget.currentIndex.clamp(0, widget.events.length - 1);
    final currentEvent = widget.events[currentIndex];
    final hasNext = currentIndex < widget.events.length - 1;
    final nextEvent = hasNext ? widget.events[currentIndex + 1] : null;

    // ±6 degrees in radians = ~0.1047
    final maxRotation = 6.0 * math.pi / 180.0;
    final rotation = (_dragOffset / 300.0).clamp(-1.0, 1.0) * maxRotation;

    final progress = (_dragOffset.abs() / 200.0).clamp(0.0, 1.0);
    final nextScale = 0.94 + (0.06 * progress);
    final nextOffsetY = (1.0 - progress) * 12.0;

    return Column(
      children: [
        // Top Counter (e.g. "1 of 6")
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: GdgSpacing.sp5),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${currentIndex + 1} of ${widget.events.length}',
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    fontFamily: 'monospace',
                    color: colors.onSurface3,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ),
        const SizedBox(height: GdgSpacing.sp2),

        // Deck Stack with Left & Right Chevrons
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Next Card underneath (if exists)
              if (nextEvent != null)
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: GdgSpacing.sp4),
                    child: Transform.translate(
                      offset: Offset(0, nextOffsetY),
                      child: Transform.scale(
                        scale: nextScale,
                        child: EventDeckCard(
                          event: nextEvent,
                          onViewDetails: () => widget.onViewDetails(nextEvent),
                        ),
                      ),
                    ),
                  ),
                ),

              // Active Card (Front)
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: GdgSpacing.sp4),
                  child: GestureDetector(
                    onHorizontalDragUpdate: _onHorizontalDragUpdate,
                    onHorizontalDragEnd: _onHorizontalDragEnd,
                    child: Transform.translate(
                      offset: Offset(_dragOffset, 0),
                      child: Transform.rotate(
                        angle: rotation,
                        child: EventDeckCard(
                          event: currentEvent,
                          onViewDetails: () => widget.onViewDetails(currentEvent),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Left Chevron
              Positioned(
                left: 2,
                child: Material(
                  color: Colors.transparent,
                  child: IconButton(
                    icon: const Icon(Icons.chevron_left_rounded, size: 32),
                    tooltip: 'Previous event',
                    color: currentIndex > 0
                        ? colors.onSurface
                        : colors.onSurface3.withAlpha(80),
                    onPressed: currentIndex > 0
                        ? () {
                            _animateSwipe(target: 350, onComplete: () {
                              widget.onCardChanged(currentIndex - 1);
                            });
                          }
                        : null,
                  ),
                ),
              ),

              // Right Chevron
              Positioned(
                right: 2,
                child: Material(
                  color: Colors.transparent,
                  child: IconButton(
                    icon: const Icon(Icons.chevron_right_rounded, size: 32),
                    tooltip: 'Next event',
                    color: currentIndex < widget.events.length - 1
                        ? colors.onSurface
                        : colors.onSurface3.withAlpha(80),
                    onPressed: currentIndex < widget.events.length - 1
                        ? () {
                            _animateSwipe(target: -350, onComplete: () {
                              widget.onCardChanged(currentIndex + 1);
                            });
                          }
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Dots Indicator
        const SizedBox(height: GdgSpacing.sp3),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < widget.events.length; i++) ...[
              InkWell(
                onTap: () => widget.onCardChanged(i),
                borderRadius: GdgShapes.full,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  width: i == currentIndex ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: i == currentIndex ? colors.primary : colors.outline,
                    borderRadius: GdgShapes.full,
                  ),
                ),
              ),
              if (i < widget.events.length - 1)
                const SizedBox(width: GdgSpacing.sp2),
            ],
          ],
        ),
        const SizedBox(height: GdgSpacing.sp2),
      ],
    );
  }
}
