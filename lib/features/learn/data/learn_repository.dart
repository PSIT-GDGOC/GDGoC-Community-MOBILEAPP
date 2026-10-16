import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/learning_path.dart';
import '../domain/models/learning_resource.dart';
import '../domain/models/workshop_session.dart';
import 'learn_mock_data.dart';

abstract interface class LearnRepository {
  Future<List<LearningPath>> getLearningPaths();
  Future<List<ResourceItem>> getResources();
  Future<List<WorkshopSession>> getSessions();
}

class FakeLearnRepository implements LearnRepository {
  @override
  Future<List<LearningPath>> getLearningPaths() async {
    return LearnMockData.getInitialPaths();
  }

  @override
  Future<List<ResourceItem>> getResources() async {
    return LearnMockData.getInitialResources();
  }

  @override
  Future<List<WorkshopSession>> getSessions() async {
    return LearnMockData.getInitialSessions();
  }
}

final learnRepositoryProvider = Provider<LearnRepository>((ref) {
  return FakeLearnRepository();
});
