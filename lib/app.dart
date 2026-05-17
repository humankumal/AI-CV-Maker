import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'services/cv_repository.dart';
import 'services/gemini_ai_service.dart';
import 'services/settings_service.dart';
import 'state/ai_notifier.dart';
import 'state/cv_editor_notifier.dart';
import 'state/cv_list_notifier.dart';
import 'state/settings_notifier.dart';

class AiCvMakerApp extends StatelessWidget {
  const AiCvMakerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GeminiAiService ai = GeminiAiService();
    final SettingsService settingsService = SettingsService();
    final CvRepository repo = CvRepository.create();

    return MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<SettingsNotifier>(
          create: (_) => SettingsNotifier(
              settingsService: settingsService, aiService: ai)
            ..load(),
        ),
        ChangeNotifierProvider<CvListNotifier>(
          create: (_) => CvListNotifier(repo)..load(),
        ),
        ChangeNotifierProxyProvider<CvListNotifier, CvEditorNotifier>(
          create: (BuildContext ctx) =>
              CvEditorNotifier(ctx.read<CvListNotifier>()),
          update: (BuildContext _, CvListNotifier list, CvEditorNotifier? old) =>
              old ?? CvEditorNotifier(list),
        ),
        ChangeNotifierProvider<AiNotifier>(create: (_) => AiNotifier(ai)),
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
