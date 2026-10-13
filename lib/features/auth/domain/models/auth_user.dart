enum UserRole {
  member,
  coreTeam,
  mentor;

  String get displayName => switch (this) {
        UserRole.member => 'Member',
        UserRole.coreTeam => 'Core Team',
        UserRole.mentor => 'Mentor',
      };
}

class AuthUser {
  const AuthUser({
    required this.id,
    required this.name,
    required this.rollNumber,
    required this.email,
    required this.role,
    required this.department,
    required this.year,
    this.githubHandle,
    this.points = 0,
    this.rank,
  });

  final String id;
  final String name;
  final String rollNumber;
  final String email;
  final UserRole role;
  final String department;
  final int year;
  final String? githubHandle;
  final int points;
  final int? rank;

  String get roleDescription => switch (role) {
        UserRole.member => 'Member · $department, ${year}rd year',
        UserRole.coreTeam => 'Core Team · $department, ${year}rd year',
        UserRole.mentor => 'Mentor · Faculty',
      };
}
