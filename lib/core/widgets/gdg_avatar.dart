import 'package:flutter/material.dart';
import '../theme/colors.dart';

enum GdgAvatarSize {
  sm(28.0, 11.0),
  md(40.0, 14.0),
  lg(72.0, 24.0);

  const GdgAvatarSize(this.size, this.fontSize);
  final double size;
  final double fontSize;
}

/// Circular avatar with 4-brand-color cycling and automatic initials.
class GdgAvatar extends StatelessWidget {
  const GdgAvatar({
    super.key,
    required this.name,
    this.colorIndex = 0,
    this.size = GdgAvatarSize.md,
    this.hasOutline = false,
  });

  final String name;
  final int colorIndex;
  final GdgAvatarSize size;
  final bool hasOutline;

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return '?';
    if (parts.length == 1) return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.gdgColors;

    final (Color bg, Color fg) = switch (colorIndex % 4) {
      0 => (colors.tintBlue, colors.onTintBlue),
      1 => (colors.tintGreen, colors.onTintGreen),
      2 => (colors.tintRed, colors.onTintRed),
      _ => (colors.tintYellow, colors.onTintAmber),
    };

    final initials = _getInitials(name);

    return Container(
      width: size.size,
      height: size.size,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: hasOutline
            ? Border.all(color: colors.surface, width: 2)
            : null,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: fg,
          fontSize: size.fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Stack of overlapping avatars with white borders.
class GdgAvatarStack extends StatelessWidget {
  const GdgAvatarStack({
    super.key,
    required this.names,
    this.size = GdgAvatarSize.sm,
    this.maxVisible = 3,
  });

  final List<String> names;
  final GdgAvatarSize size;
  final int maxVisible;

  @override
  Widget build(BuildContext context) {
    final visibleNames = names.take(maxVisible).toList();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < visibleNames.length; i++)
          Transform.translate(
            offset: Offset(i == 0 ? 0 : -8.0 * i, 0),
            child: GdgAvatar(
              name: visibleNames[i],
              colorIndex: i,
              size: size,
              hasOutline: true,
            ),
          ),
      ],
    );
  }
}
