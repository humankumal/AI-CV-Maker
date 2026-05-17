import 'package:flutter/material.dart';

import '../models/country_config.dart';
import '../models/template_config.dart';

/// Single source of truth for all 5 countries and 50 templates.
class CountryCatalog {
  CountryCatalog._();

  static const List<CountryConfig> countries = <CountryConfig>[
    CountryConfig(
      code: 'GB',
      name: 'United Kingdom',
      flag: '🇬🇧',
      docKind: 'CV',
      locale: 'en_GB',
      spellingVariant: 'British',
      summaryWordLimit: 80,
      includePhoto: false,
      preferredPageCount: '1–2 pages',
      pageFormat: CountryPageFormat.a4,
      tagline: 'Concise British CV with a personal profile at the top.',
      atsHints: <String>[
        'Use a clear personal profile (3–4 lines).',
        'Place achievements with measurable outcomes.',
        'British spelling: organise, optimise, behaviour.',
      ],
    ),
    CountryConfig(
      code: 'US',
      name: 'United States',
      flag: '🇺🇸',
      docKind: 'Resume',
      locale: 'en_US',
      spellingVariant: 'American',
      summaryWordLimit: 60,
      includePhoto: false,
      preferredPageCount: '1 page',
      pageFormat: CountryPageFormat.letter,
      tagline: 'ATS-first US resume — single page, action-led bullets.',
      atsHints: <String>[
        'Aim for a single page unless 10+ years of experience.',
        'Start each bullet with a strong verb and quantify impact.',
        'American spelling: organize, optimize, behavior.',
      ],
    ),
    CountryConfig(
      code: 'CA',
      name: 'Canada',
      flag: '🇨🇦',
      docKind: 'Resume',
      locale: 'en_CA',
      spellingVariant: 'Canadian',
      summaryWordLimit: 70,
      includePhoto: false,
      preferredPageCount: '1–2 pages',
      pageFormat: CountryPageFormat.letter,
      tagline: 'Professional Canadian resume with measured language.',
      atsHints: <String>[
        'Use Canadian spelling (favour, organisation, behaviour).',
        'Include city + province in location fields.',
        'Keep tone professional and understated.',
      ],
    ),
    CountryConfig(
      code: 'AU',
      name: 'Australia',
      flag: '🇦🇺',
      docKind: 'Resume',
      locale: 'en_AU',
      spellingVariant: 'Australian',
      summaryWordLimit: 90,
      includePhoto: false,
      preferredPageCount: '2 pages',
      pageFormat: CountryPageFormat.a4,
      tagline: 'Clear, friendly Australian resume layout.',
      atsHints: <String>[
        'Australian spelling and date format DD MMM YYYY.',
        'List right-to-work status where relevant.',
        'Plain layout — avoid columns and graphics.',
      ],
    ),
    CountryConfig(
      code: 'IN',
      name: 'India',
      flag: '🇮🇳',
      docKind: 'Resume',
      locale: 'en_IN',
      spellingVariant: 'Indian',
      summaryWordLimit: 80,
      includePhoto: false,
      preferredPageCount: '1–2 pages',
      pageFormat: CountryPageFormat.a4,
      tagline: 'Modern Indian resume — adapts to freshers and professionals.',
      atsHints: <String>[
        'List degrees with university and percentage/CGPA.',
        'Include relevant projects and certifications.',
        'Use a professional summary plus a skills block.',
      ],
    ),
  ];

  /// 5 × 10 = 50 templates.
  static final List<TemplateConfig> templates = _buildAllTemplates();

  static List<TemplateConfig> templatesFor(String countryCode) =>
      templates.where((TemplateConfig t) => t.countryCode == countryCode).toList();

  static CountryConfig countryFor(String code) =>
      countries.firstWhere((CountryConfig c) => c.code == code);

  static TemplateConfig templateFor(String id) =>
      templates.firstWhere((TemplateConfig t) => t.id == id);

  // ---------------------------------------------------------------------------
  // Catalogue construction
  // ---------------------------------------------------------------------------

