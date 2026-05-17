import 'package:flutter/material.dart';

class TemplateConfig {
  const TemplateConfig({
    required this.id,
    required this.countryCode,
    required this.name,
    required this.archetype,
    required this.headerStyle,
    required this.fontFamily,
    required this.accentColor,
    required this.dividerStyle,
    required this.spacingScale,
    required this.bulletStyle,
    required this.uppercaseSectionHeaders,
    required this.sectionOrder,
  });

  final String id; // e.g. UK-01
  final String countryCode;
  final String name;
  final TemplateArchetype archetype;
  final HeaderStyle headerStyle;
  final String fontFamily; // google_fonts family name
  final Color accentColor;
  final DividerStyle dividerStyle;
  final double spacingScale; // 0.85 .. 1.15
  final BulletStyle bulletStyle;
  final bool uppercaseSectionHeaders;
  final List<CvSectionKind> sectionOrder;
}

enum TemplateArchetype {
  minimalStandard,
  atsClean,
  modernProfessional,
  executiveSimple,
  graduateStarter,
  experiencedProfessional,
  techFocused,
  businessFocused,
  creativeMinimal,
  onePageCompact;

  String get label => switch (this) {
        TemplateArchetype.minimalStandard => 'Minimal Standard',
        TemplateArchetype.atsClean => 'ATS Clean',
        TemplateArchetype.modernProfessional => 'Modern Professional',
        TemplateArchetype.executiveSimple => 'Executive Simple',
        TemplateArchetype.graduateStarter => 'Graduate Starter',
        TemplateArchetype.experiencedProfessional => 'Experienced Professional',
        TemplateArchetype.techFocused => 'Tech Focused',
        TemplateArchetype.businessFocused => 'Business Focused',
        TemplateArchetype.creativeMinimal => 'Creative Minimal',
        TemplateArchetype.onePageCompact => 'One-Page Compact',
      };

  String get description => switch (this) {
        TemplateArchetype.minimalStandard =>
          'Clean, simple, and universally accepted.',
        TemplateArchetype.atsClean =>
          'Pure text-first layout optimised for ATS parsers.',
        TemplateArchetype.modernProfessional =>
          'Subtle accent and refined typography.',
        TemplateArchetype.executiveSimple =>
          'Confident serif look for senior roles.',
        TemplateArchetype.graduateStarter =>
          'Front-loads education and skills for early careers.',
        TemplateArchetype.experiencedProfessional =>
          'Generous spacing for long, detailed histories.',
        TemplateArchetype.techFocused =>
          'Highlights skills, projects, and stack.',
        TemplateArchetype.businessFocused =>
          'Achievement-led layout for managers and consultants.',
        TemplateArchetype.creativeMinimal =>
          'Distinct accent with restrained typography.',
        TemplateArchetype.onePageCompact =>
          'Tight one-page layout for concise candidates.',
      };
}

enum HeaderStyle {
  classicCentred,
  leftAligned,
  bandedAccent,
  twoLineRule,
  initialMonogram,
}

enum DividerStyle { thinLine, doubleLine, accentLine, none }

enum BulletStyle { dot, dash, square, arrow }

enum CvSectionKind {
  summary,
  experience,
  education,
  skills,
  projects,
  certifications,
  languages,
  references;

  String get label => switch (this) {
        CvSectionKind.summary => 'Summary',
        CvSectionKind.experience => 'Experience',
        CvSectionKind.education => 'Education',
        CvSectionKind.skills => 'Skills',
        CvSectionKind.projects => 'Projects',
        CvSectionKind.certifications => 'Certifications',
        CvSectionKind.languages => 'Languages',
        CvSectionKind.references => 'References',
      };
}
