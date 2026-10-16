import 'package:flutter/material.dart';
import '../domain/models/learning_path.dart';
import '../domain/models/learning_resource.dart';
import '../domain/models/workshop_session.dart';

abstract final class LearnMockData {
  static List<LearningPath> getInitialPaths() {
    return [
      LearningPath(
        id: 'path_android',
        title: 'Android with Kotlin',
        category: 'Mobile Development',
        estimatedHours: 24,
        iconData: Icons.android_rounded,
        trackColor: LearningTrackColor.green,
        modules: const [
          LearningModule(
            id: 'mod_and_1',
            title: 'Kotlin Fundamentals & OOP',
            description:
                'Data classes, lambdas, sealed interfaces, and coroutines.',
            isCompleted: true,
            durationMinutes: 120,
          ),
          LearningModule(
            id: 'mod_and_2',
            title: 'Jetpack Compose Layouts & Theming',
            description:
                'Modifier chaining, Rows, Columns, Box, and Material 3 design tokens.',
            isCompleted: true,
            durationMinutes: 150,
          ),
          LearningModule(
            id: 'mod_and_3',
            title: 'State Management & ViewModels',
            description:
                'MutableStateOf, remember, StateFlow, and ViewModel lifecycle.',
            isCompleted: true,
            durationMinutes: 180,
          ),
          LearningModule(
            id: 'mod_and_4',
            title: 'Navigation Component in Compose',
            description:
                'NavHost, typed routes, animated transitions, and argument passing.',
            isCompleted: true,
            durationMinutes: 120,
          ),
          LearningModule(
            id: 'mod_and_5',
            title: 'Room Database & Offline Caching',
            description:
                'SQLite persistence, DAOs, reactive Queries, and repository caching.',
            isCompleted: true,
            durationMinutes: 180,
          ),
          LearningModule(
            id: 'mod_and_6',
            title: 'Retrofit & REST APIs',
            description:
                'HTTP client setup, JSON serialization with Kotlinx, and error handling.',
            isCompleted: true,
            durationMinutes: 150,
          ),
          LearningModule(
            id: 'mod_and_7',
            title: 'Dependency Injection with Hilt',
            description:
                'Singletons, component scoping, and injecting ViewModels.',
            isCompleted: false,
            durationMinutes: 120,
          ),
          LearningModule(
            id: 'mod_and_8',
            title: 'WorkManager & Background Tasks',
            description:
                'Periodic sync, constraint-based scheduling, and battery optimization.',
            isCompleted: false,
            durationMinutes: 120,
          ),
          LearningModule(
            id: 'mod_and_9',
            title: 'Unit & UI Testing with Mockk',
            description:
                'Repository testing, Compose UI test rules, and assertion patterns.',
            isCompleted: false,
            durationMinutes: 150,
          ),
          LearningModule(
            id: 'mod_and_10',
            title: 'Publishing to Play Store & CI/CD',
            description:
                'App bundles, signing keys, and automated GitHub Actions builds.',
            isCompleted: false,
            durationMinutes: 150,
          ),
        ],
      ),
      LearningPath(
        id: 'path_web',
        title: 'Web with Next.js',
        category: 'Fullstack Web',
        estimatedHours: 18,
        iconData: Icons.language_rounded,
        trackColor: LearningTrackColor.blue,
        modules: const [
          LearningModule(
            id: 'mod_web_1',
            title: 'React 19 Core & Hooks Deep Dive',
            description:
                'useTransition, useOptimistic, action states, and custom hooks.',
            isCompleted: true,
            durationMinutes: 150,
          ),
          LearningModule(
            id: 'mod_web_2',
            title: 'Next.js App Router Architecture',
            description:
                'Nested layouts, route groups, template files, and loading states.',
            isCompleted: true,
            durationMinutes: 180,
          ),
          LearningModule(
            id: 'mod_web_3',
            title: 'Server Components & Server Actions',
            description:
                'Direct DB access, zero-bundle overhead, and type-safe form actions.',
            isCompleted: true,
            durationMinutes: 180,
          ),
          LearningModule(
            id: 'mod_web_4',
            title: 'Tailwind CSS & M3 Component Systems',
            description:
                'Utility tokens, dark mode theming, and responsive layout primitives.',
            isCompleted: false,
            durationMinutes: 120,
          ),
          LearningModule(
            id: 'mod_web_5',
            title: 'Prisma ORM & PostgreSQL Setup',
            description:
                'Schema modeling, migrations, connection pooling, and seeding.',
            isCompleted: false,
            durationMinutes: 150,
          ),
          LearningModule(
            id: 'mod_web_6',
            title: 'NextAuth.js & Session Management',
            description:
                'OAuth providers, JWT verification, and middleware route guards.',
            isCompleted: false,
            durationMinutes: 120,
          ),
          LearningModule(
            id: 'mod_web_7',
            title: 'Edge Functions & Caching Strategies',
            description:
                'Incremental Static Regeneration, tag revalidation, and CDN headers.',
            isCompleted: false,
            durationMinutes: 90,
          ),
          LearningModule(
            id: 'mod_web_8',
            title: 'Dockerizing & Deploying to Cloud Run',
            description:
                'Multi-stage Dockerfiles, production optimization, and Google Cloud Run.',
            isCompleted: false,
            durationMinutes: 90,
          ),
        ],
      ),
      LearningPath(
        id: 'path_ml',
        title: 'ML with TensorFlow',
        category: 'Artificial Intelligence',
        estimatedHours: 30,
        iconData: Icons.psychology_rounded,
        trackColor: LearningTrackColor.red,
        modules: const [
          LearningModule(
            id: 'mod_ml_1',
            title: 'Python for Data Science & NumPy',
            description:
                'Vectorized computing, array broadcasting, and numerical algebra.',
            isCompleted: false,
            durationMinutes: 180,
          ),
          LearningModule(
            id: 'mod_ml_2',
            title: 'Pandas Data Wrangling & Analysis',
            description:
                'DataFrames, cleaning missing entries, grouping, and aggregations.',
            isCompleted: false,
            durationMinutes: 200,
          ),
          LearningModule(
            id: 'mod_ml_3',
            title: 'Matplotlib & Data Visualization',
            description:
                'Histograms, scatter matrices, correlation heatmaps, and charts.',
            isCompleted: false,
            durationMinutes: 120,
          ),
          LearningModule(
            id: 'mod_ml_4',
            title: 'Machine Learning Foundations',
            description:
                'Regression, classification metrics, bias-variance tradeoff, and SciKit.',
            isCompleted: false,
            durationMinutes: 240,
          ),
          LearningModule(
            id: 'mod_ml_5',
            title: 'Neural Networks with Keras',
            description:
                'Dense layers, activation functions, loss optimizers, and backpropagation.',
            isCompleted: false,
            durationMinutes: 240,
          ),
          LearningModule(
            id: 'mod_ml_6',
            title: 'Convolutional Neural Networks (CNNs)',
            description:
                'Image classification, pooling layers, and transfer learning with MobileNet.',
            isCompleted: false,
            durationMinutes: 240,
          ),
          LearningModule(
            id: 'mod_ml_7',
            title: 'Natural Language Processing with Transformers',
            description:
                'Tokenization, attention mechanisms, and fine-tuning BERT models.',
            isCompleted: false,
            durationMinutes: 240,
          ),
          LearningModule(
            id: 'mod_ml_8',
            title: 'TensorFlow Lite for Mobile Deployment',
            description:
                'Post-training quantization, TFLite conversion, and on-device inference.',
            isCompleted: false,
            durationMinutes: 180,
          ),
          LearningModule(
            id: 'mod_ml_9',
            title: 'Model Monitoring & MLOps Pipelines',
            description:
                'Data drift detection, artifact versioning, and CI model evaluation.',
            isCompleted: false,
            durationMinutes: 160,
          ),
        ],
      ),
      LearningPath(
        id: 'path_cloud',
        title: 'Cloud with GCP',
        category: 'Cloud Engineering',
        estimatedHours: 14,
        iconData: Icons.cloud_rounded,
        trackColor: LearningTrackColor.yellow,
        modules: const [
          LearningModule(
            id: 'mod_cld_1',
            title: 'Google Cloud Core Infrastructure',
            description:
                'VPCs, regions, Compute Engine instances, and cloud networking.',
            isCompleted: true,
            durationMinutes: 120,
          ),
          LearningModule(
            id: 'mod_cld_2',
            title: 'IAM & Resource Management',
            description:
                'Roles, service accounts, least privilege security, and audit logs.',
            isCompleted: true,
            durationMinutes: 120,
          ),
          LearningModule(
            id: 'mod_cld_3',
            title: 'Google Kubernetes Engine (GKE) Basics',
            description:
                'Pods, deployments, services, ingress controllers, and auto-scaling.',
            isCompleted: false,
            durationMinutes: 180,
          ),
          LearningModule(
            id: 'mod_cld_4',
            title: 'Cloud Run Serverless Containers',
            description:
                'Deploying containerized microservices with zero-scale scaling.',
            isCompleted: false,
            durationMinutes: 150,
          ),
          LearningModule(
            id: 'mod_cld_5',
            title: 'Cloud Storage & BigQuery Analytics',
            description:
                'Bucket lifecycle rules, SQL queries over petabytes, and partitioning.',
            isCompleted: false,
            durationMinutes: 150,
          ),
          LearningModule(
            id: 'mod_cld_6',
            title: 'Cloud Build & Artifact Registry Pipelines',
            description:
                'Automated container builds, trigger events, and release pipelines.',
            isCompleted: false,
            durationMinutes: 120,
          ),
        ],
      ),
      LearningPath(
        id: 'path_flutter',
        title: 'Flutter Cross-Platform',
        category: 'Mobile Development',
        estimatedHours: 20,
        iconData: Icons.flutter_dash_rounded,
        trackColor: LearningTrackColor.blue,
        modules: const [
          LearningModule(
            id: 'mod_flt_1',
            title: 'Dart 3 Essentials & Patterns',
            description:
                'Records, pattern matching, sealed classes, and sound null safety.',
            isCompleted: false,
            durationMinutes: 120,
          ),
          LearningModule(
            id: 'mod_flt_2',
            title: 'Flutter Widget Tree & RenderObjects',
            description:
                'Stateless vs Stateful, build context, key mechanics, and layout pass.',
            isCompleted: false,
            durationMinutes: 150,
          ),
          LearningModule(
            id: 'mod_flt_3',
            title: 'State Management with Riverpod 2.0',
            description:
                'AsyncNotifier, AutoDispose, family providers, and ref watchers.',
            isCompleted: false,
            durationMinutes: 180,
          ),
          LearningModule(
            id: 'mod_flt_4',
            title: 'GoRouter Declarative Routing & Shells',
            description:
                'StatefulShellRoute, redirect guards, deep linking, and transitions.',
            isCompleted: false,
            durationMinutes: 150,
          ),
          LearningModule(
            id: 'mod_flt_5',
            title: 'Dio & Networking Layer Architecture',
            description:
                'Interceptors, automatic auth token refresh, and retry policies.',
            isCompleted: false,
            durationMinutes: 120,
          ),
          LearningModule(
            id: 'mod_flt_6',
            title: 'Material 3 Theming & Responsive Design',
            description:
                'ThemeExtensions, dynamic color schemes, and breakpoint layouts.',
            isCompleted: false,
            durationMinutes: 150,
          ),
          LearningModule(
            id: 'mod_flt_7',
            title: 'Platform Channels & Device Hardware',
            description:
                'MethodChannels, camera access, sensors, and secure storage.',
            isCompleted: false,
            durationMinutes: 150,
          ),
          LearningModule(
            id: 'mod_flt_8',
            title: 'Automated Testing & Store Deployment',
            description:
                'Unit, widget, and integration tests, fastlane, and release builds.',
            isCompleted: false,
            durationMinutes: 180,
          ),
        ],
      ),
    ];
  }

