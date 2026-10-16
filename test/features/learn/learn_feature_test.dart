import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gdgoc_psit_app/features/learn/data/learn_mock_data.dart';
import 'package:gdgoc_psit_app/features/learn/domain/models/learning_path.dart';
import 'package:gdgoc_psit_app/features/learn/domain/models/learning_resource.dart';
import 'package:gdgoc_psit_app/features/learn/domain/models/workshop_session.dart';
import 'package:gdgoc_psit_app/features/learn/presentation/controllers/learn_controller.dart';
import 'package:gdgoc_psit_app/features/learn/presentation/screens/learn_screen.dart';

void main() {
  group('Screen 10 (Learn) - Unit Tests', () {
    test(
      'LearningPath dynamic progress calculation & exact metadata string format',
      () {
        final path = LearningPath(
          id: 'test_path',
          title: 'Android with Kotlin',
          category: 'Mobile Development',
          estimatedHours: 24,
          modules: const [
            LearningModule(
              id: 'm1',
              title: 'M1',
              description: 'D1',
              isCompleted: true,
            ),
            LearningModule(
              id: 'm2',
              title: 'M2',
              description: 'D2',
              isCompleted: true,
            ),
            LearningModule(
              id: 'm3',
              title: 'M3',
              description: 'D3',
              isCompleted: true,
            ),
            LearningModule(
              id: 'm4',
              title: 'M4',
              description: 'D4',
              isCompleted: true,
            ),
            LearningModule(
              id: 'm5',
              title: 'M5',
              description: 'D5',
              isCompleted: true,
            ),
            LearningModule(
              id: 'm6',
              title: 'M6',
              description: 'D6',
              isCompleted: true,
            ),
            LearningModule(
              id: 'm7',
              title: 'M7',
              description: 'D7',
              isCompleted: false,
            ),
            LearningModule(
              id: 'm8',
              title: 'M8',
              description: 'D8',
              isCompleted: false,
            ),
            LearningModule(
              id: 'm9',
              title: 'M9',
              description: 'D9',
              isCompleted: false,
            ),
            LearningModule(
              id: 'm10',
              title: 'M10',
              description: 'D10',
              isCompleted: false,
            ),
          ],
        );

        // Verify exact progress metadata string format
        expect(path.progressMetadata, '6 of 10 modules · 24 hours');

        // Verify dynamic progress ratio
        expect(path.completedModules, 6);
        expect(path.totalModules, 10);
        expect(path.progressRatio, 0.6);
        expect(path.progressPercentage, 60.0);
        expect(path.actionLabel, 'Continue');
      },
    );

    test(
      'LearningPath action labels change appropriately based on completion',
      () {
        const notStarted = LearningPath(
          id: 'p1',
          title: 'ML',
          category: 'AI',
          estimatedHours: 30,
          modules: [
            LearningModule(
              id: 'm1',
              title: 'M1',
              description: '',
              isCompleted: false,
            ),
          ],
        );
        expect(notStarted.actionLabel, 'Start');

        const completed = LearningPath(
          id: 'p2',
          title: 'Cloud',
          category: 'Cloud',
          estimatedHours: 10,
          modules: [
            LearningModule(
              id: 'm1',
              title: 'M1',
              description: '',
              isCompleted: true,
            ),
          ],
        );
        expect(completed.actionLabel, 'Review');
      },
    );

    test('ResourceItem filtering by topic works accurately', () {
      final resources = LearnMockData.getInitialResources();
      final androidResources = resources
          .where((r) => r.topic.toLowerCase() == 'android')
          .toList();
      expect(androidResources.isNotEmpty, true);
      expect(androidResources.first.type, ResourceType.doc);
    });

    test('WorkshopSession metadata line and formatting', () {
      const session = WorkshopSession(
        id: 's1',
        title: 'Git and GitHub basics',
        speaker: 'Ishita Verma',
        recordedDate: '18 Sep',
        duration: '1h 12m',
        category: 'Study jam',
        thumbnailUrl: 'https://example.com/thumb.jpg',
        videoUrl: 'https://youtube.com/watch?v=123',
      );

      expect(session.metadataLine, 'Study jam · 18 Sep · 1h 12m');
    });

    test(
      'LearnController toggleModule dynamically updates completion stats',
      () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        final initialState = container.read(learnControllerProvider);
        expect(initialState.isLoading, false);

        // Initial paths load
        final paths = initialState.paths;
        final targetPath =
            paths.first; // Android with Kotlin (6 of 10 completed)
        expect(targetPath.completedModules, 6);

        // Read controller and toggle 7th module to true
        final seventhModule = targetPath.modules[6];
        expect(seventhModule.isCompleted, false);

        container
            .read(learnControllerProvider.notifier)
            .toggleModule(targetPath.id, seventhModule.id);

        final updatedState = container.read(learnControllerProvider);
        final updatedPath = updatedState.paths.firstWhere(
          (p) => p.id == targetPath.id,
        );
        expect(updatedPath.completedModules, 7);
        expect(updatedPath.progressMetadata, '7 of 10 modules · 24 hours');
        expect(updatedPath.progressRatio, 0.7);
      },
    );
  });

  group('Screen 10 (Learn) - Widget Tests', () {
    testWidgets(
      'Renders top tabs (Paths, Resources, Sessions) and switches between them',
      (tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: MaterialApp(home: LearnScreen())),
        );
        await tester.pumpAndSettle();

        // Verify app bar title
        expect(find.text('Learn'), findsOneWidget);

        // Verify 3 top tabs
        expect(find.text('Paths'), findsOneWidget);
        expect(find.text('Resources'), findsOneWidget);
        expect(find.text('Sessions'), findsOneWidget);

        // Verify Paths tab is active initially
        expect(find.text('Android with Kotlin'), findsOneWidget);
        expect(find.text('Web with Next.js'), findsOneWidget);
        expect(find.text('6 of 10 modules · 24 hours'), findsOneWidget);

        // Switch to Resources tab
        await tester.tap(find.text('Resources'));
        await tester.pumpAndSettle();

        expect(find.text('All'), findsOneWidget);
        expect(find.text('Android'), findsWidgets);
        expect(
          find.text('Jetpack Compose Official Architecture Guide'),
          findsOneWidget,
        );

        // Switch to Sessions tab
        await tester.tap(find.text('Sessions'));
        await tester.pumpAndSettle();

        expect(find.text('Past sessions'), findsOneWidget);
        expect(find.text('Git and GitHub basics'), findsOneWidget);
        expect(find.text('1h 12m'), findsOneWidget);
      },
    );

    testWidgets(
      'Tapping path opens checklist sheet and toggling module recalculates progress',
      (tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: MaterialApp(home: LearnScreen())),
        );
        await tester.pumpAndSettle();

        // Tap on Android with Kotlin card
        await tester.tap(find.text('Android with Kotlin'));
        await tester.pumpAndSettle();

        // Verify module checklist sheet is displayed
        expect(
          find.text('Module 1: Kotlin Fundamentals & OOP'),
          findsOneWidget,
        );
        expect(find.text('6 of 10 modules · 24 hours'), findsWidgets);

        // Tap on Module 1 (toggles it from completed to uncompleted)
        await tester.tap(find.text('Module 1: Kotlin Fundamentals & OOP'));
        await tester.pumpAndSettle();

        // Verify progress dynamically recalculated to 5 of 10
        expect(find.text('5 of 10 modules · 24 hours'), findsWidgets);

        // Tap on Module 1 again (toggles back to completed)
        await tester.tap(find.text('Module 1: Kotlin Fundamentals & OOP'));
        await tester.pumpAndSettle();

        // Verify progress dynamically recalculated back to 6 of 10
        expect(find.text('6 of 10 modules · 24 hours'), findsWidgets);
      },
    );

    testWidgets('Tapping session opens video player preview modal', (
      tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: LearnScreen())),
      );
      await tester.pumpAndSettle();

      // Switch to Sessions tab
      await tester.tap(find.text('Sessions'));
      await tester.pumpAndSettle();

      // Tap Git and GitHub basics session
      await tester.tap(find.text('Git and GitHub basics'));
      await tester.pumpAndSettle();

      // Verify video player preview modal opened
      expect(find.text('PLAYING PREVIEW'), findsOneWidget);
      expect(find.text('About this session'), findsOneWidget);
    });
  });
}
