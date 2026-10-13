import 'package:flutter/material.dart';

/// Spring and motion tokens from the GDGoC design system.
/// Defined with mass = 1.0, stiffness, and damping ratio.
abstract final class GdgMotion {
  /// Small, snappy movement (damping ratio 0.6, stiffness 800).
  static final SpringDescription spatialFast = SpringDescription.withDampingRatio(
    mass: 1.0,
    stiffness: 800.0,
    ratio: 0.6,
  );

  /// Standard movement: card deck release, scrolling (damping ratio 0.8, stiffness 380).
  static final SpringDescription spatialDefault = SpringDescription.withDampingRatio(
    mass: 1.0,
    stiffness: 380.0,
    ratio: 0.8,
  );

  /// Large entrances, success pop-in (damping ratio 0.8, stiffness 200).
  static final SpringDescription spatialSlow = SpringDescription.withDampingRatio(
    mass: 1.0,
    stiffness: 200.0,
    ratio: 0.8,
  );

  /// Quick fades (critically damped, stiffness 3800).
  static final SpringDescription effectsFast = SpringDescription.withDampingRatio(
    mass: 1.0,
    stiffness: 3800.0,
    ratio: 1.0,
  );

  /// Standard fades (critically damped, stiffness 1600).
  static final SpringDescription effectsDefault = SpringDescription.withDampingRatio(
    mass: 1.0,
    stiffness: 1600.0,
    ratio: 1.0,
  );

  /// Slow fades (critically damped, stiffness 800).
  static final SpringDescription effectsSlow = SpringDescription.withDampingRatio(
    mass: 1.0,
    stiffness: 800.0,
    ratio: 1.0,
  );

  /// Estimated duration for spatialFast (~220ms).
  static const Duration durationFast = Duration(milliseconds: 220);

  /// Estimated duration for spatialDefault (~350ms).
  static const Duration durationDefault = Duration(milliseconds: 350);

  /// Estimated duration for spatialSlow (~500ms).
  static const Duration durationSlow = Duration(milliseconds: 500);

  /// Item entrance stagger offset (40ms).
  static const Duration staggerStep = Duration(milliseconds: 40);

  /// Returns true if animations should be skipped or disabled for accessibility.
  static bool shouldDisableAnimations(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }
}
