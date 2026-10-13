import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/shapes.dart';
import '../../../../core/theme/typography.dart';

/// 6-digit OTP Pin Input Field matching Screen 03.
class OtpInputField extends StatefulWidget {
  const OtpInputField({
    super.key,
    required this.onChanged,
    this.onCompleted,
    this.length = 6,
  });

  final ValueChanged<String> onChanged;
  final ValueChanged<String>? onCompleted;
  final int length;

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _currentCode =>
      _controllers.map((c) => c.text).join();

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (value.length > 1) {
        // Handle paste
        final digits = value.replaceAll(RegExp(r'\D'), '');
        for (int i = 0; i < widget.length && i < digits.length; i++) {
          _controllers[i].text = digits[i];
        }
        final nextIndex = digits.length < widget.length ? digits.length : widget.length - 1;
        _focusNodes[nextIndex].requestFocus();
      } else {
        if (index < widget.length - 1) {
          _focusNodes[index + 1].requestFocus();
        }
      }
    }

    final code = _currentCode;
    widget.onChanged(code);
    if (code.length == widget.length) {
      widget.onCompleted?.call(code);
    }
    setState(() {});
  }

  void _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
      widget.onChanged(_currentCode);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (index) {
        final hasFocus = _focusNodes[index].hasFocus;

        return KeyboardListener(
          focusNode: FocusNode(),
          onKeyEvent: (event) => _onKeyEvent(index, event),
          child: Container(
            width: 48,
            height: 56,
            decoration: BoxDecoration(
              color: hasFocus ? colors.surface : colors.surfaceAlt,
              borderRadius: GdgShapes.xs,
              border: Border(
                bottom: BorderSide(
                  color: hasFocus ? colors.primary : colors.onSurface3,
                  width: hasFocus ? 2.0 : 1.0,
                ),
              ),
              boxShadow: hasFocus
                  ? [
                      BoxShadow(
                        color: colors.primary.withAlpha(30),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            alignment: Alignment.center,
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              style: GdgTypography.mono(
                context,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (val) => _onDigitChanged(index, val),
            ),
          ),
        );
      }),
    );
  }
}
