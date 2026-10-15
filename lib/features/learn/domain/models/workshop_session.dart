/// Represents a past recorded workshop or study jam session.
class WorkshopSession {
  const WorkshopSession({
    required this.id,
    required this.title,
    required this.speaker,
    required this.recordedDate,
    required this.duration,
    required this.thumbnailUrl,
    required this.videoUrl,
    this.category = 'Study jam',
    this.description = '',
  });

  final String id;
  final String title;
  final String speaker;
  final String recordedDate;
  final String duration;
  final String thumbnailUrl;
  final String videoUrl;
  final String category;
  final String description;

  /// Formatted metadata line, e.g., "Study jam · 18 Sep · 1h 12m"
  String get metadataLine => '$category · $recordedDate · $duration';
}
