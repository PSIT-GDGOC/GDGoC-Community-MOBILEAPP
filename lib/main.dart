import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/gdg_button.dart';
import 'core/widgets/gdg_card.dart';
import 'core/widgets/gdg_chip.dart';
import 'core/widgets/gdg_logo.dart';
import 'features/auth/presentation/screens/landing_screen.dart';
import 'features/auth/presentation/screens/otp_screen.dart';
import 'features/auth/presentation/screens/role_router_screen.dart';
import 'features/auth/presentation/screens/verify_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: GdgApp(),
    ),
  );
}

class GdgApp extends StatelessWidget {
  const GdgApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GDGoC PSIT',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AuthFlowCoordinator(),
    );
  }
}

/// Coordinates transitions across Screens 01 to 04 of the Auth Flow.
class AuthFlowCoordinator extends StatefulWidget {
  const AuthFlowCoordinator({super.key});

  @override
  State<AuthFlowCoordinator> createState() => _AuthFlowCoordinatorState();
}

class _AuthFlowCoordinatorState extends State<AuthFlowCoordinator> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return switch (_currentStep) {
      0 => LandingScreen(
          onJoinPressed: () => setState(() => _currentStep = 1),
        ),
      1 => VerifyScreen(
          onVerificationCodeSent: () => setState(() => _currentStep = 2),
          onBackPressed: () => setState(() => _currentStep = 0),
        ),
      2 => OtpScreen(
          onVerificationSuccessful: () => setState(() => _currentStep = 3),
          onBackPressed: () => setState(() => _currentStep = 1),
        ),
      3 => RoleRouterScreen(
          onEnterAppPressed: () => setState(() => _currentStep = 4),
        ),
      _ => const SetupPreviewScreen(),
    };
  }
}

/// Minimal design-system verification screen displayed after entering the app.
class SetupPreviewScreen extends StatelessWidget {
  const SetupPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            GdgLogo(),
            SizedBox(width: GdgSpacing.sp3),
            Text('GDGoC PSIT'),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: GdgSpacing.screenPadding,
          children: [
            GdgCard(
              isHero: true,
              tint: GdgCardTint.blue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const GdgChipAssist(
                    label: 'Auth Flow Complete',
                    tone: GdgChipTone.green,
                    icon: Icon(Icons.check_circle_outline),
                  ),
                  const SizedBox(height: GdgSpacing.sp3),
                  Text(
                    'Welcome to the Chapter',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: GdgSpacing.sp2),
                  Text(
                    'You are signed in as a verified member. Screens 01 through 04 completed.',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: colors.onSurface2,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: GdgSpacing.sp4),
            Text(
              'Color Tokens Verification',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: GdgSpacing.sp2),
            Wrap(
              spacing: GdgSpacing.sp2,
              runSpacing: GdgSpacing.sp2,
              children: const [
                GdgChipAssist(label: 'Blue', tone: GdgChipTone.blue),
                GdgChipAssist(label: 'Green', tone: GdgChipTone.green),
                GdgChipAssist(label: 'Red', tone: GdgChipTone.red),
                GdgChipAssist(label: 'Yellow', tone: GdgChipTone.yellow),
              ],
            ),
            const SizedBox(height: GdgSpacing.sp6),
            GdgFilledButton(
              isWide: true,
              onPressed: () {},
              child: const Text('Member Portal Next'),
            ),
          ],
        ),
      ),
    );
  }
}
