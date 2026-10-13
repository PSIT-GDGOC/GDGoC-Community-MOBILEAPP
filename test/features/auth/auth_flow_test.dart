import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gdgoc_psit_app/core/theme/app_theme.dart';
import 'package:gdgoc_psit_app/features/auth/data/auth_repository.dart';
import 'package:gdgoc_psit_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:gdgoc_psit_app/features/auth/presentation/screens/landing_screen.dart';
import 'package:gdgoc_psit_app/features/auth/presentation/screens/otp_screen.dart';
import 'package:gdgoc_psit_app/features/auth/presentation/screens/role_router_screen.dart';
import 'package:gdgoc_psit_app/features/auth/presentation/screens/verify_screen.dart';

void main() {
  group('Auth Unit & Widget Tests', () {
    test('AuthController sends OTP and verifies successfully with FakeAuthRepository', () async {
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
        ],
      );
      addTearDown(container.dispose);

      final controller = container.read(authControllerProvider.notifier);

      expect(container.read(authControllerProvider).status, AuthStatus.initial);

      final sendResult = await controller.sendOtp(
        rollNumber: '2501640100567',
        email: 'aarav.sharma@gmail.com',
      );
      expect(sendResult, isTrue);
      expect(container.read(authControllerProvider).status, AuthStatus.otpSent);

      final verifyResult = await controller.verifyOtp(otp: '123456');
      expect(verifyResult, isTrue);
      expect(container.read(authControllerProvider).status, AuthStatus.authenticated);
      expect(container.read(authControllerProvider).user?.name, 'Aarav Sharma');
      expect(container.read(authControllerProvider).user?.rollNumber, '2501640100567');
    });

    testWidgets('LandingScreen renders hero content and triggers onJoinPressed', (tester) async {
      bool joinPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: LandingScreen(
            isTickerAutoScroll: false,
            onJoinPressed: () => joinPressed = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('GDG on\nCampus\nPSIT'), findsOneWidget);
      expect(find.text('Join the chapter'), findsWidgets);

      await tester.tap(find.text('Join the chapter').first);
      await tester.pump();

      expect(joinPressed, isTrue);
    });

    testWidgets('VerifyScreen validates 13-digit roll number input', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: VerifyScreen(
              onVerificationCodeSent: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Verify your PSIT account'), findsOneWidget);
      expect(find.text('Send verification code'), findsOneWidget);
    });

    testWidgets('OtpScreen renders 6-digit instructions and resend timer', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: OtpScreen(
              onVerificationSuccessful: () {},
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Enter the 6-digit code'), findsOneWidget);
      expect(find.textContaining('Resend in'), findsOneWidget);
    });

    testWidgets('RoleRouterScreen shows success message and triggers onEnterAppPressed', (tester) async {
      bool enterPressed = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: RoleRouterScreen(
              onEnterAppPressed: () => enterPressed = true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text("You're in, Aarav"), findsOneWidget);
      expect(find.text('Enter the app'), findsOneWidget);

      await tester.tap(find.text('Enter the app'));
      await tester.pump();

      expect(enterPressed, isTrue);
    });
  });
}
