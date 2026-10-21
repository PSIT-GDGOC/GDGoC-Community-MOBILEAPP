import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/domain/models/auth_user.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/screens/landing_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/role_router_screen.dart';
import '../../features/auth/presentation/screens/verify_screen.dart';
import '../widgets/role_shell_scaffold.dart';
import '../widgets/tab_placeholder_screen.dart';
import '../../features/learn/presentation/screens/learn_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/events/domain/models/event_item.dart';
import '../../features/events/presentation/screens/event_detail_screen.dart';
import '../../features/events/presentation/screens/events_screen.dart';
import '../../features/core_team/domain/models/manage_event_item.dart';
import '../../features/core_team/presentation/screens/core_dashboard_screen.dart';
import '../../features/core_team/presentation/screens/manage_events_screen.dart';
import '../../features/scanner/presentation/screens/attendance_scanner_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/landing',
    refreshListenable: _AuthRouterNotifier(ref),
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);
      final isAuthenticated =
          authState.status == AuthStatus.authenticated &&
          authState.user != null;
      final path = state.uri.path;

      final isAuthFlow =
          path == '/landing' ||
          path == '/verify' ||
          path == '/otp' ||
          path == '/role-router';

      if (!isAuthenticated) {
        // Allow public auth routes, redirect anything else to landing
        if (isAuthFlow) return null;
        return '/landing';
      }

      // User is authenticated
      final role = authState.user!.role;
      final defaultHome = switch (role) {
        UserRole.member => '/member/home',
        UserRole.coreTeam => '/core/dashboard',
        UserRole.mentor => '/mentor/overview',
      };

      // Redirect out of landing/auth pages once authenticated (unless explicitly viewing role-router)
      if (path == '/' ||
          path == '/landing' ||
          path == '/verify' ||
          path == '/otp') {
        return defaultHome;
      }

      // Guard role boundaries
      if (path.startsWith('/member') && role != UserRole.member) {
        return defaultHome;
      }
      if (path.startsWith('/core') && role != UserRole.coreTeam) {
        return defaultHome;
      }
      if (path.startsWith('/mentor') && role != UserRole.mentor) {
        return defaultHome;
      }

      return null;
    },
    routes: [
      // Public / Auth Flow
      GoRoute(
        path: '/landing',
        builder: (context, state) =>
            LandingScreen(onJoinPressed: () => context.go('/verify')),
      ),
      GoRoute(
        path: '/verify',
        builder: (context, state) => VerifyScreen(
          onVerificationCodeSent: () => context.go('/otp'),
          onBackPressed: () => context.go('/landing'),
        ),
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) => OtpScreen(
          onVerificationSuccessful: () => context.go('/role-router'),
          onBackPressed: () => context.go('/verify'),
        ),
      ),
      GoRoute(
        path: '/role-router',
        builder: (context, state) => RoleRouterScreen(
          onEnterAppPressed: () {
            final user = ref.read(authControllerProvider).user;
            final targetPath = switch (user?.role) {
              UserRole.coreTeam => '/core/dashboard',
              UserRole.mentor => '/mentor/overview',
              _ => '/member/home',
            };
            context.go(targetPath);
          },
        ),
      ),

      // Member Shell (5 Tabs)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => RoleShellScaffold(
          navigationShell: navigationShell,
          role: UserRole.member,
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/member/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/member/events',
                builder: (context, state) => const EventsScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final eventId = state.pathParameters['id'] ?? '';
                      final extra = state.extra is EventItem
                          ? state.extra as EventItem
                          : null;
                      return EventDetailScreen(
                        eventId: eventId,
                        initialEvent: extra,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/member/projects',
                builder: (context, state) => const TabPlaceholderScreen(
                  title: 'Projects',
                  role: UserRole.member,
                  issueNumber: 5,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/member/learn',
                builder: (context, state) => const LearnScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/member/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // Core Team Shell (5 Tabs)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => RoleShellScaffold(
          navigationShell: navigationShell,
          role: UserRole.coreTeam,
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/core/dashboard',
                builder: (context, state) => const CoreDashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/core/events',
                builder: (context, state) => const ManageEventsScreen(),
                routes: [
                  GoRoute(
                    path: ':id/scan',
                    builder: (context, state) {
                      final eventId =
                          state.pathParameters['id'] ?? 'evt_kickoff';
                      final event = state.extra is ManageEventItem
                          ? state.extra as ManageEventItem
                          : null;
                      return AttendanceScannerScreen(
                        eventId: eventId,
                        initialEvent: event,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/core/projects',
                builder: (context, state) => const TabPlaceholderScreen(
                  title: 'Projects Queue',
                  role: UserRole.coreTeam,
                  issueNumber: 8,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/core/members',
                builder: (context, state) => const TabPlaceholderScreen(
                  title: 'Members Directory',
                  role: UserRole.coreTeam,
                  issueNumber: 8,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/core/me',
                builder: (context, state) => const TabPlaceholderScreen(
                  title: 'Organizer Profile',
                  role: UserRole.coreTeam,
                  issueNumber: 8,
                ),
              ),
            ],
          ),
        ],
      ),

      // Mentor Shell (4 Tabs)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => RoleShellScaffold(
          navigationShell: navigationShell,
          role: UserRole.mentor,
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/mentor/overview',
                builder: (context, state) => const TabPlaceholderScreen(
                  title: 'Chapter Overview',
                  role: UserRole.mentor,
                  issueNumber: 10,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/mentor/students',
                builder: (context, state) => const TabPlaceholderScreen(
                  title: 'Students Overview',
                  role: UserRole.mentor,
                  issueNumber: 10,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/mentor/projects',
                builder: (context, state) => const TabPlaceholderScreen(
                  title: 'Projects Oversight',
                  role: UserRole.mentor,
                  issueNumber: 10,
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/mentor/insights',
                builder: (context, state) => const TabPlaceholderScreen(
                  title: 'Insights & Reports',
                  role: UserRole.mentor,
                  issueNumber: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

class _AuthRouterNotifier extends ChangeNotifier {
  _AuthRouterNotifier(this._ref) {
    _ref.listen(authControllerProvider, (_, _) => notifyListeners());
  }

  final Ref _ref;
}
