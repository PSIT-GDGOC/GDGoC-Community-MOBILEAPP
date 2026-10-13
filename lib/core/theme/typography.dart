import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

/// Typography scale from the GDGoC Material 3 design system.
abstract final class GdgTypography {
  static TextTheme createTextTheme(GdgColors colors) {
    final onSurface = colors.onSurface;

    return TextTheme(
      // Display
      displayMedium: GoogleFonts.roboto(
        fontSize: 45,
        height: 52 / 45,
        fontWeight: FontWeight.w400,
        color: onSurface,
      ),
      displaySmall: GoogleFonts.roboto(
        fontSize: 36,
        height: 44 / 36,
        fontWeight: FontWeight.w400,
        color: onSurface,
      ),

      // Headline
      headlineMedium: GoogleFonts.roboto(
        fontSize: 28,
        height: 36 / 28,
        fontWeight: FontWeight.w400,
        color: onSurface,
      ),
      headlineSmall: GoogleFonts.roboto(
        fontSize: 24,
        height: 32 / 24,
        fontWeight: FontWeight.w400,
        color: onSurface,
      ),

      // Title
      titleLarge: GoogleFonts.roboto(
        fontSize: 22,
        height: 28 / 22,
        fontWeight: FontWeight.w400,
        color: onSurface,
      ),
      titleMedium: GoogleFonts.roboto(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: onSurface,
      ),
      titleSmall: GoogleFonts.roboto(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.10,
        color: onSurface,
      ),

      // Body
      bodyLarge: GoogleFonts.roboto(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.50,
        color: onSurface,
      ),
      bodyMedium: GoogleFonts.roboto(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: onSurface,
      ),
      bodySmall: GoogleFonts.roboto(
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.40,
        color: colors.onSurface2,
      ),

      // Label
      labelLarge: GoogleFonts.roboto(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.10,
        color: onSurface,
      ),
      labelMedium: GoogleFonts.roboto(
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.50,
        color: colors.onSurface2,
      ),
      labelSmall: GoogleFonts.roboto(
        fontSize: 11,
        height: 16 / 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.50,
        color: colors.onSurface3,
      ),
    );
  }

  /// Monospace style for roll numbers, IDs, and code metrics.
  static TextStyle mono(BuildContext context, {Color? color, double fontSize = 12, FontWeight fontWeight = FontWeight.w400}) {
    final colors = context.gdgColors;
    return GoogleFonts.robotoMono(
      fontSize: fontSize,
      height: 16 / 12,
      fontWeight: fontWeight,
      color: color ?? colors.onSurface,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }
}
