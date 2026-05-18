import 'package:flutter/material.dart';

import '../services/settings_service.dart';

class SettingsNotifier extends ChangeNotifier {
  SettingsNotifier(this._service);

  final SettingsService _service;

  ThemeMode _themeMode = ThemeMode.system;
  double _fontSize = 15.0;
  String _fontFamily = 'Inter';

  ThemeMode get themeMode => _themeMode;
  double get fontSize => _fontSize;
  String get fontFamily => _fontFamily;

  Future<void> load() async {
    _themeMode = await _service.readThemeMode();
    _fontSize = await _service.readFontSize();
    _fontFamily = await _service.readFontFamily();
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    await _service.writeThemeMode(mode);
  }

  Future<void> setFontSize(double size) async {
    _fontSize = size;
    notifyListeners();
    await _service.writeFontSize(size);
  }

  Future<void> setFontFamily(String family) async {
    _fontFamily = family;
    notifyListeners();
    await _service.writeFontFamily(family);
  }
}
