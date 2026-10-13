import 'package:flutter/material.dart';
import 'colors.dart';
import 'shapes.dart';
import 'spacing.dart';
import 'typography.dart';

export 'colors.dart';
export 'motion.dart';
export 'shapes.dart';
export 'spacing.dart';
export 'typography.dart';

abstract final class AppTheme {
  static ThemeData get lightTheme {
    const colors = GdgColors.light;
    final textTheme = GdgTypography.createTextTheme(colors);

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: colors.canvas,
      colorScheme: ColorScheme.light(
        primary: colors.primary,
        onPrimary: colors.onPrimary,
        surface: colors.surface,
        onSurface: colors.onSurface,
        outline: colors.outline,
      ),
      textTheme: textTheme,
      extensions: const [colors],
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: GdgShapes.lg,
          side: BorderSide(color: colors.outline, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          minimumSize: const Size(0, GdgSpacing.minTouchTarget),
          shape: const RoundedRectangleBorder(borderRadius: GdgShapes.full),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primary,
          minimumSize: const Size(0, GdgSpacing.minTouchTarget),
          side: BorderSide(color: colors.outline, width: 1),
          shape: const RoundedRectangleBorder(borderRadius: GdgShapes.full),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          minimumSize: const Size(0, GdgSpacing.minTouchTarget),
          textStyle: textTheme.labelLarge,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colors.surfaceAlt,
        side: BorderSide(color: colors.outline, width: 1),
        shape: const RoundedRectangleBorder(borderRadius: GdgShapes.full),
        labelStyle: textTheme.labelMedium,
      ),
      dividerTheme: DividerThemeData(
        color: colors.outline,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
