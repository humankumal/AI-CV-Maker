import 'package:flutter/material.dart';

import '../services/gemini_ai_service.dart';
import '../services/settings_service.dart';

class SettingsNotifier extends ChangeNotifier {
  SettingsNotifier({
    required this.settingsService,
    required this.aiService,
  });

  final SettingsService settingsService;
  final GeminiAiService aiService;

  ThemeMode _themeMode = ThemeMode.system;
  String? _defaultCountry;
  String? _geminiKey;
  bool _loaded = false;

  ThemeMode get themeMode => _themeMode;
  String? get defaultCountry => _defaultCountry;
  bool get hasGeminiKey => _geminiKey != null && _geminiKey!.isNotEmpty;
  String? get geminiKeyMasked {
    if (_geminiKey == null || _geminiKey!.isEmpty) return null;
    final String k = _geminiKey!;
    if (k.length <= 6) return '••••';
    return '${k.substring(0, 3)}…${k.substring(k.length - 4)}';
  }

  bool get loaded => _loaded;

  Future<void> load() async {
    _themeMode = await settingsService.readThemeMode();
    _defaultCountry = await settingsService.readDefaultCountry();
    _geminiKey = await settingsService.readGeminiKey();
    aiService.apiKey = _geminiKey;
    _loaded = true;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    await settingsService.writeThemeMode(mode);
  }

  Future<void> setDefaultCountry(String code) async {
    _defaultCountry = code;
    notifyListeners();
    await settingsService.writeDefaultCountry(code);
  }

  Future<void> setGeminiKey(String? key) async {
    _geminiKey = key;
    aiService.apiKey = key;
    notifyListeners();
    await settingsService.writeGeminiKey(key);
  }
}
