import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'services/cv_repository.dart';
import 'services/gemini_ai_service.dart';
import 'services/remote_cv_repository.dart';
import 'services/settings_service.dart';
import 'services/sync_orchestrator.dart';
import 'state/ai_notifier.dart';
import 'state/cv_editor_notifier.dart';
import 'state/cv_list_notifier.dart';
import 'state/settings_notifier.dart';
import 'state/sync_notifier.dart';

class AiCvMakerApp extends StatelessWidget {
  const AiCvMakerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GeminiAiService ai = GeminiAiService();
    final SettingsService settingsService = SettingsService();
    final CvRepository localRepo = CvRepository.create();
    // Swap with FirebaseRemoteRepository() once flutterfire is configured;
    // see lib/services/firebase_remote_repository.dart for steps.
    final RemoteCvRepository remoteRepo = InMemoryRemoteRepository();
    final SyncOrchestrator sync =
        SyncOrchestrator(local: localRepo, remote: remoteRepo);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsNotifier>(
          create: (_) => SettingsNotifier(
              settingsService: settingsService, aiService: ai)
            ..load(),
        ),
        ChangeNotifierProvider<CvListNotifier>(
          create: (_) => CvListNotifier(sync)..load(),
        ),
        ChangeNotifierProxyProvider<CvListNotifier, CvEditorNotifier>(
          create: (BuildContext ctx) =>
              CvEditorNotifier(ctx.read<CvListNotifier>()),
          update: (BuildContext _, CvListNotifier list, CvEditorNotifier? old) =>
              old ?? CvEditorNotifier(list),
        ),
        ChangeNotifierProvider<AiNotifier>(create: (_) => AiNotifier(ai)),
        ChangeNotifierProxyProvider<CvListNotifier, SyncNotifier>(
          create: (BuildContext ctx) => SyncNotifier(
              orchestrator: sync, list: ctx.read<CvListNotifier>()),
          update: (BuildContext _, CvListNotifier list, SyncNotifier? old) =>
              old ?? SyncNotifier(orchestrator: sync, list: list),
        ),
      ],
      child: Consumer<SettingsNotifier>(
        builder: (BuildContext _, SettingsNotifier settings, __) {
          return MaterialApp.router(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: settings.themeMode,
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
