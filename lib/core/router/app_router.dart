import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/ai/ai_suggestion_screen.dart';
import '../../features/country_selection/country_selection_screen.dart';
import '../../features/cv_editor/cv_editor_screen.dart';
import '../../features/export/export_screen.dart';
import '../../features/preview/preview_screen.dart';
import '../../features/saved_cvs/saved_cvs_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/template_selection/template_selection_screen.dart';
import '../../features/welcome/welcome_screen.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext _, GoRouterState __) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/country',
        builder: (BuildContext _, GoRouterState __) =>
            const CountrySelectionScreen(),
      ),
      GoRoute(
        path: '/template',
        builder: (BuildContext _, GoRouterState state) =>
            TemplateSelectionScreen(
                countryCode: state.uri.queryParameters['country'] ?? 'GB'),
      ),
      GoRoute(
        path: '/editor/:id',
        builder: (BuildContext _, GoRouterState state) =>
            CvEditorScreen(cvId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/preview/:id',
        builder: (BuildContext _, GoRouterState state) =>
            PreviewScreen(cvId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/export/:id',
        builder: (BuildContext _, GoRouterState state) =>
            ExportScreen(cvId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/ai',
        builder: (BuildContext _, GoRouterState __) =>
            const AiSuggestionScreen(),
      ),
      GoRoute(
        path: '/saved',
        builder: (BuildContext _, GoRouterState __) => const SavedCvsScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (BuildContext _, GoRouterState __) => const SettingsScreen(),
      ),
    ],
  );
}
