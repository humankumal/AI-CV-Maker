import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/bookmarks/bookmarks_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/pro_upgrade/pro_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/viewer/viewer_screen.dart';
import '../../models/document_file.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (_, __) => const HomeScreen(),
      ),
      GoRoute(
        path: '/viewer',
        builder: (_, GoRouterState state) {
          final DocumentFile file = state.extra as DocumentFile;
          return ViewerScreen(file: file);
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (_, __) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/pro',
        builder: (_, __) => const ProUpgradeScreen(),
      ),
      GoRoute(
        path: '/bookmarks',
        builder: (_, __) => const BookmarksScreen(),
      ),
    ],
  );
}
