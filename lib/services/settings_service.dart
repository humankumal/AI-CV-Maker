import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants.dart';

class SettingsService {
  Future<ThemeMode> readThemeMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? value = prefs.getString(AppConstants.themeModeKey);
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> writeThemeMode(ThemeMode mode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      _ => 'system',
    };
    await prefs.setString(AppConstants.themeModeKey, value);
  }

  Future<double> readFontSize() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(AppConstants.textFontSizeKey) ?? 15.0;
  }

  Future<void> writeFontSize(double size) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(AppConstants.textFontSizeKey, size);
  }

  Future<String> readFontFamily() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.textFontFamilyKey) ?? 'Inter';
  }

  Future<void> writeFontFamily(String family) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.textFontFamilyKey, family);
  }
}
