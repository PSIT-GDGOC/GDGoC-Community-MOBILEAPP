import 'package:flutter/material.dart';
import '../domain/models/event_item.dart';

abstract interface class EventsRepository {
  Future<List<EventItem>> getEvents({String filter = 'all'});

  Future<EventItem?> getEventById(String id);

  Future<EventItem> registerForEvent(String id, {required String rollNumber});

  Future<EventItem> joinWaitlist(String id);
}

class FakeEventsRepository implements EventsRepository {
  FakeEventsRepository({List<EventItem>? initialEvents})
      : _events = List.of(initialEvents ?? defaultEvents);

  final List<EventItem> _events;

  static const List<EventItem> defaultEvents = [
    EventItem(
      id: 'evt_kickoff',
      title: 'Hacktoberfest 2026 Kickoff',
      eventCode: 'HF26-KICK',
      date: 'Sat 10 Oct',
      time: '11:00 AM',
      venue: 'Seminar Hall',
      seatsInfo: '147 of 150',
      totalSeats: 150,
      registeredSeats: 147,
      status: EventRegistrationStatus.registered,
      icon: Icons.emoji_events_outlined,
      brandColor1: 'blue',
      brandColor2: 'green',
      isLive: true,
      about:
          'Kick off the open-source month with a talk, a live Git demo and your first issue claim.',
      speakers: [
        EventSpeaker(name: 'Rohan Gupta', role: 'Organizer', colorIndex: 0),
        EventSpeaker(name: 'Dr. Neha Agarwal', role: 'Mentor', colorIndex: 1),
      ],
      learnings: [
        'Fork, branch and open a pull request',
        'Pick a beginner issue',
        'How points reach the Board',
      ],
      isUserRegistered: true,
      ticketCode: 'HF26-KICK-0567',
    ),
    EventItem(
      id: 'evt_flutter',
      title: 'Intro to Flutter Workshop',
      eventCode: 'FLTR-W14',
      date: 'Wed 14 Oct',
      time: '2:00 PM',
      venue: 'Lab 4',
      seatsInfo: '100 of 100',
      totalSeats: 100,
      registeredSeats: 100,
      status: EventRegistrationStatus.waitlist,
      icon: Icons.flutter_dash,
      brandColor1: 'blue',
      brandColor2: 'yellow',
      about:
          'Hands-on deep dive into Flutter widgets, declarative state, and hot reload.',
      speakers: [
        EventSpeaker(name: 'Vivek Yadav', role: 'Core Team', colorIndex: 2),
      ],
      learnings: [
        'Build your first Flutter layout',
        'State management patterns',
        'Publishing to web and mobile',
      ],
    ),
    EventItem(
      id: 'evt_gcp',
      title: 'Cloud Study Jam: GCP Fundamentals',
      eventCode: 'GCP-JAM',
      date: 'Sat 17 Oct',
      time: '10:00 AM',
      venue: 'CS Block 201',
      seatsInfo: '64 of 80',
      totalSeats: 80,
      registeredSeats: 64,
      status: EventRegistrationStatus.open,
      icon: Icons.cloud_outlined,
      brandColor1: 'blue',
      brandColor2: 'red',
      about:
          'Explore Google Cloud Platform console, IAM permissions, Cloud Run, and compute instances.',
      speakers: [
        EventSpeaker(name: 'Ananya Mishra', role: 'Cloud Lead', colorIndex: 3),
      ],
      learnings: [
        'Navigating GCP Console',
        'Deploying a containerized app to Cloud Run',
        'Earn Google Cloud badges',
      ],
    ),
    EventItem(
      id: 'evt_build_night',
      title: 'AI/ML Build Night',
      eventCode: 'AIML-NIGHT',
      date: 'Thu 22 Oct',
      time: '5:00 PM',
      venue: 'Innovation Lab',
      seatsInfo: '38 of 60',
      totalSeats: 60,
      registeredSeats: 38,
      status: EventRegistrationStatus.open,
      icon: Icons.psychology_outlined,
      brandColor1: 'red',
      brandColor2: 'green',
      about:
          'Collaborative evening experimenting with Gemini API, prompt engineering, and embeddings.',
      speakers: [
        EventSpeaker(name: 'Kabir Singh', role: 'AI Specialist', colorIndex: 1),
      ],
      learnings: [
        'Integrating Gemini 2.0 API',
        'Structured JSON outputs',
        'Building multimodal apps',
      ],
    ),
    EventItem(
      id: 'evt_demo_day',
      title: 'Demo Day · Semester End',
      eventCode: 'DEMO-DAY',
      date: 'Fri 30 Oct',
      time: '3:00 PM',
      venue: 'Auditorium',
      seatsInfo: '12 of 200',
      totalSeats: 200,
      registeredSeats: 12,
      status: EventRegistrationStatus.open,
      icon: Icons.present_to_all_outlined,
      brandColor1: 'green',
      brandColor2: 'blue',
      about:
          'Celebrate student projects, watch live lightning demos, and celebrate Board winners.',
      speakers: [
        EventSpeaker(name: 'Ishita Verma', role: 'Chapter Lead', colorIndex: 0),
      ],
      learnings: [
        'Presenting software to stakeholders',
        'Chapter awards ceremony',
        'Networking with alumni',
      ],
    ),
    EventItem(
      id: 'evt_android_bootcamp',
      title: 'Android Basics Bootcamp',
      eventCode: 'AND-BC',
      date: 'Thu 1 Oct',
      time: '4:00 PM',
      venue: 'Seminar Hall',
      seatsInfo: 'Past event',
      totalSeats: 100,
      registeredSeats: 98,
      status: EventRegistrationStatus.attended,
      icon: Icons.android_outlined,
      brandColor1: 'green',
      brandColor2: 'yellow',
      about:
          'Introduction to Kotlin syntax, Android Studio setup, and building your first native app.',
      speakers: [
        EventSpeaker(name: 'Sanya Khan', role: 'Android Lead', colorIndex: 3),
      ],
      learnings: [
        'Kotlin essentials',
        'Compose preview and layout basics',
        'Activity lifecycle',
      ],
    ),
  ];

