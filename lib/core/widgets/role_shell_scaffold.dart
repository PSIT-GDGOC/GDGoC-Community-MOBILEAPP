import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/colors.dart';
import '../theme/shapes.dart';
import '../theme/spacing.dart';
import '../../features/auth/domain/models/auth_user.dart';

class NavDestinationItem {
  const NavDestinationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

/// Unified Shell Scaffold for Member, Core Team, and Mentor navigation.
class RoleShellScaffold extends StatelessWidget {
  const RoleShellScaffold({
    super.key,
    required this.navigationShell,
    required this.role,
  });

  final StatefulNavigationShell navigationShell;
  final UserRole role;

  List<NavDestinationItem> _getDestinations(UserRole role) {
    return switch (role) {
      UserRole.member => const [
          NavDestinationItem(
            icon: Icons.home_outlined,
            selectedIcon: Icons.home_rounded,
            label: 'Home',
          ),
          NavDestinationItem(
            icon: Icons.calendar_month_outlined,
            selectedIcon: Icons.calendar_month_rounded,
            label: 'Events',
          ),
          NavDestinationItem(
            icon: Icons.code_outlined,
            selectedIcon: Icons.code_rounded,
            label: 'Projects',
          ),
          NavDestinationItem(
            icon: Icons.school_outlined,
            selectedIcon: Icons.school_rounded,
            label: 'Learn',
          ),
          NavDestinationItem(
            icon: Icons.person_outline_rounded,
            selectedIcon: Icons.person_rounded,
            label: 'Profile',
          ),
        ],
      UserRole.coreTeam => const [
          NavDestinationItem(
            icon: Icons.dashboard_outlined,
            selectedIcon: Icons.dashboard_rounded,
            label: 'Dashboard',
          ),
          NavDestinationItem(
            icon: Icons.calendar_month_outlined,
            selectedIcon: Icons.calendar_month_rounded,
            label: 'Events',
          ),
          NavDestinationItem(
            icon: Icons.code_outlined,
            selectedIcon: Icons.code_rounded,
            label: 'Projects',
          ),
          NavDestinationItem(
            icon: Icons.groups_outlined,
            selectedIcon: Icons.groups_rounded,
            label: 'Members',
          ),
          NavDestinationItem(
            icon: Icons.account_circle_outlined,
            selectedIcon: Icons.account_circle_rounded,
            label: 'Me',
          ),
        ],
      UserRole.mentor => const [
          NavDestinationItem(
            icon: Icons.analytics_outlined,
            selectedIcon: Icons.analytics_rounded,
            label: 'Overview',
          ),
          NavDestinationItem(
            icon: Icons.group_outlined,
            selectedIcon: Icons.group_rounded,
            label: 'Students',
          ),
          NavDestinationItem(
            icon: Icons.code_outlined,
            selectedIcon: Icons.code_rounded,
            label: 'Projects',
          ),
          NavDestinationItem(
            icon: Icons.insights_outlined,
            selectedIcon: Icons.insights_rounded,
            label: 'Insights',
          ),
        ],
    };
  }

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;
    final destinations = _getDestinations(role);
    final currentIndex = navigationShell.currentIndex;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: colors.surface.withAlpha(240),
          border: Border(
            top: BorderSide(color: colors.outline, width: 1),
          ),
        ),
        child: Row(
          children: [
            for (int i = 0; i < destinations.length; i++)
              Expanded(
                child: _buildNavItem(
                  context,
                  item: destinations[i],
                  isSelected: i == currentIndex,
                  onTap: () => _onTap(i),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required NavDestinationItem item,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colors = context.gdgColors;

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            width: 64,
            height: 32,
            decoration: BoxDecoration(
              color: isSelected ? colors.tintBlue : Colors.transparent,
              borderRadius: GdgShapes.full,
            ),
            child: Icon(
              isSelected ? item.selectedIcon : item.icon,
              size: 22,
              color: isSelected ? colors.primary : colors.onSurface2,
            ),
          ),
          const SizedBox(height: GdgSpacing.sp1),
          Text(
            item.label,
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
                  color: isSelected ? colors.primary : colors.onSurface2,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 11,
                ),
          ),
        ],
      ),
    );
  }
}
