import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants.dart';

/// Owns persisted settings: theme mode, default country, and the Gemini key.
class SettingsService {
  SettingsService({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage;

  final FlutterSecureStorage? _secureStorage;

  FlutterSecureStorage get _store =>
      _secureStorage ?? const FlutterSecureStorage();

  Future<ThemeMode> readThemeMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String raw =
        prefs.getString(AppConstants.themeModeKey) ?? ThemeMode.system.name;
    return ThemeMode.values.firstWhere(
      (ThemeMode m) => m.name == raw,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> writeThemeMode(ThemeMode mode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.themeModeKey, mode.name);
  }

  Future<String?> readDefaultCountry() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.defaultCountryKey);
  }

  Future<void> writeDefaultCountry(String code) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.defaultCountryKey, code);
  }

  Future<bool> readOnboardingSeen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.onboardingSeenKey) ?? false;
  }

  Future<void> writeOnboardingSeen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.onboardingSeenKey, true);
  }

  /// On web, `flutter_secure_storage` falls back to localStorage automatically.
  Future<String?> readGeminiKey() async {
    try {
      return await _store.read(key: AppConstants.geminiApiKeyKey);
    } catch (_) {
      if (kIsWeb) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        return prefs.getString(AppConstants.geminiApiKeyKey);
      }
      return null;
    }
  }

  Future<void> writeGeminiKey(String? key) async {
    try {
      if (key == null || key.isEmpty) {
        await _store.delete(key: AppConstants.geminiApiKeyKey);
      } else {
        await _store.write(key: AppConstants.geminiApiKeyKey, value: key);
      }
    } catch (_) {
      if (kIsWeb) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        if (key == null || key.isEmpty) {
          await prefs.remove(AppConstants.geminiApiKeyKey);
        } else {
          await prefs.setString(AppConstants.geminiApiKeyKey, key);
        }
      }
    }
  }
}
