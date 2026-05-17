import 'package:google_generative_ai/google_generative_ai.dart';

import '../models/country_config.dart';
import 'ai_service.dart';

class GeminiAiService implements AiService {
  GeminiAiService({String? apiKey, String? modelName})
      : _apiKey = apiKey,
        _modelName = modelName ?? 'gemini-1.5-flash';

  String? _apiKey;
  final String _modelName;
  GenerativeModel? _model;

  set apiKey(String? value) {
    _apiKey = value;
    _model = null;
  }

  @override
  bool get isConfigured => _apiKey != null && _apiKey!.trim().isNotEmpty;

  GenerativeModel _ensureModel() {
    if (!isConfigured) {
      throw const AiNotConfiguredException();
    }
    return _model ??= GenerativeModel(
      model: _modelName,
      apiKey: _apiKey!,
      generationConfig: GenerationConfig(
        temperature: 0.4,
        maxOutputTokens: 800,
      ),
    );
  }

  Future<String> _generate(String prompt) async {
    final GenerativeModel model = _ensureModel();
    final GenerateContentResponse res =
        await model.generateContent(<Content>[Content.text(prompt)]);
    final String text = res.text?.trim() ?? '';
    if (text.isEmpty) {
      throw const AiEmptyResponseException();
    }
    return text;
  }

  @override
  Future<String> rewrite({
    required String text,
    required AiFieldKind fieldKind,
    required CountryConfig country,
  }) async {
    if (text.trim().isEmpty) return text;
    final String prompt = AiPromptBuilder.rewritePrompt(
      text: text,
      fieldKind: fieldKind,
      country: country,
    );
    return _generate(prompt);
  }

  @override
  Future<List<String>> suggestBullets({
    required String role,
    required String draft,
    required CountryConfig country,
  }) async {
    if (draft.trim().isEmpty) return <String>[];
    final String prompt = AiPromptBuilder.suggestBulletsPrompt(
      role: role,
      draft: draft,
      country: country,
    );
    final String raw = await _generate(prompt);
    return raw
        .split('\n')
        .map((String line) => line.trim().replaceFirst(RegExp(r'^[-•*]\s*'), ''))
        .where((String line) => line.isNotEmpty)
        .toList();
  }

  @override
  Future<List<String>> suggestKeywords({
    required String role,
    required CountryConfig country,
  }) async {
    if (role.trim().isEmpty) return <String>[];
    final String prompt =
        AiPromptBuilder.suggestKeywordsPrompt(role: role, country: country);
    final String raw = await _generate(prompt);
    return raw
        .split(RegExp(r'[,;\n]'))
        .map((String s) => s.trim())
        .where((String s) => s.isNotEmpty)
        .toList();
  }
}

class AiNotConfiguredException implements Exception {
  const AiNotConfiguredException();
  @override
  String toString() =>
      'Gemini API key is not set. Open Settings to add one.';
}

class AiEmptyResponseException implements Exception {
  const AiEmptyResponseException();
  @override
  String toString() => 'The AI returned an empty response. Please try again.';
}
