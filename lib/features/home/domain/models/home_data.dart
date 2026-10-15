import 'package:flutter/material.dart';

class HomeEventSummary {
  const HomeEventSummary({
    required this.id,
    required this.title,
    required this.dateAndVenue,
    required this.seatsInfo,
    required this.status,
    required this.icon,
    required this.brandColor1,
    required this.brandColor2,
    this.isLive = false,
    this.isRegistered = false,
  });

  final String id;
  final String title;
  final String dateAndVenue;
  final String seatsInfo;
  final String status;
  final IconData icon;
  final String brandColor1;
  final String brandColor2;
  final bool isLive;
  final bool isRegistered;
}

class ProjectShortcut {
  const ProjectShortcut({
    required this.id,
    required this.name,
    required this.techStack,
    required this.icon,
    required this.brandColor1,
    required this.brandColor2,
  });

  final String id;
  final String name;
  final String techStack;
  final IconData icon;
  final String brandColor1;
  final String brandColor2;
}

class ActivityCardItem {
  const ActivityCardItem({
    required this.name,
    required this.action,
    required this.timeAgo,
    required this.colorIndex,
  });

  final String name;
  final String action;
  final String timeAgo;
  final int colorIndex;
}
