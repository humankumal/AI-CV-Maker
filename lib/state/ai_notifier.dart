import 'package:flutter/foundation.dart';

import '../models/country_config.dart';
import '../services/ai_service.dart';
import '../services/gemini_ai_service.dart';

class AiNotifier extends ChangeNotifier {
  AiNotifier(this.service);

  final GeminiAiService service;

  bool _running = false;
  String? _error;

  bool get running => _running;
  String? get error => _error;
  bool get isConfigured => service.isConfigured;

  Future<String?> rewrite({
    required String text,
    required AiFieldKind kind,
    required CountryConfig country,
  }) async {
    if (text.trim().isEmpty) return null;
    _running = true;
    _error = null;
    notifyListeners();
    try {
      final String out =
          await service.rewrite(text: text, fieldKind: kind, country: country);
      return out;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _running = false;
      notifyListeners();
    }
  }

  Future<List<String>?> suggestBullets({
    required String role,
    required String draft,
    required CountryConfig country,
  }) async {
    _running = true;
    _error = null;
    notifyListeners();
    try {
      return await service.suggestBullets(
          role: role, draft: draft, country: country);
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _running = false;
      notifyListeners();
    }
  }

  Future<List<String>?> suggestKeywords({
    required String role,
    required CountryConfig country,
  }) async {
    _running = true;
    _error = null;
    notifyListeners();
    try {
      return await service.suggestKeywords(role: role, country: country);
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _running = false;
      notifyListeners();
    }
  }
}