  static List<TemplateConfig> _buildAllTemplates() {
    final List<TemplateConfig> all = <TemplateConfig>[];
    for (final CountryConfig c in countries) {
      for (int i = 0; i < TemplateArchetype.values.length; i++) {
        final TemplateArchetype a = TemplateArchetype.values[i];
        all.add(_buildTemplate(c, a, i + 1));
      }
    }
    return all;
  }

  static TemplateConfig _buildTemplate(
    CountryConfig country,
    TemplateArchetype archetype,
    int slot,
  ) {
    final _StyleBlend blend = _styleFor(archetype);
    final Color accent = _accentFor(country.code, archetype);
    final List<CvSectionKind> order = _sectionOrderFor(country.code, archetype);
    final String id = '${country.code}-${slot.toString().padLeft(2, '0')}';
    return TemplateConfig(
      id: id,
      countryCode: country.code,
      name: archetype.label,
      archetype: archetype,
      headerStyle: blend.headerStyle,
      fontFamily: blend.fontFamily,
      accentColor: accent,
      dividerStyle: blend.dividerStyle,
      spacingScale: blend.spacingScale,
      bulletStyle: blend.bulletStyle,
      uppercaseSectionHeaders: blend.uppercaseSectionHeaders,
      sectionOrder: order,
    );
  }

  static _StyleBlend _styleFor(TemplateArchetype a) {
    switch (a) {
      case TemplateArchetype.minimalStandard:
        return const _StyleBlend(
          headerStyle: HeaderStyle.leftAligned,
          fontFamily: 'Inter',
          dividerStyle: DividerStyle.thinLine,
          spacingScale: 1.0,
          bulletStyle: BulletStyle.dot,
          uppercaseSectionHeaders: true,
        );
      case TemplateArchetype.atsClean:
        return const _StyleBlend(
          headerStyle: HeaderStyle.leftAligned,
          fontFamily: 'Roboto',
          dividerStyle: DividerStyle.thinLine,
          spacingScale: 0.95,
          bulletStyle: BulletStyle.dot,
          uppercaseSectionHeaders: true,
        );
      case TemplateArchetype.modernProfessional:
        return const _StyleBlend(
          headerStyle: HeaderStyle.bandedAccent,
          fontFamily: 'Inter',
          dividerStyle: DividerStyle.accentLine,
          spacingScale: 1.05,
          bulletStyle: BulletStyle.dot,
          uppercaseSectionHeaders: true,
        );
      case TemplateArchetype.executiveSimple:
        return const _StyleBlend(
          headerStyle: HeaderStyle.classicCentred,
          fontFamily: 'Lora',
          dividerStyle: DividerStyle.doubleLine,
          spacingScale: 1.1,
          bulletStyle: BulletStyle.dash,
          uppercaseSectionHeaders: true,
        );
      case TemplateArchetype.graduateStarter:
        return const _StyleBlend(
          headerStyle: HeaderStyle.leftAligned,
          fontFamily: 'Source Sans 3',
          dividerStyle: DividerStyle.thinLine,
          spacingScale: 0.95,
          bulletStyle: BulletStyle.dot,
          uppercaseSectionHeaders: false,
        );
      case TemplateArchetype.experiencedProfessional:
        return const _StyleBlend(
          headerStyle: HeaderStyle.twoLineRule,
          fontFamily: 'Merriweather',
          dividerStyle: DividerStyle.accentLine,
          spacingScale: 1.15,
          bulletStyle: BulletStyle.dash,
          uppercaseSectionHeaders: true,
        );
      case TemplateArchetype.techFocused:
        return const _StyleBlend(
          headerStyle: HeaderStyle.leftAligned,
          fontFamily: 'JetBrains Mono',
          dividerStyle: DividerStyle.thinLine,
          spacingScale: 0.95,
          bulletStyle: BulletStyle.arrow,
          uppercaseSectionHeaders: true,
        );
      case TemplateArchetype.businessFocused:
        return const _StyleBlend(
          headerStyle: HeaderStyle.bandedAccent,
          fontFamily: 'Roboto',
          dividerStyle: DividerStyle.accentLine,
          spacingScale: 1.05,
          bulletStyle: BulletStyle.square,
          uppercaseSectionHeaders: true,
        );
      case TemplateArchetype.creativeMinimal:
        return const _StyleBlend(
          headerStyle: HeaderStyle.initialMonogram,
          fontFamily: 'Manrope',
          dividerStyle: DividerStyle.accentLine,
          spacingScale: 1.05,
          bulletStyle: BulletStyle.dot,
          uppercaseSectionHeaders: false,
        );
      case TemplateArchetype.onePageCompact:
        return const _StyleBlend(
          headerStyle: HeaderStyle.leftAligned,
          fontFamily: 'Inter',
          dividerStyle: DividerStyle.thinLine,
          spacingScale: 0.85,
          bulletStyle: BulletStyle.dot,
          uppercaseSectionHeaders: true,
        );
    }
  }

