class BoardEntry {
  const BoardEntry({
    required this.rank,
    required this.name,
    required this.points,
    required this.colorIndex,
    this.rollNumber,
    this.isCurrentUser = false,
  });

  final int rank;
  final String name;
  final int points;
  final int colorIndex;
  final String? rollNumber;
  final bool isCurrentUser;
}