  static List<ResourceItem> getInitialResources() {
    return const [
      ResourceItem(
        id: 'res_compose',
        title: 'Jetpack Compose Official Architecture Guide',
        type: ResourceType.doc,
        topic: 'Android',
        url: 'https://developer.android.com/jetpack/compose',
        description:
            'Comprehensive guidelines for designing reactive, declarative UIs in native Android apps.',
        estimatedReadTime: '8 min read',
        author: 'Google Android Team',
      ),
      ResourceItem(
        id: 'res_next',
        title: 'Next.js 15 App Router & Server Actions',
        type: ResourceType.doc,
        topic: 'Web',
        url: 'https://nextjs.org/docs/app',
        description:
            'Deep dive into streaming server-side rendering, React server components, and mutations.',
        estimatedReadTime: '12 min read',
        author: 'Vercel Team',
      ),
      ResourceItem(
        id: 'res_mobile_repo',
        title: 'GDGoC Chapter App Repository Template',
        type: ResourceType.repo,
        topic: 'Flutter',
        url: 'https://github.com/gdgoc-psit/mobile-app',
        description:
            'Clean Architecture starter code with Riverpod state management and Material 3 design tokens.',
        estimatedReadTime: 'GitHub Repo',
        author: 'GDGoC PSIT Core',
      ),
      ResourceItem(
        id: 'res_cloud_run',
        title: 'Production Container Deployment with Google Cloud Run',
        type: ResourceType.guide,
        topic: 'Cloud',
        url: 'https://cloud.google.com/run/docs/quickstarts',
        description:
            'Hands-on tutorial for shipping high-throughput containerized services with zero idle costs.',
        estimatedReadTime: '15 min read',
        author: 'Google Cloud Platform',
      ),
      ResourceItem(
        id: 'res_tf_tutorials',
        title: 'TensorFlow 2.x Deep Learning Cheat Sheet',
        type: ResourceType.guide,
        topic: 'ML',
        url: 'https://www.tensorflow.org/tutorials',
        description:
            'Practical quick-reference for computer vision pipelines and neural network training.',
        estimatedReadTime: '10 min read',
        author: 'TensorFlow Team',
      ),
      ResourceItem(
        id: 'res_git_workflow',
        title: 'Git Branching & Pull Request Etiquette',
        type: ResourceType.guide,
        topic: 'Git',
        url: 'https://git-scm.com/book',
        description:
            'Standard open-source contributing flow: branching, squashing, conventional commits, and rebasing.',
        estimatedReadTime: '6 min read',
        author: 'Open Source October',
      ),
    ];
  }