  static Color _accentFor(String country, TemplateArchetype a) {
    final Map<String, Color> base = <String, Color>{
      'GB': const Color(0xFF1F2A44),
      'US': const Color(0xFF0F2A4A),
      'CA': const Color(0xFF8B1F2A),
      'AU': const Color(0xFF13524A),
      'IN': const Color(0xFF6B3B12),
    };
    final Color c = base[country] ?? const Color(0xFF1F2A44);
    switch (a) {
      case TemplateArchetype.atsClean:
        return const Color(0xFF111111);
      case TemplateArchetype.modernProfessional:
        return c;
      case TemplateArchetype.executiveSimple:
        return const Color(0xFF1A1A1A);
      case TemplateArchetype.techFocused:
        return const Color(0xFF1B5E63);
      case TemplateArchetype.businessFocused:
        return c;
      case TemplateArchetype.creativeMinimal:
        return const Color(0xFF6B4FFF);
      default:
        return c;
    }
  }

  static List<CvSectionKind> _sectionOrderFor(
      String country, TemplateArchetype a) {
    // UK puts summary high. USA pushes experience right after summary.
    // Graduate templates put education first.
    final bool graduate = a == TemplateArchetype.graduateStarter;
    final bool tech = a == TemplateArchetype.techFocused;
    final bool exec = a == TemplateArchetype.executiveSimple ||
        a == TemplateArchetype.experiencedProfessional;

    if (graduate) {
      return const <CvSectionKind>[
        CvSectionKind.summary,
        CvSectionKind.education,
        CvSectionKind.skills,
        CvSectionKind.projects,
        CvSectionKind.experience,
        CvSectionKind.certifications,
        CvSectionKind.languages,
        CvSectionKind.references,
      ];
    }
    if (tech) {
      return const <CvSectionKind>[
        CvSectionKind.summary,
        CvSectionKind.skills,
        CvSectionKind.experience,
        CvSectionKind.projects,
        CvSectionKind.education,
        CvSectionKind.certifications,
        CvSectionKind.languages,
        CvSectionKind.references,
      ];
    }
    if (exec) {
      return const <CvSectionKind>[
        CvSectionKind.summary,
        CvSectionKind.experience,
        CvSectionKind.skills,
        CvSectionKind.education,
        CvSectionKind.certifications,
        CvSectionKind.projects,
        CvSectionKind.languages,
        CvSectionKind.references,
      ];
    }
    // Default — country flavoured
    if (country == 'IN') {
      return const <CvSectionKind>[
        CvSectionKind.summary,
        CvSectionKind.experience,
        CvSectionKind.education,
        CvSectionKind.skills,
        CvSectionKind.projects,
        CvSectionKind.certifications,
        CvSectionKind.languages,
        CvSectionKind.references,
      ];
    }
    return const <CvSectionKind>[
      CvSectionKind.summary,
      CvSectionKind.experience,
      CvSectionKind.education,
      CvSectionKind.skills,
      CvSectionKind.certifications,
      CvSectionKind.projects,
      CvSectionKind.languages,
      CvSectionKind.references,
    ];
  }
}

class _StyleBlend {
  const _StyleBlend({
    required this.headerStyle,
    required this.fontFamily,
    required this.dividerStyle,
    required this.spacingScale,
    required this.bulletStyle,
    required this.uppercaseSectionHeaders,
  });
  final HeaderStyle headerStyle;
  final String fontFamily;
  final DividerStyle dividerStyle;
  final double spacingScale;
  final BulletStyle bulletStyle;
  final bool uppercaseSectionHeaders;
}
