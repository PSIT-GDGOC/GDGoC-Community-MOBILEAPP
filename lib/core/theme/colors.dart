import 'package:flutter/material.dart';

/// Exact color tokens from the GDGoC Material 3 design system.
/// Values align 1:1 with gdgoc-chapter-app-mockups_new-with-flow.html
@immutable
class GdgColors extends ThemeExtension<GdgColors> {
  const GdgColors({
    this.canvas = const Color(0xFFF8F9FA),
    this.surface = const Color(0xFFFFFFFF),
    this.surfaceAlt = const Color(0xFFF1F3F4),
    this.outline = const Color(0xFFDADCE0),
    this.onSurface = const Color(0xFF202124),
    this.onSurface2 = const Color(0xFF5F6368),
    this.onSurface3 = const Color(0xFF80868B),
    this.primary = const Color(0xFF1A73E8),
    this.primaryPress = const Color(0xFF1967D2),
    this.onPrimary = const Color(0xFFFFFFFF),
    this.brandBlue = const Color(0xFF4285F4),
    this.brandRed = const Color(0xFFEA4335),
    this.brandYellow = const Color(0xFFFBBC04),
    this.brandGreen = const Color(0xFF34A853),
    this.tintBlue = const Color(0xFFE8F0FE),
    this.tintRed = const Color(0xFFFCE8E6),
    this.tintYellow = const Color(0xFFFEF7E0),
    this.tintGreen = const Color(0xFFE6F4EA),
    this.onTintBlue = const Color(0xFF174EA6),
    this.onTintGreen = const Color(0xFF137333),
    this.onTintRed = const Color(0xFFB31412),
    this.onTintAmber = const Color(0xFF7A4700),
  });

  final Color canvas;
  final Color surface;
  final Color surfaceAlt;
  final Color outline;
  final Color onSurface;
  final Color onSurface2;
  final Color onSurface3;
  final Color primary;
  final Color primaryPress;
  final Color onPrimary;
  final Color brandBlue;
  final Color brandRed;
  final Color brandYellow;
  final Color brandGreen;
  final Color tintBlue;
  final Color tintRed;
  final Color tintYellow;
  final Color tintGreen;
  final Color onTintBlue;
  final Color onTintGreen;
  final Color onTintRed;
  final Color onTintAmber;

  static const GdgColors light = GdgColors();

  @override
  GdgColors copyWith({
    Color? canvas,
    Color? surface,
    Color? surfaceAlt,
    Color? outline,
    Color? onSurface,
    Color? onSurface2,
    Color? onSurface3,
    Color? primary,
    Color? primaryPress,
    Color? onPrimary,
    Color? brandBlue,
    Color? brandRed,
    Color? brandYellow,
    Color? brandGreen,
    Color? tintBlue,
    Color? tintRed,
    Color? tintYellow,
    Color? tintGreen,
    Color? onTintBlue,
    Color? onTintGreen,
    Color? onTintRed,
    Color? onTintAmber,
  }) {
    return GdgColors(
      canvas: canvas ?? this.canvas,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      outline: outline ?? this.outline,
      onSurface: onSurface ?? this.onSurface,
      onSurface2: onSurface2 ?? this.onSurface2,
      onSurface3: onSurface3 ?? this.onSurface3,
      primary: primary ?? this.primary,
      primaryPress: primaryPress ?? this.primaryPress,
      onPrimary: onPrimary ?? this.onPrimary,
      brandBlue: brandBlue ?? this.brandBlue,
      brandRed: brandRed ?? this.brandRed,
      brandYellow: brandYellow ?? this.brandYellow,
      brandGreen: brandGreen ?? this.brandGreen,
      tintBlue: tintBlue ?? this.tintBlue,
      tintRed: tintRed ?? this.tintRed,
      tintYellow: tintYellow ?? this.tintYellow,
      tintGreen: tintGreen ?? this.tintGreen,
      onTintBlue: onTintBlue ?? this.onTintBlue,
      onTintGreen: onTintGreen ?? this.onTintGreen,
      onTintRed: onTintRed ?? this.onTintRed,
      onTintAmber: onTintAmber ?? this.onTintAmber,
    );
  }

  @override
  GdgColors lerp(ThemeExtension<GdgColors>? other, double t) {
    if (other is! GdgColors) return this;
    return GdgColors(
      canvas: Color.lerp(canvas, other.canvas, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      onSurface2: Color.lerp(onSurface2, other.onSurface2, t)!,
      onSurface3: Color.lerp(onSurface3, other.onSurface3, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryPress: Color.lerp(primaryPress, other.primaryPress, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      brandBlue: Color.lerp(brandBlue, other.brandBlue, t)!,
      brandRed: Color.lerp(brandRed, other.brandRed, t)!,
      brandYellow: Color.lerp(brandYellow, other.brandYellow, t)!,
      brandGreen: Color.lerp(brandGreen, other.brandGreen, t)!,
      tintBlue: Color.lerp(tintBlue, other.tintBlue, t)!,
      tintRed: Color.lerp(tintRed, other.tintRed, t)!,
      tintYellow: Color.lerp(tintYellow, other.tintYellow, t)!,
      tintGreen: Color.lerp(tintGreen, other.tintGreen, t)!,
      onTintBlue: Color.lerp(onTintBlue, other.onTintBlue, t)!,
      onTintGreen: Color.lerp(onTintGreen, other.onTintGreen, t)!,
      onTintRed: Color.lerp(onTintRed, other.onTintRed, t)!,
      onTintAmber: Color.lerp(onTintAmber, other.onTintAmber, t)!,
    );
  }
}

/// Convenience extension for context.gdgColors
extension GdgColorsExtension on BuildContext {
  GdgColors get gdgColors =>
      Theme.of(this).extension<GdgColors>() ?? GdgColors.light;
}
