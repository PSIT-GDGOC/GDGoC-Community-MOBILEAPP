import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/shapes.dart';
import '../../../../core/theme/spacing.dart';
import '../../../../core/widgets/gdg_button.dart';

/// Dialog for manually entering a ticket code or student roll number.
class ManualCodeDialog extends StatefulWidget {
  const ManualCodeDialog({
    super.key,
    required this.onSubmit,
  });

  final ValueChanged<String> onSubmit;

  static Future<void> show(
    BuildContext context, {
    required ValueChanged<String> onSubmit,
  }) {
    return showDialog(
      context: context,
      builder: (context) => ManualCodeDialog(onSubmit: onSubmit),
    );
  }

  @override
  State<ManualCodeDialog> createState() => _ManualCodeDialogState();
}

class _ManualCodeDialogState extends State<ManualCodeDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final code = _controller.text.trim();
    Navigator.of(context).pop();
    widget.onSubmit(code);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;

    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: GdgShapes.xl),
      backgroundColor: colors.surface,
      insetPadding: const EdgeInsets.all(GdgSpacing.sp4),
      child: Padding(
        padding: const EdgeInsets.all(GdgSpacing.sp5),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: colors.tintBlue,
                      borderRadius: GdgShapes.sm,
                    ),
                    child: Icon(
                      Icons.keyboard_outlined,
                      color: colors.onTintBlue,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: GdgSpacing.sp3),
                  Text(
                    'Enter Ticket Code',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: GdgSpacing.sp3),
              Text(
                'Enter the ticket ID (e.g. HF26-KICK-0567) displayed on the member\'s pass.',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: colors.onSurface2,
                    ),
              ),
              const SizedBox(height: GdgSpacing.sp4),
              TextFormField(
                controller: _controller,
                autofocus: true,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'Ticket ID or Code',
                  hintText: 'HF26-KICK-0567',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.confirmation_number_outlined),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter a ticket code';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: GdgSpacing.sp5),
              GdgFilledButton(
                isWide: true,
                onPressed: _submit,
                child: const Text('Validate & Mark Attendance'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