  @override
  Future<List<EventItem>> getEvents({String filter = 'all'}) async {
    final lower = filter.toLowerCase();
    if (lower == 'all') return List.unmodifiable(_events);

    return List.unmodifiable(_events.where((e) {
      return switch (lower) {
        'open' => e.status == EventRegistrationStatus.open,
        'registered' => e.status == EventRegistrationStatus.registered,
        'waitlist' => e.status == EventRegistrationStatus.waitlist,
        'past' => e.status == EventRegistrationStatus.attended,
        _ => true,
      };
    }));
  }

  @override
  Future<EventItem?> getEventById(String id) async {
    try {
      return _events.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<EventItem> registerForEvent(String id, {required String rollNumber}) async {
    final index = _events.indexWhere((e) => e.id == id);
    if (index == -1) throw Exception('Event not found');

    final event = _events[index];
    final last4 = rollNumber.length >= 4
        ? rollNumber.substring(rollNumber.length - 4)
        : '0567';
    final ticketCode = '${event.eventCode}-$last4';

    final updated = event.copyWith(
      status: EventRegistrationStatus.registered,
      isUserRegistered: true,
      registeredSeats: event.registeredSeats + 1,
      seatsInfo: '${event.registeredSeats + 1} of ${event.totalSeats}',
      ticketCode: ticketCode,
    );

    _events[index] = updated;
    return updated;
  }

  @override
  Future<EventItem> joinWaitlist(String id) async {
    final index = _events.indexWhere((e) => e.id == id);
    if (index == -1) throw Exception('Event not found');

    final event = _events[index];
    final updated = event.copyWith(
      status: EventRegistrationStatus.waitlist,
    );

    _events[index] = updated;
    return updated;
  }
}
