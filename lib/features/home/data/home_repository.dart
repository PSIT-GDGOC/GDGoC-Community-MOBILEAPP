import 'package:flutter/material.dart';
import '../domain/models/board_entry.dart';
import '../domain/models/home_data.dart';

abstract interface class HomeRepository {
  Future<List<BoardEntry>> getBoardEntries({String filter = 'all'});

  Future<List<HomeEventSummary>> getUpcomingEvents();

  Future<List<ProjectShortcut>> getProjectShortcuts();

  Future<List<ActivityCardItem>> getRecentActivities();
}

class FakeHomeRepository implements HomeRepository {
  const FakeHomeRepository();

  static const List<BoardEntry> defaultBoardEntries = [
    BoardEntry(rank: 1, name: 'Ishita Verma', points: 1240, colorIndex: 0),
    BoardEntry(rank: 2, name: 'Kabir Singh', points: 1105, colorIndex: 1),
    BoardEntry(rank: 3, name: 'Ananya Mishra', points: 980, colorIndex: 2),
    BoardEntry(rank: 4, name: 'Rohan Gupta', points: 905, colorIndex: 3),
    BoardEntry(rank: 5, name: 'Priya Tripathi', points: 860, colorIndex: 0),
    BoardEntry(rank: 6, name: 'Vivek Yadav', points: 815, colorIndex: 1),
    BoardEntry(rank: 7, name: 'Sanya Khan', points: 770, colorIndex: 2),
    BoardEntry(rank: 8, name: 'Meera Joshi', points: 690, colorIndex: 3),
    BoardEntry(rank: 9, name: 'Aditya Pandey', points: 640, colorIndex: 0),
    BoardEntry(rank: 10, name: 'Nidhi Saxena', points: 590, colorIndex: 1),
    BoardEntry(rank: 11, name: 'Harsh Tiwari', points: 540, colorIndex: 2),
    BoardEntry(rank: 12, name: 'Pooja Dwivedi', points: 500, colorIndex: 3),
    BoardEntry(rank: 13, name: 'Shivam Mishra', points: 455, colorIndex: 0),
    BoardEntry(
      rank: 14,
      name: 'Aarav Sharma',
      points: 410,
      colorIndex: 1,
      rollNumber: '2501640100567',
      isCurrentUser: true,
    ),
  ];

  static const List<HomeEventSummary> defaultEvents = [
    HomeEventSummary(
      id: 'evt_kickoff',
      title: 'Hacktoberfest 2026 Kickoff',
      dateAndVenue: 'Sat 10 Oct · Seminar Hall',
      seatsInfo: '147 of 150',
      status: 'Registered',
      icon: Icons.emoji_events_outlined,
      brandColor1: 'blue',
      brandColor2: 'green',
      isLive: true,
      isRegistered: true,
    ),
    HomeEventSummary(
      id: 'evt_flutter',
      title: 'Intro to Flutter Workshop',
      dateAndVenue: 'Wed 14 Oct · Lab 4',
      seatsInfo: '100 of 100',
      status: 'Waitlist',
      icon: Icons.flutter_dash,
      brandColor1: 'blue',
      brandColor2: 'yellow',
    ),
    HomeEventSummary(
      id: 'evt_gcp',
      title: 'Cloud Study Jam: GCP',
      dateAndVenue: 'Sat 17 Oct · CS Block',
      seatsInfo: '64 of 80',
      status: 'Open',
      icon: Icons.cloud_outlined,
      brandColor1: 'blue',
      brandColor2: 'red',
    ),
  ];

  static const List<ProjectShortcut> defaultProjects = [
    ProjectShortcut(
      id: 'prj_web',
      name: 'Web App',
      techStack: 'Next.js · TypeScript · Tailwind',
      icon: Icons.language,
      brandColor1: 'blue',
      brandColor2: 'green',
    ),
    ProjectShortcut(
      id: 'prj_android',
      name: 'Android App',
      techStack: 'Kotlin · Jetpack Compose',
      icon: Icons.android_outlined,
      brandColor1: 'green',
      brandColor2: 'yellow',
    ),
    ProjectShortcut(
      id: 'prj_docs',
      name: 'Docs',
      techStack: 'Markdown · Docusaurus',
      icon: Icons.description_outlined,
      brandColor1: 'red',
      brandColor2: 'yellow',
    ),
  ];

  static const List<ActivityCardItem> defaultActivities = [
    ActivityCardItem(
      name: 'Ishita Verma',
      action: 'opened a PR',
      timeAgo: '2m',
      colorIndex: 0,
    ),
    ActivityCardItem(
      name: 'Kabir Singh',
      action: 'joined Android App',
      timeAgo: '1h',
      colorIndex: 1,
    ),
    ActivityCardItem(
      name: 'Ananya Mishra',
      action: 'joined a waitlist',
      timeAgo: '3h',
      colorIndex: 2,
    ),
    ActivityCardItem(
      name: 'Sanya Khan',
      action: 'opened a docs PR',
      timeAgo: '5h',
      colorIndex: 3,
    ),
  ];

  @override
  Future<List<BoardEntry>> getBoardEntries({String filter = 'all'}) async {
    return defaultBoardEntries;
  }

  @override
  Future<List<HomeEventSummary>> getUpcomingEvents() async {
    return defaultEvents;
  }

  @override
  Future<List<ProjectShortcut>> getProjectShortcuts() async {
    return defaultProjects;
  }

  @override
  Future<List<ActivityCardItem>> getRecentActivities() async {
    return defaultActivities;
  }
}
