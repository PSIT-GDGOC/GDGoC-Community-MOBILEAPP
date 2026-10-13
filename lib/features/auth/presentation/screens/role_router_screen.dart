import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/gdg_button.dart';
import '../controllers/auth_controller.dart';

/// Screen 04: Role Router Confirmation Screen with pop-in success animation.
class RoleRouterScreen extends ConsumerStatefulWidget {
  const RoleRouterScreen({
    super.key,
    required this.onEnterAppPressed,
  });

  final VoidCallback onEnterAppPressed;

  @override
  ConsumerState<RoleRouterScreen> createState() => _RoleRouterScreenState();
}

class _RoleRouterScreenState extends ConsumerState<RoleRouterScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;
    final user = ref.watch(authControllerProvider).user;
    final userName = user?.name.split(' ').first ?? 'Aarav';
    final roleDescription = user?.roleDescription ?? 'Member · Computer Science, 3rd year';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: GdgSpacing.pagePadding,
          child: Column(
            children: [
              const Spacer(),

              // Pop-in Success Badge
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 112,
                  height: 112,
                  decoration: BoxDecoration(
                    color: colors.tintGreen,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check_rounded,
                      size: 64,
                      color: colors.brandGreen,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: GdgSpacing.sp6),

              Text(
                "You're in, $userName",
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: GdgSpacing.sp2),

              Text(
                roleDescription,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: colors.onSurface2,
                    ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              GdgFilledButton(
                isWide: true,
                onPressed: widget.onEnterAppPressed,
                child: const Text('Enter the app'),
              ),
              const SizedBox(height: GdgSpacing.sp4),
            ],
          ),
        ),
      ),
    );
  }
}
