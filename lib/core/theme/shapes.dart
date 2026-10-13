import 'package:flutter/material.dart';

/// Shape and radius tokens from the GDGoC design system.
abstract final class GdgShapes {
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusLgInc = 20.0;
  static const double radiusXl = 28.0;
  static const double radiusXlInc = 32.0;
  static const double radiusXxl = 48.0;
  static const double radiusFull = 999.0;

  static const BorderRadius xs = BorderRadius.all(Radius.circular(radiusXs));
  static const BorderRadius sm = BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius md = BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius lg = BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius lgInc = BorderRadius.all(Radius.circular(radiusLgInc));
  static const BorderRadius xl = BorderRadius.all(Radius.circular(radiusXl));
  static const BorderRadius xlInc = BorderRadius.all(Radius.circular(radiusXlInc));
  static const BorderRadius xxl = BorderRadius.all(Radius.circular(radiusXxl));
  static const BorderRadius full = BorderRadius.all(Radius.circular(radiusFull));

  /// Bottom sheet top corners (28dp).
  static const BorderRadius sheetTop = BorderRadius.vertical(top: Radius.circular(radiusXl));
}
