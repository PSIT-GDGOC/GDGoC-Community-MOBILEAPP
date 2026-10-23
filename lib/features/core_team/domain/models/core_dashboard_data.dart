import 'package:flutter/material.dart';
import '../../../../core/widgets/gdg_card.dart';

/// KPI card data for the Organizer Dashboard (Screen 12).
class CoreKpiItem {
  const CoreKpiItem({
    required this.count,
    required this.label,
    required this.tint,
    required this.icon,
  });

  final String count;
  final String label;
  final GdgCardTint tint;
  final IconData icon;
}

/// An urgent/priority item in the "Needs your attention" section of Screen 12.
class AttentionItem {
  const AttentionItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colorKey,
    this.route,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final String colorKey; // 'yellow', 'blue', 'green', 'red'
  final String? route;
}

/// Team member model for the Team card on Screen 12.
class CoreTeamMember {
  const CoreTeamMember({
    required this.name,
    required this.role,
    this.colorIndex = 0,
    this.avatarUrl,
  });

  final String name;
  final String role;
  final int colorIndex;
  final String? avatarUrl;
}
