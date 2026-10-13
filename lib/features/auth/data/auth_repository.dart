import '../domain/models/auth_user.dart';

abstract interface class AuthRepository {
  Future<void> sendOtp({
    required String rollNumber,
    required String email,
  });

  Future<AuthUser> verifyOtp({
    required String rollNumber,
    required String email,
    required String otp,
  });

  Future<AuthUser?> getCurrentUser();

  Future<void> signOut();
}

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({this.demoRole = UserRole.member});

  final UserRole demoRole;
  AuthUser? _currentUser;

  @override
  Future<void> sendOtp({
    required String rollNumber,
    required String email,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (rollNumber.length != 13) {
      throw const FormatException('Roll number must be exactly 13 digits.');
    }
    if (!email.toLowerCase().endsWith('@gmail.com')) {
      throw const FormatException('Must be a valid @gmail.com address.');
    }
  }

  @override
  Future<AuthUser> verifyOtp({
    required String rollNumber,
    required String email,
    required String otp,
  }) async {
    // Simulate checking against PSIT records
    await Future.delayed(const Duration(milliseconds: 1200));

    if (otp != '123456' && otp.length != 6) {
      throw const FormatException('Invalid verification code.');
    }

    final user = AuthUser(
      id: 'usr_0567',
      name: 'Aarav Sharma',
      rollNumber: rollNumber.isNotEmpty ? rollNumber : '2501640100567',
      email: email.isNotEmpty ? email : 'aarav.sharma@gmail.com',
      role: demoRole,
      department: 'Computer Science',
      year: 3,
      githubHandle: '@aarav-sharma',
      points: 410,
      rank: 14,
    );

    _currentUser = user;
    return user;
  }

  @override
  Future<AuthUser?> getCurrentUser() async {
    return _currentUser;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
  }
}
