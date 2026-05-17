import 'package:ai_cv_maker/models/country_config.dart';
import 'package:ai_cv_maker/models/template_config.dart';
import 'package:ai_cv_maker/services/country_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CountryCatalog', () {
    test('exposes exactly 5 countries', () {
      expect(CountryCatalog.countries.length, 5);
      expect(
        CountryCatalog.countries.map((CountryConfig c) => c.code).toSet(),
        <String>{'GB', 'US', 'CA', 'AU', 'IN'},
      );
    });

    test('exposes exactly 50 templates (10 per country)', () {
      expect(CountryCatalog.templates.length, 50);
      for (final CountryConfig c in CountryCatalog.countries) {
        final List<TemplateConfig> list = CountryCatalog.templatesFor(c.code);
        expect(list.length, 10,
            reason: 'Country ${c.code} should have 10 templates');
      }
    });

    test('every archetype is represented per country', () {
      for (final CountryConfig c in CountryCatalog.countries) {
        final Set<TemplateArchetype> archetypes = CountryCatalog
            .templatesFor(c.code)
            .map((TemplateConfig t) => t.archetype)
            .toSet();
        expect(archetypes, TemplateArchetype.values.toSet());
      }
    });

    test('template IDs are unique and well-formed', () {
      final List<String> ids = CountryCatalog.templates
          .map((TemplateConfig t) => t.id)
          .toList();
      expect(ids.toSet().length, ids.length);
      for (final String id in ids) {
        expect(RegExp(r'^(GB|US|CA|AU|IN)-\d{2}$').hasMatch(id), isTrue,
            reason: 'ID $id is malformed');
      }
    });
  });
}
