import 'package:flutter/material.dart';
import '../../../../core/widgets/gdg_chip.dart';

/// Represents an event in the Manage Events screen (Screen 13).
class ManageEventItem {
  const ManageEventItem({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.venue,
    required this.registeredSeats,
    required this.totalSeats,
    this.isLiveNow = false,
    this.isPast = false,
    this.statusTone = GdgChipTone.blue,
    this.statusLabel,
    this.icon = Icons.event_outlined,
    this.description,
  });

  final String id;
  final String title;
  final String date;
  final String time;
  final String venue;
  final int registeredSeats;
  final int totalSeats;
  final bool isLiveNow;
  final bool isPast;
  final GdgChipTone statusTone;
  final String? statusLabel;
  final IconData icon;
  final String? description;

  String get dateAndVenue => '$date · $time · $venue';

  double get progress =>
      totalSeats > 0 ? (registeredSeats / totalSeats).clamp(0.0, 1.0) : 0.0;

  String get registrationRatioText => '$registeredSeats / $totalSeats registered';

  bool get isFull => registeredSeats >= totalSeats;

  ManageEventItem copyWith({
    String? id,
    String? title,
    String? date,
    String? time,
    String? venue,
    int? registeredSeats,
    int? totalSeats,
    bool? isLiveNow,
    bool? isPast,
    GdgChipTone? statusTone,
    String? statusLabel,
    IconData? icon,
    String? description,
  }) {
    return ManageEventItem(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      time: time ?? this.time,
      venue: venue ?? this.venue,
      registeredSeats: registeredSeats ?? this.registeredSeats,
      totalSeats: totalSeats ?? this.totalSeats,
      isLiveNow: isLiveNow ?? this.isLiveNow,
      isPast: isPast ?? this.isPast,
      statusTone: statusTone ?? this.statusTone,
      statusLabel: statusLabel ?? this.statusLabel,
      icon: icon ?? this.icon,
      description: description ?? this.description,
    );
  }
}
