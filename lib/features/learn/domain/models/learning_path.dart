import 'package:flutter/material.dart';

/// Represents a single learning module within a learning path.
class LearningModule {
  const LearningModule({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.durationMinutes = 60,
  });

  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final int durationMinutes;

  LearningModule copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    int? durationMinutes,
  }) {
    return LearningModule(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      durationMinutes: durationMinutes ?? this.durationMinutes,
    );
  }
}

/// Brand color representation for learning tracks.
enum LearningTrackColor { blue, green, red, yellow }

/// Represents a structured learning path for students.
class LearningPath {
  const LearningPath({
    required this.id,
    required this.title,
    required this.category,
    required this.estimatedHours,
    required this.modules,
    this.iconData = Icons.school_rounded,
    this.trackColor = LearningTrackColor.blue,
  });

  final String id;
  final String title;
  final String category;
  final int estimatedHours;
  final List<LearningModule> modules;
  final IconData iconData;
  final LearningTrackColor trackColor;

  /// Dynamic count of completed modules.
  int get completedModules => modules.where((m) => m.isCompleted).length;

  /// Dynamic total modules count.
  int get totalModules => modules.length;

  /// Dynamic progress normalized between 0.0 and 1.0.
  double get progressRatio => totalModules == 0
      ? 0.0
      : (completedModules / totalModules).clamp(0.0, 1.0);

  /// Progress percentage (0 to 100).
  double get progressPercentage => progressRatio * 100;

  /// Progress metadata string in exact format: `6 of 10 modules · 24 hours`
  String get progressMetadata =>
      '$completedModules of $totalModules modules · $estimatedHours hours';

  /// Whether all modules have been completed.
  bool get isCompleted => totalModules > 0 && completedModules == totalModules;

  /// Whether learning has started.
  bool get isStarted => completedModules > 0;

  /// Action button label based on progress state.
  String get actionLabel {
    if (isCompleted) return 'Review';
    if (isStarted) return 'Continue';
    return 'Start';
  }

  LearningPath copyWith({
    String? id,
    String? title,
    String? category,
    int? estimatedHours,
    List<LearningModule>? modules,
    IconData? iconData,
    LearningTrackColor? trackColor,
  }) {
    return LearningPath(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      modules: modules ?? this.modules,
      iconData: iconData ?? this.iconData,
      trackColor: trackColor ?? this.trackColor,
    );
  }
}
