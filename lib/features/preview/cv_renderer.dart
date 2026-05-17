import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/certification_item.dart';
import '../../models/country_config.dart';
import '../../models/cv_document.dart';
import '../../models/education_entry.dart';
import '../../models/language_item.dart';
import '../../models/project_item.dart';
import '../../models/skill_item.dart';
import '../../models/template_config.dart';
import '../../models/work_experience.dart';

/// Renders any CV using only its TemplateConfig — same engine the PDF uses.
class CvRenderer extends StatelessWidget {
  const CvRenderer({
    super.key,
    required this.document,
    required this.template,
    required this.country,
    this.scale = 1.0,
  });

  final CvDocument document;
  final TemplateConfig template;
  final CountryConfig country;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final TextStyle baseStyle = GoogleFonts.getFont(
      template.fontFamily,
      fontSize: 11 * scale,
      color: Colors.black87,
      height: 1.4,
    );
    return Material(
      color: Colors.white,
      child: DefaultTextStyle(
        style: baseStyle,
        child: Padding(
          padding: EdgeInsets.all(28 * scale),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _Header(
                  document: document,
                  template: template,
                  country: country,
                  scale: scale),
              SizedBox(height: 14 * scale * template.spacingScale),
              ..._sections(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _sections() {
    final List<Widget> out = <Widget>[];
    for (final CvSectionKind kind in template.sectionOrder) {
      final Widget? w = _section(kind);
      if (w != null) {
        out.add(w);
        out.add(SizedBox(height: 10 * scale * template.spacingScale));
      }
    }
    return out;
  }

  Widget? _section(CvSectionKind kind) {
    switch (kind) {
      case CvSectionKind.summary:
        if (document.profile.summary.trim().isEmpty) return null;
        return _Block(
          template: template,
          scale: scale,
          title:
              country.docKind == 'CV' ? 'Personal Profile' : 'Summary',
          child: Text(document.profile.summary),
        );
      case CvSectionKind.experience:
        if (document.experience.isEmpty) return null;
        return _Block(
          template: template,
          scale: scale,
          title: 'Experience',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              for (final WorkExperience e in _typedExperience())
                _ExperienceItem(exp: e, template: template, scale: scale),
            ],
          ),
        );
      case CvSectionKind.education:
        if (document.education.isEmpty) return null;
        return _Block(
          template: template,
          scale: scale,
          title: 'Education',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              for (final EducationEntry e in _typedEducation())
                _EducationItem(ed: e, template: template, scale: scale),
            ],
          ),
        );
      case CvSectionKind.skills:
        if (document.skills.isEmpty) return null;
        return _Block(
          template: template,
          scale: scale,
          title: 'Skills',
          child: Wrap(
            spacing: 6 * scale,
            runSpacing: 4 * scale,
            children: <Widget>[
              for (final SkillItem s in _typedSkills())
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 8 * scale, vertical: 3 * scale),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: template.accentColor, width: 0.4),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(s.name,
                      style: TextStyle(fontSize: 10 * scale)),
                ),
            ],
          ),
        );
      case CvSectionKind.projects:
        if (document.projects.isEmpty) return null;
        return _Block(
          template: template,
          scale: scale,
          title: 'Projects',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              for (final ProjectItem p in _typedProjects())
                _ProjectItem(pr: p, template: template, scale: scale),
            ],
          ),
        );
      case CvSectionKind.certifications:
        if (document.certifications.isEmpty) return null;
        return _Block(
          template: template,
          scale: scale,
          title: 'Certifications',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              for (final CertificationItem c in _typedCerts())
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2 * scale),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _bulletGlyph(template, scale),
                      SizedBox(width: 6 * scale),
                      Expanded(
                        child: Text(
                          <String>[
                            c.name,
                            if (c.issuer.isNotEmpty) c.issuer,
                            if (c.issueDate.isNotEmpty) c.issueDate,
                          ].where((String e) => e.isNotEmpty).join(' — '),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      case CvSectionKind.languages:
        if (document.languages.isEmpty) return null;
        return _Block(
          template: template,
          scale: scale,
          title: 'Languages',
          child: Wrap(
            spacing: 10 * scale,
            runSpacing: 4 * scale,
            children: <Widget>[
              for (final LanguageItem l in _typedLanguages())
                Text('${l.language} — ${l.proficiency.label}'),
            ],
          ),
        );
      case CvSectionKind.references:
        if (document.references.trim().isEmpty) return null;
        return _Block(
          template: template,
          scale: scale,
          title: 'References',
          child: Text(document.references),
        );
    }
  }

  // Strongly-typed accessors keep `dynamic` out of the widget tree.
  List<WorkExperience> _typedExperience() => document.experience;
  List<EducationEntry> _typedEducation() => document.education;
  List<SkillItem> _typedSkills() => document.skills;
  List<ProjectItem> _typedProjects() => document.projects;
  List<CertificationItem> _typedCerts() => document.certifications;
  List<LanguageItem> _typedLanguages() => document.languages;
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  const _Header({
    required this.document,
    required this.template,
    required this.country,
    required this.scale,
  });
  final CvDocument document;
  final TemplateConfig template;
  final CountryConfig country;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final String name = document.profile.fullName.isEmpty
        ? 'Your Name'
        : document.profile.fullName;
    final String headline = document.profile.headline;
    final List<String> contact = <String>[
      if (document.profile.email.isNotEmpty) document.profile.email,
      if (document.profile.phone.isNotEmpty) document.profile.phone,
      if (document.profile.location.isNotEmpty) document.profile.location,
      if (document.profile.linkedIn.isNotEmpty) document.profile.linkedIn,
      if (document.profile.website.isNotEmpty) document.profile.website,
    ];

    Widget body(CrossAxisAlignment align) => Column(
          crossAxisAlignment: align,
          children: <Widget>[
            Text(
              name,
              style: GoogleFonts.getFont(
                template.fontFamily,
                fontSize: 22 * scale,
                fontWeight: FontWeight.w700,
                color: template.accentColor,
              ),
            ),
            if (headline.isNotEmpty) ...<Widget>[
              SizedBox(height: 2 * scale),
              Text(headline, style: TextStyle(fontSize: 11.5 * scale)),
            ],
            if (contact.isNotEmpty) ...<Widget>[
              SizedBox(height: 6 * scale),
              Text(
                contact.join('   ·   '),
                style: TextStyle(
                    fontSize: 9.5 * scale, color: Colors.black54),
                textAlign: align == CrossAxisAlignment.center
                    ? TextAlign.center
                    : TextAlign.start,
              ),
            ],
          ],
        );

    switch (template.headerStyle) {
      case HeaderStyle.classicCentred:
        return Column(
          children: <Widget>[
            body(CrossAxisAlignment.center),
            SizedBox(height: 8 * scale),
            Container(
                height: 0.8 * scale, width: double.infinity, color: template.accentColor),
          ],
        );
      case HeaderStyle.leftAligned:
        return body(CrossAxisAlignment.start);
      case HeaderStyle.bandedAccent:
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(10 * scale),
          color: template.accentColor.withOpacity(0.08),
          child: body(CrossAxisAlignment.start),
        );
      case HeaderStyle.twoLineRule:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                height: 1.2 * scale,
                width: double.infinity,
                color: template.accentColor),
            SizedBox(height: 6 * scale),
            body(CrossAxisAlignment.start),
            SizedBox(height: 6 * scale),
            Container(
                height: 0.4 * scale, width: double.infinity, color: Colors.black26),
          ],
        );
      case HeaderStyle.initialMonogram:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 44 * scale,
              height: 44 * scale,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: template.accentColor,
                shape: BoxShape.circle,
              ),
              child: Text(
                _initials(name),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16 * scale,
                ),
              ),
            ),
            SizedBox(width: 12 * scale),
            Expanded(child: body(CrossAxisAlignment.start)),
          ],
        );
    }
  }

  String _initials(String name) {
    final List<String> parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((String s) => s.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}

// ---------------------------------------------------------------------------
// Block + items
// ---------------------------------------------------------------------------

class _Block extends StatelessWidget {
  const _Block({
    required this.template,
    required this.scale,
    required this.title,
    required this.child,
  });
  final TemplateConfig template;
  final double scale;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final String t =
        template.uppercaseSectionHeaders ? title.toUpperCase() : title;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          t,
          style: GoogleFonts.getFont(
            template.fontFamily,
            fontSize: 11 * scale,
            fontWeight: FontWeight.w700,
            color: template.accentColor,
            letterSpacing: template.uppercaseSectionHeaders ? 1.0 : 0,
          ),
        ),
        SizedBox(height: 4 * scale),
        _divider(template, scale),
        SizedBox(height: 6 * scale),
        child,
      ],
    );
  }

  Widget _divider(TemplateConfig t, double scale) {
    switch (t.dividerStyle) {
      case DividerStyle.thinLine:
        return Container(
            height: 0.6 * scale, width: double.infinity, color: Colors.black26);
      case DividerStyle.doubleLine:
        return Column(children: <Widget>[
          Container(
              height: 0.6 * scale,
              width: double.infinity,
              color: t.accentColor),
          SizedBox(height: 1.5 * scale),
          Container(
              height: 0.4 * scale,
              width: double.infinity,
              color: Colors.black26),
        ]);
      case DividerStyle.accentLine:
        return Container(
            height: 0.9 * scale, width: double.infinity, color: t.accentColor);
      case DividerStyle.none:
        return const SizedBox.shrink();
    }
  }
}

