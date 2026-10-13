import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../features/auth/domain/models/auth_user.dart';

abstract interface class TokenStorage {
  Future<void> saveSession({
    required String token,
    required String rollNumber,
    required UserRole role,
  });

  Future<({String? token, String? rollNumber, UserRole? role})> getSession();

  Future<void> clearSession();
}

class SecureTokenStorage implements TokenStorage {
  SecureTokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _keyToken = 'auth_token';
  static const _keyRollNumber = 'auth_roll_number';
  static const _keyRole = 'auth_user_role';

  @override
  Future<void> saveSession({
    required String token,
    required String rollNumber,
    required UserRole role,
  }) async {
    await _storage.write(key: _keyToken, value: token);
    await _storage.write(key: _keyRollNumber, value: rollNumber);
    await _storage.write(key: _keyRole, value: role.name);
  }

  @override
  Future<({String? token, String? rollNumber, UserRole? role})> getSession() async {
    final token = await _storage.read(key: _keyToken);
    final rollNumber = await _storage.read(key: _keyRollNumber);
    final roleStr = await _storage.read(key: _keyRole);

    UserRole? role;
    if (roleStr != null) {
      for (final r in UserRole.values) {
        if (r.name == roleStr) {
          role = r;
          break;
        }
      }
    }

    return (token: token, rollNumber: rollNumber, role: role);
  }

  @override
  Future<void> clearSession() async {
    await _storage.delete(key: _keyToken);
    await _storage.delete(key: _keyRollNumber);
    await _storage.delete(key: _keyRole);
  }
}
