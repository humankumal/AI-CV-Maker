import 'package:ai_cv_maker/models/country_config.dart';
import 'package:ai_cv_maker/services/ai_service.dart';
import 'package:ai_cv_maker/services/country_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AiPromptBuilder', () {
    test('safety header forbids invention', () {
      expect(AiPromptBuilder.safetyHeader, contains('Never invent'));
      expect(AiPromptBuilder.safetyHeader.toLowerCase(),
          contains('preserve every factual claim'));
    });

    test('rewritePrompt mentions country spelling variant', () {
      final CountryConfig uk = CountryCatalog.countryFor('GB');
      final String prompt = AiPromptBuilder.rewritePrompt(
        text: 'I led a team',
        fieldKind: AiFieldKind.summary,
        country: uk,
      );
      expect(prompt, contains('British'));
      expect(prompt, contains('United Kingdom'));
      expect(prompt, contains('I led a team'));
    });

    test('suggestBulletsPrompt forbids fabricated metrics', () {
      final CountryConfig us = CountryCatalog.countryFor('US');
      final String prompt = AiPromptBuilder.suggestBulletsPrompt(
        role: 'Engineer',
        draft: 'built things',
        country: us,
      );
      expect(prompt.toLowerCase(), contains('do not invent'));
      expect(prompt, contains('Engineer'));
    });
  });
}
