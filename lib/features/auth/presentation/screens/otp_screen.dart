import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/widgets/gdg_button.dart';
import '../controllers/auth_controller.dart';
import '../widgets/otp_input_field.dart';

/// Screen 03: 6-Digit OTP Verification Screen with Resend Timer and Verifying State.
class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({
    super.key,
    required this.onVerificationSuccessful,
    this.onBackPressed,
  });

  final VoidCallback onVerificationSuccessful;
  final VoidCallback? onBackPressed;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  String _enteredOtp = '';
  int _resendSeconds = 24;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _countdownTimer?.cancel();
    setState(() => _resendSeconds = 24);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0) {
        setState(() => _resendSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _verify(String otp) async {
    final success = await ref
        .read(authControllerProvider.notifier)
        .verifyOtp(otp: otp.isNotEmpty ? otp : _enteredOtp);

    if (success && mounted) {
      widget.onVerificationSuccessful();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;
    final authState = ref.watch(authControllerProvider);
    final isVerifying = authState.status == AuthStatus.verifying;

    return Scaffold(
      appBar: AppBar(
        leading: widget.onBackPressed != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: widget.onBackPressed,
              )
            : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: GdgSpacing.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter the 6-digit code',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: GdgSpacing.sp2),
              Text(
                'Sent to ${authState.email}',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: colors.onSurface2,
                    ),
              ),
              const SizedBox(height: GdgSpacing.sp8),

              // OTP Boxes
              OtpInputField(
                onChanged: (val) => setState(() => _enteredOtp = val),
                onCompleted: (code) => _verify(code),
              ),
              const SizedBox(height: GdgSpacing.sp4),

              // Resend countdown
              Row(
                children: [
                  Text(
                    'Resend in ',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: colors.onSurface2,
                        ),
                  ),
                  Text(
                    '0:${_resendSeconds.toString().padLeft(2, '0')}',
                    style: GdgTypography.mono(
                      context,
                      color: colors.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_resendSeconds == 0) ...[
                    const SizedBox(width: GdgSpacing.sp2),
                    GestureDetector(
                      onTap: () {
                        _startTimer();
                        ref.read(authControllerProvider.notifier).sendOtp(
                              rollNumber: authState.rollNumber,
                              email: authState.email,
                            );
                      },
                      child: Text(
                        'Resend now',
                        style: TextStyle(
                          color: colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              if (authState.errorMessage != null) ...[
                const SizedBox(height: GdgSpacing.sp3),
                Text(
                  authState.errorMessage!,
                  style: TextStyle(color: colors.brandRed, fontSize: 13),
                ),
              ],

              const Spacer(),

              if (isVerifying)
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: GdgSpacing.sp3),
                    Text(
                      'Checking your roll number against PSIT records',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: colors.onSurface2,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              else
                GdgFilledButton(
                  isWide: true,
                  onPressed: _enteredOtp.length == 6 ? () => _verify(_enteredOtp) : null,
                  child: const Text('Verify'),
                ),

              const SizedBox(height: GdgSpacing.sp2),
              Center(
                child: TextButton(
                  onPressed: widget.onBackPressed,
                  child: const Text('Wrong email? Go back'),
                ),
              ),
              const SizedBox(height: GdgSpacing.sp4),
            ],
          ),
        ),
      ),
    );
  }
}
