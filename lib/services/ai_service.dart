import '../models/country_config.dart';

/// Kind of text being rewritten — affects the prompt and constraints.
enum AiFieldKind {
  summary,
  experienceBullet,
  projectBullet,
  educationDetails,
  generic,
}

abstract class AiService {
  /// Rewrites user text in a country-appropriate professional tone.
  /// Must never invent facts.
  Future<String> rewrite({
    required String text,
    required AiFieldKind fieldKind,
    required CountryConfig country,
  });

  /// Suggests bullet wordings based on a role and the user's own draft input.
  /// Does not invent achievements — improves the user's draft only.
  Future<List<String>> suggestBullets({
    required String role,
    required String draft,
    required CountryConfig country,
  });

  /// Suggests common ATS keywords for a role in a country.
  Future<List<String>> suggestKeywords({
    required String role,
    required CountryConfig country,
  });

  /// Whether the service is ready to make API calls (e.g. has an API key).
  bool get isConfigured;
}

/// System prompt builder shared by all implementations and easy to unit-test.
class AiPromptBuilder {
  AiPromptBuilder._();

  static const String safetyHeader = '''
You are a professional CV editor.

Strict rules:
1. Rewrite only. Never invent experience, employers, dates, certifications,
   skills, achievements, metrics, or qualifications that the user did not
   provide.
2. Preserve every factual claim. If the user did not give a metric, do not
   add one.
3. Use clean, professional language. No marketing fluff or buzzwords.
4. Match the spelling and tone conventions of the specified country.
5. Output plain text only — no markdown, headings, or commentary.
''';

  static String rewritePrompt({
    required String text,
    required AiFieldKind fieldKind,
    required CountryConfig country,
  }) {
    final String kindHint = switch (fieldKind) {
      AiFieldKind.summary =>
        'Produce a single professional summary paragraph of about ${country.summaryWordLimit} words. First person is implied — do not write "I".',
      AiFieldKind.experienceBullet ||
      AiFieldKind.projectBullet =>
        'Produce 2 to 5 concise bullet points. Each bullet starts with a strong action verb. One bullet per line. No leading dash or symbol.',
      AiFieldKind.educationDetails =>
        'Produce a brief education detail line, factual and concise.',
      AiFieldKind.generic => 'Improve clarity and grammar only.',
    };
    return '''
$safetyHeader

Country: ${country.name} (${country.spellingVariant} spelling).
Task: $kindHint

User text:
"""
$text
"""

Rewritten text:''';
  }

  static String suggestBulletsPrompt({
    required String role,
    required String draft,
    required CountryConfig country,
  }) {
    return '''
$safetyHeader

Country: ${country.name} (${country.spellingVariant} spelling).
Role: $role

The user has provided this rough description of what they did:
"""
$draft
"""

Rewrite their description as 3 to 5 polished bullet points.
Rules:
- Use only what the user described. Do not invent metrics, tools, or wins.
- One bullet per line, no leading dash or symbol.
- Start with a strong action verb.
- If a bullet would require fabrication to be impressive, keep it modest.

Bullets:''';
  }

  static String suggestKeywordsPrompt({
    required String role,
    required CountryConfig country,
  }) {
    return '''
$safetyHeader

Country: ${country.name}.
Suggest 8 to 12 ATS-friendly keywords commonly expected for the role
"$role". Comma separated, no commentary, no numbering.''';
  }
}
