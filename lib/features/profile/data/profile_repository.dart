import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/member_profile.dart';
import 'profile_mock_data.dart';

abstract interface class ProfileRepository {
  Future<MemberProfile> getProfile();
  Future<void> updatePrivacy(bool enabled);
  Future<void> updateNotifications(bool enabled);
}

class FakeProfileRepository implements ProfileRepository {
  @override
  Future<MemberProfile> getProfile() async {
    return ProfileMockData.getInitialProfile();
  }

  @override
  Future<void> updatePrivacy(bool enabled) async {}

  @override
  Future<void> updateNotifications(bool enabled) async {}
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return FakeProfileRepository();
});
