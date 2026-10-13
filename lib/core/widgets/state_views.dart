import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/shapes.dart';
import '../theme/spacing.dart';
import 'gdg_button.dart';
import 'gdg_card.dart';

/// Screen 20: Loading Skeleton Cards with pulsing animation.
class LoadingStateView extends StatefulWidget {
  const LoadingStateView({
    super.key,
    this.itemCount = 3,
  });

  final int itemCount;

  @override
  State<LoadingStateView> createState() => _LoadingStateViewState();
}

class _LoadingStateViewState extends State<LoadingStateView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _opacity = Tween<double>(begin: 1.0, end: 0.55).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;

    return FadeTransition(
      opacity: _opacity,
      child: ListView.separated(
        padding: GdgSpacing.screenPadding,
        itemCount: widget.itemCount,
        separatorBuilder: (_, _) => const SizedBox(height: GdgSpacing.sp3),
        itemBuilder: (context, _) => GdgCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: colors.surfaceAlt,
                      borderRadius: GdgShapes.md,
                    ),
                  ),
                  const SizedBox(width: GdgSpacing.sp3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 16,
                          width: 140,
                          decoration: BoxDecoration(
                            color: colors.surfaceAlt,
                            borderRadius: GdgShapes.sm,
                          ),
                        ),
                        const SizedBox(height: GdgSpacing.sp2),
                        Container(
                          height: 12,
                          width: 200,
                          decoration: BoxDecoration(
                            color: colors.surfaceAlt,
                            borderRadius: GdgShapes.sm,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: GdgSpacing.sp3),
              Container(
                height: 12,
                width: 160,
                decoration: BoxDecoration(
                  color: colors.surfaceAlt,
                  borderRadius: GdgShapes.sm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Screen 21: Empty State View with pop-in icon and action.
class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.icon = Icons.emoji_events_outlined,
  });

  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;

    return Center(
      child: Padding(
        padding: GdgSpacing.pagePadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                color: colors.tintBlue,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 56,
                color: colors.onTintBlue,
              ),
            ),
            const SizedBox(height: GdgSpacing.sp6),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: GdgSpacing.sp2),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: colors.onSurface2,
                  ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: GdgSpacing.sp6),
              TextButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Screen 22: Error State View with retry button.
class ErrorStateView extends StatelessWidget {
  const ErrorStateView({
    super.key,
    required this.title,
    required this.message,
    required this.onRetry,
    this.isRetrying = false,
  });

  final String title;
  final String message;
  final VoidCallback onRetry;
  final bool isRetrying;

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;

    return Center(
      child: Padding(
        padding: GdgSpacing.pagePadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                color: colors.tintRed,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cloud_off_rounded,
                size: 56,
                color: colors.brandRed,
              ),
            ),
            const SizedBox(height: GdgSpacing.sp6),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: GdgSpacing.sp2),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: colors.onSurface2,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: GdgSpacing.sp6),
            if (isRetrying)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              )
            else
              GdgOutlinedButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
          ],
        ),
      ),
    );
  }
}
