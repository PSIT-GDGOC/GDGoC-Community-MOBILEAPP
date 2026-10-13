import 'package:flutter/material.dart';

/// Spacing tokens matching the GDGoC design system scale.
abstract final class GdgSpacing {
  static const double sp1 = 4.0;
  static const double sp2 = 8.0;
  static const double sp3 = 12.0;
  static const double sp4 = 16.0;
  static const double sp5 = 20.0; // Default page padding
  static const double sp6 = 24.0;
  static const double sp8 = 32.0;
  static const double sp10 = 40.0;
  static const double sp12 = 48.0;

  /// Minimum accessible touch target per Material 3 guidelines (48dp).
  static const double minTouchTarget = 48.0;

  /// Page horizontal padding (20dp).
  static const EdgeInsets pagePadding = EdgeInsets.symmetric(horizontal: sp5);

  /// Standard screen content padding.
  static const EdgeInsets screenPadding = EdgeInsets.fromLTRB(sp5, sp2, sp5, sp6);
}
