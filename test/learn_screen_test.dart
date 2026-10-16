import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gdgoc_psit_app/features/learn/domain/models/learning_path.dart';
import 'package:gdgoc_psit_app/features/learn/presentation/screens/learn_screen.dart';
import 'package:gdgoc_psit_app/features/learn/presentation/widgets/learning_path_card.dart';
import 'package:gdgoc_psit_app/features/learn/presentation/widgets/session_card.dart';

void main() {
  group('Screen 10 (Learn) - Automated Test Suite', () {
    // ------------------------------------------------------------------------
    // 1. Tab Navigation Test & State Persistence
    // ------------------------------------------------------------------------
    testWidgets(
      'Tab Navigation: Paths, Resources, and Sessions tabs render and switch views',
      (tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: MaterialApp(home: LearnScreen())),
        );
        await tester.pumpAndSettle();

        // Verify app bar title and tab labels
        expect(find.text('Learn'), findsOneWidget);
        expect(find.text('Paths'), findsOneWidget);
        expect(find.text('Resources'), findsOneWidget);
        expect(find.text('Sessions'), findsOneWidget);

        // Verify Paths tab is initially active
        expect(find.text('Android with Kotlin'), findsOneWidget);
        expect(find.text('Web with Next.js'), findsOneWidget);

        // Switch to Resources tab
        await tester.tap(find.text('Resources'));
        await tester.pumpAndSettle();

        expect(find.text('All'), findsOneWidget);
        expect(
          find.text('Jetpack Compose Official Architecture Guide'),
          findsOneWidget,
        );
        expect(
          find.text('Next.js 15 App Router & Server Actions'),
          findsOneWidget,
        );

        // Switch to Sessions tab
        await tester.tap(find.text('Sessions'));
        await tester.pumpAndSettle();

        expect(find.text('Past sessions'), findsOneWidget);
        expect(find.text('Git and GitHub basics'), findsOneWidget);
        expect(find.text('1h 12m'), findsOneWidget);

        // Switch back to Paths tab
        await tester.tap(find.text('Paths'));
        await tester.pumpAndSettle();

        expect(find.text('Android with Kotlin'), findsOneWidget);
      },
    );

    testWidgets(
      'Tab State Persistence: rapid switching across all tabs retains content integrity without crash or state loss',
      (tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: MaterialApp(home: LearnScreen())),
        );
        await tester.pumpAndSettle();

        // Rapid switching back and forth
        for (int i = 0; i < 3; i++) {
          await tester.tap(find.text('Resources'));
          await tester.pump(const Duration(milliseconds: 50));
          await tester.tap(find.text('Sessions'));
          await tester.pump(const Duration(milliseconds: 50));
          await tester.tap(find.text('Paths'));
          await tester.pump(const Duration(milliseconds: 50));
        }
        await tester.pumpAndSettle();

        // Ensure Paths tab content is intact
        expect(find.text('Android with Kotlin'), findsOneWidget);
        expect(find.text('Web with Next.js'), findsOneWidget);
        expect(find.text('Flutter Cross-Platform'), findsOneWidget);

        // Switch to Resources and filter by Flutter
        await tester.tap(find.text('Resources'));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(FilterChip, 'Flutter'));
        await tester.pumpAndSettle();

        expect(
          find.text('GDGoC Chapter App Repository Template'),
          findsOneWidget,
        );

        // Switch to Sessions and back to Resources
        await tester.tap(find.text('Sessions'));
        await tester.pumpAndSettle();
        expect(find.text('Git and GitHub basics'), findsOneWidget);

        await tester.tap(find.text('Resources'));
        await tester.pumpAndSettle();
        expect(
          find.text('GDGoC Chapter App Repository Template'),
          findsOneWidget,
        );
      },
    );

    // ------------------------------------------------------------------------
    // 2. Progress Boundary Math & Format Tests
    // ------------------------------------------------------------------------
    testWidgets(
      'Progress String Format: renders in exact format "X of Y modules · Z hours"',
      (tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: MaterialApp(home: LearnScreen())),
        );
        await tester.pumpAndSettle();

        // Verify exact progress metadata string rendered on Android path card
        expect(find.text('6 of 10 modules · 24 hours'), findsOneWidget);
        // Verify exact progress metadata string rendered on Web path card
        expect(find.text('3 of 8 modules · 18 hours'), findsOneWidget);
      },
    );

    test(
      'Progress Boundary Math: safe division by zero, 0%, partial %, 100%, and boundary clamps',
      () {
        // Boundary 1: totalModules == 0 (must not throw NaN or ZeroDivisionError)
        const zeroTotalModules = LearningPath(
          id: 'p_empty',
          title: 'Empty Path',
          category: 'General',
          estimatedHours: 0,
          modules: [],
        );
        expect(zeroTotalModules.completedModules, 0);
        expect(zeroTotalModules.totalModules, 0);
        expect(zeroTotalModules.progressRatio, 0.0);
        expect(zeroTotalModules.progressPercentage, 0.0);
        expect(zeroTotalModules.isCompleted, false);
        expect(zeroTotalModules.isStarted, false);
        expect(zeroTotalModules.actionLabel, 'Start');
        expect(zeroTotalModules.progressMetadata, '0 of 0 modules · 0 hours');

        // Boundary 2: 0 completed modules
        const zeroCompleted = LearningPath(
          id: 'p0',
          title: 'Cloud DevOps',
          category: 'Cloud',
          estimatedHours: 12,
          modules: [
            LearningModule(
              id: 'm1',
              title: 'Intro',
              description: '',
              isCompleted: false,
            ),
            LearningModule(
              id: 'm2',
              title: 'Docker',
              description: '',
              isCompleted: false,
            ),
          ],
        );
        expect(zeroCompleted.progressMetadata, '0 of 2 modules · 12 hours');
        expect(zeroCompleted.progressRatio, 0.0);
        expect(zeroCompleted.progressPercentage, 0.0);
        expect(zeroCompleted.isStarted, false);
        expect(zeroCompleted.isCompleted, false);
        expect(zeroCompleted.actionLabel, 'Start');

        // Boundary 3: Partial completion (6 of 10)
        final partialCompleted = LearningPath(
          id: 'p1',
          title: 'Android',
          category: 'Mobile',
          estimatedHours: 24,
          modules: List.generate(
            10,
            (i) => LearningModule(
              id: 'm$i',
              title: 'M$i',
              description: '',
              isCompleted: i < 6,
            ),
          ),
        );
        expect(partialCompleted.progressMetadata, '6 of 10 modules · 24 hours');
        expect(partialCompleted.progressRatio, 0.6);
        expect(partialCompleted.progressPercentage, 60.0);
        expect(partialCompleted.isStarted, true);
        expect(partialCompleted.isCompleted, false);
        expect(partialCompleted.actionLabel, 'Continue');

        // Boundary 4: Full completion (10 of 10)
        final fullCompleted = LearningPath(
          id: 'p2',
          title: 'Git Mastering',
          category: 'Tools',
          estimatedHours: 6,
          modules: List.generate(
            10,
            (i) => LearningModule(
              id: 'm$i',
              title: 'M$i',
              description: '',
              isCompleted: true,
            ),
          ),
        );
        expect(fullCompleted.progressMetadata, '10 of 10 modules · 6 hours');
        expect(fullCompleted.progressRatio, 1.0);
        expect(fullCompleted.progressPercentage, 100.0);
        expect(fullCompleted.isStarted, true);
        expect(fullCompleted.isCompleted, true);
        expect(fullCompleted.actionLabel, 'Review');
      },
    );

    // ------------------------------------------------------------------------
    // 3. Acceptance Criterion 1 (Linear Progress Accuracy & Interactive Recalculation)
    // ------------------------------------------------------------------------
    testWidgets(
      'Acceptance Criterion 1: LinearProgressIndicator accurately reflects module completion across states and updates on toggle',
      (tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: MaterialApp(home: LearnScreen())),
        );
        await tester.pumpAndSettle();

        // Find all LinearProgressIndicator widgets in the learning path cards
        final progressIndicators = find.byType(LinearProgressIndicator);
        expect(progressIndicators, findsWidgets);

        // Verify initial value of first card (Android with Kotlin: 6 of 10 modules = 0.6)
        final firstIndicatorInitial = tester.widget<LinearProgressIndicator>(
          progressIndicators.first,
        );
        expect(firstIndicatorInitial.value, closeTo(0.6, 0.001));

        // Open checklist sheet by tapping Android with Kotlin card
        await tester.tap(find.text('Android with Kotlin'));
        await tester.pumpAndSettle();

        expect(
          find.text('Module 1: Kotlin Fundamentals & OOP'),
          findsOneWidget,
        );

        // Toggle Module 1 from completed (true) to uncompleted (false) -> now 5 of 10
        await tester.tap(find.text('Module 1: Kotlin Fundamentals & OOP'));
        await tester.pumpAndSettle();

        expect(find.text('5 of 10 modules · 24 hours'), findsWidgets);

        // Verify the progress indicator inside sheet/card dynamically recalculated to 5 / 10 = 0.5
        final updatedIndicators = find.byType(LinearProgressIndicator);
        final firstIndicatorUpdated = tester.widget<LinearProgressIndicator>(
          updatedIndicators.first,
        );
        expect(firstIndicatorUpdated.value, closeTo(0.5, 0.001));

        // Toggle Module 1 back to completed -> now 6 of 10 again
        await tester.tap(find.text('Module 1: Kotlin Fundamentals & OOP'));
        await tester.pumpAndSettle();

        expect(find.text('6 of 10 modules · 24 hours'), findsWidgets);
        final restoredIndicator = tester.widget<LinearProgressIndicator>(
          find.byType(LinearProgressIndicator).first,
        );
        expect(restoredIndicator.value, closeTo(0.6, 0.001));

        // Close modal sheet
        await tester.tap(find.byIcon(Icons.close_rounded));
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'Interactive Module Recalculation: sequential toggling of multiple modules dynamically updates progress and metadata on every step',
      (tester) async {
        tester.view.physicalSize = const Size(800, 1600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          const ProviderScope(child: MaterialApp(home: LearnScreen())),
        );
        await tester.pumpAndSettle();

        // Open Android with Kotlin checklist
        await tester.tap(find.text('Android with Kotlin'));
        await tester.pumpAndSettle();

        // Initial state: 6 of 10 (0.6)
        expect(find.text('6 of 10 modules · 24 hours'), findsWidgets);
        expect(
          tester
              .widget<LinearProgressIndicator>(
                find.byType(LinearProgressIndicator).first,
              )
              .value,
          closeTo(0.6, 0.001),
        );

        // 1. Uncheck Module 1 (was completed -> false): 5 of 10 (0.5)
        await tester.tap(find.text('Module 1: Kotlin Fundamentals & OOP'));
        await tester.pumpAndSettle();
        expect(find.text('5 of 10 modules · 24 hours'), findsWidgets);
        expect(
          tester
              .widget<LinearProgressIndicator>(
                find.byType(LinearProgressIndicator).first,
              )
              .value,
          closeTo(0.5, 0.001),
        );

        // 2. Uncheck Module 2 (was completed -> false): 4 of 10 (0.4)
        await tester.tap(find.text('Module 2: Jetpack Compose Layouts & Theming'));
        await tester.pumpAndSettle();
        expect(find.text('4 of 10 modules · 24 hours'), findsWidgets);
        expect(
          tester
              .widget<LinearProgressIndicator>(
                find.byType(LinearProgressIndicator).first,
              )
              .value,
          closeTo(0.4, 0.001),
        );

        // 3. Re-check Module 1 (false -> true): 5 of 10 (0.5)
        await tester.tap(find.text('Module 1: Kotlin Fundamentals & OOP'));
        await tester.pumpAndSettle();
        expect(find.text('5 of 10 modules · 24 hours'), findsWidgets);
        expect(
          tester
              .widget<LinearProgressIndicator>(
                find.byType(LinearProgressIndicator).first,
              )
              .value,
          closeTo(0.5, 0.001),
        );

        // 4. Re-check Module 2 (false -> true): 6 of 10 (0.6)
        await tester.tap(find.text('Module 2: Jetpack Compose Layouts & Theming'));
        await tester.pumpAndSettle();
        expect(find.text('6 of 10 modules · 24 hours'), findsWidgets);
        expect(
          tester
              .widget<LinearProgressIndicator>(
                find.byType(LinearProgressIndicator).first,
              )
              .value,
          closeTo(0.6, 0.001),
        );

        // Close modal sheet
        await tester.tap(find.byIcon(Icons.close_rounded));
        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'Acceptance Criterion 1: LinearProgressIndicator across 0, partial, and full states',
      (tester) async {
        final paths = [
          const LearningPath(
            id: 'zero',
            title: 'Zero Path',
            category: 'Testing',
            estimatedHours: 5,
            modules: [
              LearningModule(
                id: 'z1',
                title: 'Z1',
                description: '',
                isCompleted: false,
              ),
              LearningModule(
                id: 'z2',
                title: 'Z2',
                description: '',
                isCompleted: false,
              ),
            ],
          ),
          LearningPath(
            id: 'partial',
            title: 'Partial Path',
            category: 'Testing',
            estimatedHours: 10,
            modules: List.generate(
              10,
              (i) => LearningModule(
                id: 'p$i',
                title: 'P$i',
                description: '',
                isCompleted: i < 6,
              ),
            ),
          ),
          const LearningPath(
            id: 'full',
            title: 'Full Path',
            category: 'Testing',
            estimatedHours: 8,
            modules: [
              LearningModule(
                id: 'f1',
                title: 'F1',
                description: '',
                isCompleted: true,
              ),
            ],
          ),
        ];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: paths
                    .map((p) => LearningPathCard(path: p, onTap: () {}))
                    .toList(),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final indicators = tester
            .widgetList<LinearProgressIndicator>(
              find.byType(LinearProgressIndicator),
            )
            .toList();
        expect(indicators.length, 3);

        // State 0 completed: value == 0.0
        expect(indicators[0].value, 0.0);
        // State 6 of 10: value == 0.6
        expect(indicators[1].value, closeTo(0.6, 0.001));
        // State full (1 of 1): value == 1.0
        expect(indicators[2].value, 1.0);
      },
    );

    // ------------------------------------------------------------------------
    // 4. Sessions Archive Tests
    // ------------------------------------------------------------------------
    testWidgets(
      'Sessions Archive: past workshop recordings render with title, speaker, and duration badges',
      (tester) async {
        tester.view.physicalSize = const Size(800, 1600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          const ProviderScope(child: MaterialApp(home: LearnScreen())),
        );
        await tester.pumpAndSettle();

        // Switch to Sessions tab
        await tester.tap(find.text('Sessions'));
        await tester.pumpAndSettle();

        // Verify Sessions Archive title & recording count badge
        expect(find.text('Past sessions'), findsOneWidget);
        expect(find.text('4 recordings'), findsOneWidget);

        // Verify Session Titles
        expect(find.text('Git and GitHub basics'), findsOneWidget);
        expect(find.text('Intro to Jetpack Compose'), findsOneWidget);
        expect(
          find.text('Building with Next.js 15 & Server Actions'),
          findsOneWidget,
        );
        expect(
          find.text('Getting Started with Flutter & Riverpod'),
          findsOneWidget,
        );

        // Verify Visible Duration Badges
        expect(find.text('1h 12m'), findsOneWidget);
        expect(find.text('58m'), findsOneWidget);
        expect(find.text('1h 05m'), findsOneWidget);
        expect(find.text('1h 20m'), findsOneWidget);

        // Verify Interactive preview state opens on tap
        await tester.tap(find.text('Git and GitHub basics'));
        await tester.pumpAndSettle();

        expect(find.text('PLAYING PREVIEW'), findsOneWidget);
        expect(find.textContaining('Ishita Verma'), findsWidgets);
        expect(find.text('About this session'), findsOneWidget);
        expect(find.text('Watch on YouTube'), findsOneWidget);
      },
    );

    testWidgets(
      'Sessions Archive Metadata: all session cards render play triggers and duration badges',
      (tester) async {
        await tester.pumpWidget(
          const ProviderScope(child: MaterialApp(home: LearnScreen())),
        );
        await tester.pumpAndSettle();

        // Switch to Sessions tab
        await tester.tap(find.text('Sessions'));
        await tester.pumpAndSettle();

        // Verify all SessionCard widgets exist
        final sessionCards = find.byType(SessionCard);
        expect(sessionCards, findsNWidgets(4));

        // Verify play icons are rendered on every card
        expect(find.byIcon(Icons.play_circle_filled_rounded), findsNWidgets(4));

        // Verify timer icons on duration badges
        expect(find.byIcon(Icons.timer_outlined), findsNWidgets(4));
      },
    );
  });
}
