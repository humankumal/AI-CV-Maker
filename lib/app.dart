import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'services/file_service.dart';
import 'services/iap_service.dart';
import 'services/recent_files_service.dart';
import 'services/settings_service.dart';
import 'state/pro_notifier.dart';
import 'state/recent_files_notifier.dart';
import 'state/settings_notifier.dart';

class DocumentReaderApp extends StatelessWidget {
  const DocumentReaderApp({super.key, required this.iap});

  final IapService iap;

  @override
  Widget build(BuildContext context) {
    final RecentFilesService recentService = RecentFilesService();
    final FileService fileService = FileService();
    final SettingsService settingsService = SettingsService();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<IapService>.value(value: iap),
        ChangeNotifierProvider<ProNotifier>(
          create: (_) => ProNotifier(iap),
        ),
        ChangeNotifierProvider<SettingsNotifier>(
          create: (_) => SettingsNotifier(settingsService)..load(),
        ),
        ChangeNotifierProvider<RecentFilesNotifier>(
          create: (_) => RecentFilesNotifier(recentService, iap)..load(),
        ),
        Provider<FileService>.value(value: fileService),
      ],
      child: Consumer<SettingsNotifier>(
        builder: (_, SettingsNotifier settings, __) {
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