Widget _bulletGlyph(TemplateConfig template, double scale) {
  final String g = switch (template.bulletStyle) {
    BulletStyle.dot => '•',
    BulletStyle.dash => '–',
    BulletStyle.square => '▪',
    BulletStyle.arrow => '›',
  };
  return Text(
    g,
    style: TextStyle(
      color: template.accentColor,
      fontWeight: FontWeight.bold,
      fontSize: 10 * scale,
    ),
  );
}

class _ExperienceItem extends StatelessWidget {
  const _ExperienceItem(
      {required this.exp, required this.template, required this.scale});
  final WorkExperience exp;
  final TemplateConfig template;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final String dates = _dates(exp.startDate, exp.endDate, exp.current);
    return Padding(
      padding: EdgeInsets.only(bottom: 6 * scale),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '${exp.jobTitle} · ${exp.company}',
                  style: TextStyle(
                      fontSize: 10.5 * scale, fontWeight: FontWeight.w700),
                ),
              ),
              if (dates.isNotEmpty)
                Text(dates,
                    style: TextStyle(
                        fontSize: 9.5 * scale, color: Colors.black54)),
            ],
          ),
          if (exp.location.isNotEmpty)
            Text(exp.location,
                style:
                    TextStyle(fontSize: 9.5 * scale, color: Colors.black54)),
          for (final String b
              in exp.bullets.where((String b) => b.trim().isNotEmpty))
            Padding(
              padding: EdgeInsets.only(top: 2 * scale),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _bulletGlyph(template, scale),
                  SizedBox(width: 6 * scale),
                  Expanded(child: Text(b)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _dates(String start, String end, bool current) {
    final String s = start.trim();
    final String e = current ? 'Present' : end.trim();
    if (s.isEmpty && e.isEmpty) return '';
    if (s.isEmpty) return e;
    if (e.isEmpty) return s;
    return '$s – $e';
  }
}

class _EducationItem extends StatelessWidget {
  const _EducationItem(
      {required this.ed, required this.template, required this.scale});
  final EducationEntry ed;
  final TemplateConfig template;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final String dates = ed.startDate.isEmpty && ed.endDate.isEmpty
        ? ''
        : '${ed.startDate} – ${ed.endDate}';
    return Padding(
      padding: EdgeInsets.only(bottom: 4 * scale),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  '${ed.degree} · ${ed.institution}',
                  style: TextStyle(
                      fontSize: 10.5 * scale, fontWeight: FontWeight.w700),
                ),
              ),
              if (dates.isNotEmpty)
                Text(dates,
                    style: TextStyle(
                        fontSize: 9.5 * scale, color: Colors.black54)),
            ],
          ),
          if (ed.location.isNotEmpty || ed.gradeOrGpa.isNotEmpty)
            Text(
              <String>[ed.location, ed.gradeOrGpa]
                  .where((String e) => e.isNotEmpty)
                  .join(' · '),
              style: TextStyle(fontSize: 9.5 * scale, color: Colors.black54),
            ),
          if (ed.details.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 2 * scale),
              child: Text(ed.details),
            ),
        ],
      ),
    );
  }
}

class _ProjectItem extends StatelessWidget {
  const _ProjectItem(
      {required this.pr, required this.template, required this.scale});
  final ProjectItem pr;
  final TemplateConfig template;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6 * scale),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(pr.name,
              style: TextStyle(
                  fontSize: 10.5 * scale, fontWeight: FontWeight.w700)),
          if (pr.role.isNotEmpty || pr.url.isNotEmpty)
            Text(
              <String>[pr.role, pr.url]
                  .where((String e) => e.isNotEmpty)
                  .join(' · '),
              style: TextStyle(fontSize: 9.5 * scale, color: Colors.black54),
            ),
          if (pr.description.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 2 * scale),
              child: Text(pr.description),
            ),
          for (final String b
              in pr.bullets.where((String b) => b.trim().isNotEmpty))
            Padding(
              padding: EdgeInsets.only(top: 2 * scale),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _bulletGlyph(template, scale),
                  SizedBox(width: 6 * scale),
                  Expanded(child: Text(b)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
