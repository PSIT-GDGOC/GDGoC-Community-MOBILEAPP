import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/shapes.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/theme/typography.dart';
import '../../../../core/widgets/gdg_button.dart';
import '../controllers/auth_controller.dart';

/// Screen 02: Join and Verify PSIT roll number and linked Gmail.
class VerifyScreen extends ConsumerStatefulWidget {
  const VerifyScreen({
    super.key,
    required this.onVerificationCodeSent,
    this.onBackPressed,
  });

  final VoidCallback onVerificationCodeSent;
  final VoidCallback? onBackPressed;

  @override
  ConsumerState<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends ConsumerState<VerifyScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _rollController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final authState = ref.read(authControllerProvider);
    _rollController = TextEditingController(text: authState.rollNumber);
    _emailController = TextEditingController(text: authState.email);
  }

  @override
  void dispose() {
    _rollController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authControllerProvider.notifier).sendOtp(
          rollNumber: _rollController.text.trim(),
          email: _emailController.text.trim(),
        );

    if (success && mounted) {
      widget.onVerificationCodeSent();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.status == AuthStatus.sendingOtp;

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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Verify your PSIT account',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: GdgSpacing.sp2),
                Text(
                  'We match your roll number with PSIT records.',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: colors.onSurface2,
                      ),
                ),
                const SizedBox(height: GdgSpacing.sp8),

                // Roll Number Field
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: GdgSpacing.sp4,
                    vertical: GdgSpacing.sp2,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surfaceAlt,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(GdgShapes.radiusXs)),
                    border: Border(
                      bottom: BorderSide(color: colors.primary, width: 2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Roll number',
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                              color: colors.primary,
                            ),
                      ),
                      TextFormField(
                        controller: _rollController,
                        keyboardType: TextInputType.number,
                        maxLength: 13,
                        style: GdgTypography.mono(
                          context,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          counterText: '',
                          contentPadding: EdgeInsets.symmetric(vertical: 4),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().length != 13) {
                            return 'Enter your complete 13-digit roll number';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: GdgSpacing.sp4),

                // Gmail Field
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: GdgSpacing.sp4,
                    vertical: GdgSpacing.sp2,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surfaceAlt,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(GdgShapes.radiusXs)),
                    border: Border(
                      bottom: BorderSide(color: colors.onSurface3, width: 1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gmail',
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                              color: colors.onSurface2,
                            ),
                      ),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: Theme.of(context).textTheme.bodyLarge,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 4),
                        ),
                        validator: (val) {
                          if (val == null || !val.trim().toLowerCase().endsWith('@gmail.com')) {
                            return 'Enter a valid @gmail.com address';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: GdgSpacing.sp2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: GdgSpacing.sp4),
                  child: Text(
                    'Use the @gmail.com address linked to your PSIT record',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: colors.onSurface2,
                        ),
                  ),
                ),

                if (authState.errorMessage != null) ...[
                  const SizedBox(height: GdgSpacing.sp3),
                  Text(
                    authState.errorMessage!,
                    style: TextStyle(color: colors.brandRed, fontSize: 13),
                  ),
                ],

                const Spacer(),

                GdgFilledButton(
                  isWide: true,
                  onPressed: isLoading ? null : _submit,
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Send verification code'),
                ),
                const SizedBox(height: GdgSpacing.sp3),
                Center(
                  child: Text(
                    "By continuing you agree to the chapter's terms and privacy policy.",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: colors.onSurface3,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: GdgSpacing.sp4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
