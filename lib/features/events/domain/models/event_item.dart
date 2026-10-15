import 'package:flutter/material.dart';

enum EventRegistrationStatus {
  registered,
  waitlist,
  open,
  attended;

  String get displayName => switch (this) {
        EventRegistrationStatus.registered => 'Registered',
        EventRegistrationStatus.waitlist => 'Waitlist',
        EventRegistrationStatus.open => 'Open',
        EventRegistrationStatus.attended => 'Attended',
      };
}

class EventSpeaker {
  const EventSpeaker({
    required this.name,
    required this.role,
    this.colorIndex = 0,
  });

  final String name;
  final String role;
  final int colorIndex;
}

class EventItem {
  const EventItem({
    required this.id,
    required this.title,
    required this.eventCode,
    required this.date,
    required this.time,
    required this.venue,
    required this.seatsInfo,
    required this.totalSeats,
    required this.registeredSeats,
    required this.status,
    required this.icon,
    required this.brandColor1,
    required this.brandColor2,
    this.isLive = false,
    this.about = '',
    this.speakers = const [],
    this.learnings = const [],
    this.isUserRegistered = false,
    this.ticketCode,
  });

  final String id;
  final String title;
  final String eventCode;
  final String date;
  final String time;
  final String venue;
  final String seatsInfo;
  final int totalSeats;
  final int registeredSeats;
  final EventRegistrationStatus status;
  final IconData icon;
  final String brandColor1;
  final String brandColor2;
  final bool isLive;
  final String about;
  final List<EventSpeaker> speakers;
  final List<String> learnings;
  final bool isUserRegistered;
  final String? ticketCode;

  String get dateAndVenue => '$date · $time · $venue';

  EventItem copyWith({
    String? id,
    String? title,
    String? eventCode,
    String? date,
    String? time,
    String? venue,
    String? seatsInfo,
    int? totalSeats,
    int? registeredSeats,
    EventRegistrationStatus? status,
    IconData? icon,
    String? brandColor1,
    String? brandColor2,
    bool? isLive,
    String? about,
    List<EventSpeaker>? speakers,
    List<String>? learnings,
    bool? isUserRegistered,
    String? ticketCode,
  }) {
    return EventItem(
      id: id ?? this.id,
      title: title ?? this.title,
      eventCode: eventCode ?? this.eventCode,
      date: date ?? this.date,
      time: time ?? this.time,
      venue: venue ?? this.venue,
      seatsInfo: seatsInfo ?? this.seatsInfo,
      totalSeats: totalSeats ?? this.totalSeats,
      registeredSeats: registeredSeats ?? this.registeredSeats,
      status: status ?? this.status,
      icon: icon ?? this.icon,
      brandColor1: brandColor1 ?? this.brandColor1,
      brandColor2: brandColor2 ?? this.brandColor2,
      isLive: isLive ?? this.isLive,
      about: about ?? this.about,
      speakers: speakers ?? this.speakers,
      learnings: learnings ?? this.learnings,
      isUserRegistered: isUserRegistered ?? this.isUserRegistered,
      ticketCode: ticketCode ?? this.ticketCode,
    );
  }
}
