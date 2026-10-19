import 'package:flutter/material.dart';
import '../../../../core/widgets/gdg_card.dart';
import '../../../../core/widgets/gdg_chip.dart';
import '../../home/domain/models/board_entry.dart';
import '../domain/models/core_dashboard_data.dart';
import '../domain/models/manage_event_item.dart';

abstract interface class CoreTeamRepository {
  Future<List<CoreKpiItem>> getDashboardKpis();
  Future<List<AttentionItem>> getAttentionItems();
  Future<List<CoreTeamMember>> getTeamMembers();
  Future<int> getTotalTeamCount();
  Future<List<BoardEntry>> getBoardEntries({String filter = 'all'});
  Future<List<ManageEventItem>> getManageEvents({bool isPast = false});
  Future<ManageEventItem> createEvent(ManageEventItem event);
  Future<ManageEventItem> updateEvent(ManageEventItem event);
  Future<void> deleteEvent(String id);
  Future<ManageEventItem> toggleLiveNow(String id);
}

class FakeCoreTeamRepository implements CoreTeamRepository {
  FakeCoreTeamRepository({
    List<ManageEventItem>? initialEvents,
  }) : _events = List.of(initialEvents ?? defaultEvents);

  final List<ManageEventItem> _events;

  static const List<CoreKpiItem> defaultKpis = [
    CoreKpiItem(
      count: '5',
      label: 'Upcoming events',
      tint: GdgCardTint.blue,
      icon: Icons.event_outlined,
    ),
    CoreKpiItem(
      count: '163',
      label: 'Registered students',
      tint: GdgCardTint.green,
      icon: Icons.how_to_reg_outlined,
    ),
    CoreKpiItem(
      count: '3',
      label: 'Projects',
      tint: GdgCardTint.yellow,
      icon: Icons.code_outlined,
    ),
    CoreKpiItem(
      count: '87',
      label: 'Merged PRs',
      tint: GdgCardTint.red,
      icon: Icons.call_merge_rounded,
    ),
  ];

  static const List<AttentionItem> defaultAttentionItems = [
    AttentionItem(
      id: 'att_prs',
      title: '8 PRs awaiting review',
      subtitle: 'Across 3 projects',
      icon: Icons.rate_review_outlined,
      colorKey: 'yellow',
      route: '/core/projects',
    ),
    AttentionItem(
      id: 'att_seats',
      title: 'Kickoff is 3 seats from full',
      subtitle: '147 of 150 registered',
      icon: Icons.event_seat_outlined,
      colorKey: 'blue',
      route: '/core/events',
    ),
    AttentionItem(
      id: 'att_waitlist',
      title: 'Workshop waitlist is open',
      subtitle: 'Intro to Flutter · 100 of 100',
      icon: Icons.hourglass_top_outlined,
      colorKey: 'green',
      route: '/core/events',
    ),
  ];

  static const List<CoreTeamMember> defaultTeamMembers = [
    CoreTeamMember(name: 'Rohan Gupta', role: 'Lead Organizer', colorIndex: 0),
    CoreTeamMember(name: 'Sanya Khan', role: 'Co-Lead', colorIndex: 1),
    CoreTeamMember(name: 'Vivek Yadav', role: 'Technical Lead', colorIndex: 2),
  ];

  static const int defaultTotalTeamCount = 14;

  static const List<BoardEntry> defaultBoardEntries = [
    BoardEntry(rank: 1, name: 'Ishita Verma', points: 1240, colorIndex: 0, rollNumber: '2501640100100'),
    BoardEntry(rank: 2, name: 'Kabir Singh', points: 1105, colorIndex: 1, rollNumber: '2501640100153'),
    BoardEntry(rank: 3, name: 'Ananya Mishra', points: 980, colorIndex: 2, rollNumber: '2501640100206'),
    BoardEntry(rank: 4, name: 'Rohan Gupta', points: 905, colorIndex: 3, rollNumber: '2501640100259', isCurrentUser: true),
    BoardEntry(rank: 5, name: 'Priya Tripathi', points: 860, colorIndex: 0, rollNumber: '2501640100312'),
    BoardEntry(rank: 6, name: 'Vivek Yadav', points: 815, colorIndex: 1, rollNumber: '2501640100365'),
    BoardEntry(rank: 7, name: 'Sanya Khan', points: 770, colorIndex: 2, rollNumber: '2501640100418'),
    BoardEntry(rank: 8, name: 'Meera Joshi', points: 690, colorIndex: 3, rollNumber: '2501640100471'),
    BoardEntry(rank: 9, name: 'Aditya Pandey', points: 640, colorIndex: 0, rollNumber: '2501640100524'),
    BoardEntry(rank: 10, name: 'Nidhi Saxena', points: 590, colorIndex: 1, rollNumber: '2501640100577'),
  ];