  static List<WorkshopSession> getInitialSessions() {
    return const [
      WorkshopSession(
        id: 'sess_git',
        title: 'Git and GitHub basics',
        speaker: 'Ishita Verma',
        recordedDate: '18 Sep',
        duration: '1h 12m',
        category: 'Study jam',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1618401471353-b98afee0b2eb?w=600',
        videoUrl: 'https://www.youtube.com/watch?v=RGOj5yH7evk',
        description:
            'Essential version control techniques for student contributors: branching, PR conventions, resolving merge conflicts, and earning board points.',
      ),
      WorkshopSession(
        id: 'sess_compose',
        title: 'Intro to Jetpack Compose',
        speaker: 'Rohan Gupta',
        recordedDate: '25 Sep',
        duration: '58m',
        category: 'Workshop',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1607799279861-4dd421887fb3?w=600',
        videoUrl: 'https://www.youtube.com/watch?v=k3Z7Gq8qKvk',
        description:
            'Live coding a modern Material 3 Android layout with composable functions, state hoisting, and interactive previews in Android Studio.',
      ),
      WorkshopSession(
        id: 'sess_nextjs',
        title: 'Building with Next.js 15 & Server Actions',
        speaker: 'Sanya Khan',
        recordedDate: '2 Oct',
        duration: '1h 05m',
        category: 'Study jam',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=600',
        videoUrl: 'https://www.youtube.com/watch?v=1d5jHwHk1vk',
        description:
            'Architecting full-stack React applications with server components, type-safe database queries with Prisma, and streaming UI fallbacks.',
      ),
      WorkshopSession(
        id: 'sess_flutter',
        title: 'Getting Started with Flutter & Riverpod',
        speaker: 'Aarav Sharma',
        recordedDate: '9 Oct',
        duration: '1h 20m',
        category: 'Workshop',
        thumbnailUrl:
            'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=600',
        videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        description:
            'Complete breakdown of the GDGoC chapter app architecture: Riverpod state providers, declarative GoRouter navigation, and custom design tokens.',
      ),
    ];
  }
}