  static const List<ManageEventItem> defaultEvents = [
    ManageEventItem(
      id: 'evt_kickoff',
      title: 'Hacktoberfest 2026 Kickoff',
      date: 'Sat 10 Oct',
      time: '11:00 AM',
      venue: 'Seminar Hall',
      registeredSeats: 147,
      totalSeats: 150,
      isLiveNow: true,
      isPast: false,
      statusTone: GdgChipTone.blue,
      icon: Icons.emoji_events_outlined,
    ),
    ManageEventItem(
      id: 'evt_flutter',
      title: 'Intro to Flutter Workshop',
      date: 'Wed 14 Oct',
      time: '2:00 PM',
      venue: 'Lab 4',
      registeredSeats: 100,
      totalSeats: 100,
      isLiveNow: false,
      isPast: false,
      statusTone: GdgChipTone.yellow,
      icon: Icons.flutter_dash,
    ),
    ManageEventItem(
      id: 'evt_cloud',
      title: 'Cloud Study Jam: GCP Fundamentals',
      date: 'Sat 17 Oct',
      time: '10:00 AM',
      venue: 'CS Block 201',
      registeredSeats: 64,
      totalSeats: 80,
      isLiveNow: false,
      isPast: false,
      statusTone: GdgChipTone.blue,
      icon: Icons.cloud_outlined,
    ),
    ManageEventItem(
      id: 'evt_ai',
      title: 'AI/ML Build Night',
      date: 'Thu 22 Oct',
      time: '5:00 PM',
      venue: 'Innovation Lab',
      registeredSeats: 38,
      totalSeats: 60,
      isLiveNow: false,
      isPast: false,
      statusTone: GdgChipTone.blue,
      icon: Icons.psychology_outlined,
    ),
    ManageEventItem(
      id: 'evt_demoday',
      title: 'Demo Day · Semester End',
      date: 'Fri 30 Oct',
      time: '3:00 PM',
      venue: 'Auditorium',
      registeredSeats: 12,
      totalSeats: 200,
      isLiveNow: false,
      isPast: false,
      statusTone: GdgChipTone.blue,
      icon: Icons.present_to_all_outlined,
    ),
    ManageEventItem(
      id: 'evt_android_past',
      title: 'Android Basics Bootcamp',
      date: 'Thu 1 Oct',
      time: '4:00 PM',
      venue: 'Seminar Hall',
      registeredSeats: 150,
      totalSeats: 150,
      isLiveNow: false,
      isPast: true,
      statusTone: GdgChipTone.green,
      icon: Icons.android_outlined,
    ),
  ];

  @override
  Future<List<CoreKpiItem>> getDashboardKpis() async {
    return defaultKpis;
  }

  @override
  Future<List<AttentionItem>> getAttentionItems() async {
    return defaultAttentionItems;
  }

  @override
  Future<List<CoreTeamMember>> getTeamMembers() async {
    return defaultTeamMembers;
  }

  @override
  Future<int> getTotalTeamCount() async {
    return defaultTotalTeamCount;
  }

  @override
  Future<List<BoardEntry>> getBoardEntries({String filter = 'all'}) async {
    return defaultBoardEntries;
  }

  @override
  Future<List<ManageEventItem>> getManageEvents({bool isPast = false}) async {
    return _events.where((e) => e.isPast == isPast).toList();
  }

  @override
  Future<ManageEventItem> createEvent(ManageEventItem event) async {
    final newEvent = event.copyWith(
      id: event.id.isEmpty ? 'evt_${DateTime.now().millisecondsSinceEpoch}' : event.id,
    );
    _events.insert(0, newEvent);
    return newEvent;
  }

  @override
  Future<ManageEventItem> updateEvent(ManageEventItem event) async {
    final index = _events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      _events[index] = event;
      return event;
    }
    _events.add(event);
    return event;
  }

  @override
  Future<void> deleteEvent(String id) async {
    _events.removeWhere((e) => e.id == id);
  }

  @override
  Future<ManageEventItem> toggleLiveNow(String id) async {
    final index = _events.indexWhere((e) => e.id == id);
    if (index != -1) {
      final updated = _events[index].copyWith(isLiveNow: !_events[index].isLiveNow);
      _events[index] = updated;
      return updated;
    }
    throw Exception('Event not found: $id');
  }
}
