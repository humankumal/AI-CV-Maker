import 'package:flutter/material.dart' show Color;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/country_config.dart';
import '../models/cv_document.dart';
import '../models/template_config.dart';

int _argb(Color c) {
  // ignore: deprecated_member_use
  return c.value;
}

/// Renders a CV document to a PDF using the same TemplateConfig that drives
/// the live preview.
class PdfExportService {
  PdfExportService();

  Future<pw.Document> build({
    required CvDocument doc,
    required TemplateConfig template,
    required CountryConfig country,
  }) async {
    final pw.Document pdf = pw.Document();
    final pw.ThemeData theme = await _loadTheme(template);
    final PdfPageFormat format = _pageFormat(country);

    final PdfColor accent = PdfColor.fromInt(_argb(template.accentColor));

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format.copyWith(
          marginLeft: 36,
          marginRight: 36,
          marginTop: 36,
          marginBottom: 36,
        ),
        theme: theme,
        build: (pw.Context ctx) => <pw.Widget>[
          _header(doc, template, country, accent),
          pw.SizedBox(height: 16 * template.spacingScale),
          ..._sections(doc, template, country, accent),
        ],
      ),
    );
    return pdf;
  }

  Future<pw.ThemeData> _loadTheme(TemplateConfig template) async {
    final pw.Font base =
        await _fontFor(template.fontFamily, weight: FontWeight.normal);
    final pw.Font bold =
        await _fontFor(template.fontFamily, weight: FontWeight.bold);
    final pw.Font italic =
        await _fontFor(template.fontFamily, weight: FontWeight.italic);
    return pw.ThemeData.withFont(base: base, bold: bold, italic: italic);
  }

  Future<pw.Font> _fontFor(String family, {required FontWeight weight}) async {
    // PdfGoogleFonts has named helpers for popular families; we fall back to
    // Inter for anything not in the helper set. This keeps the PDF readable
    // and dependency-free of asset bundling.
    try {
      switch (family) {
        case 'Inter':
          return weight == FontWeight.bold
              ? await PdfGoogleFonts.interBold()
              : weight == FontWeight.italic
                  ? await PdfGoogleFonts.interItalic()
                  : await PdfGoogleFonts.interRegular();
        case 'Roboto':
          return weight == FontWeight.bold
              ? await PdfGoogleFonts.robotoBold()
              : weight == FontWeight.italic
                  ? await PdfGoogleFonts.robotoItalic()
                  : await PdfGoogleFonts.robotoRegular();
        case 'Lora':
          return weight == FontWeight.bold
              ? await PdfGoogleFonts.loraBold()
              : weight == FontWeight.italic
                  ? await PdfGoogleFonts.loraItalic()
                  : await PdfGoogleFonts.loraRegular();
        case 'Merriweather':
          return weight == FontWeight.bold
              ? await PdfGoogleFonts.merriweatherBold()
              : weight == FontWeight.italic
                  ? await PdfGoogleFonts.merriweatherItalic()
                  : await PdfGoogleFonts.merriweatherRegular();
        case 'JetBrains Mono':
          return weight == FontWeight.bold
              ? await PdfGoogleFonts.jetBrainsMonoBold()
              : await PdfGoogleFonts.jetBrainsMonoRegular();
        case 'Source Sans 3':
          return weight == FontWeight.bold
              ? await PdfGoogleFonts.sourceSans3Bold()
              : await PdfGoogleFonts.sourceSans3Regular();
        case 'Manrope':
          return weight == FontWeight.bold
              ? await PdfGoogleFonts.manropeBold()
              : await PdfGoogleFonts.manropeRegular();
      }
    } catch (_) {
      // Some helpers may not exist in older versions — fall back to default.
    }
    return weight == FontWeight.bold
        ? await PdfGoogleFonts.interBold()
        : await PdfGoogleFonts.interRegular();
  }

  PdfPageFormat _pageFormat(CountryConfig country) =>
      country.pageFormat == CountryPageFormat.letter
          ? PdfPageFormat.letter
          : PdfPageFormat.a4;

  // ---------------------------------------------------------------------------
  // Header
  // ---------------------------------------------------------------------------

  pw.Widget _header(CvDocument doc, TemplateConfig template,
      CountryConfig country, PdfColor accent) {
    final String name =
        doc.profile.fullName.isEmpty ? 'Your Name' : doc.profile.fullName;
    final String headline = doc.profile.headline;
    final List<String> contact = <String>[
      if (doc.profile.email.isNotEmpty) doc.profile.email,
      if (doc.profile.phone.isNotEmpty) doc.profile.phone,
      if (doc.profile.location.isNotEmpty) doc.profile.location,
      if (doc.profile.linkedIn.isNotEmpty) doc.profile.linkedIn,
      if (doc.profile.website.isNotEmpty) doc.profile.website,
    ];

    pw.Widget body(pw.CrossAxisAlignment align) =>
        pw.Column(crossAxisAlignment: align, children: <pw.Widget>[
          pw.Text(name,
              style: pw.TextStyle(
                  fontSize: 22, fontWeight: pw.FontWeight.bold, color: accent)),
          if (headline.isNotEmpty) ...<pw.Widget>[
            pw.SizedBox(height: 2),
            pw.Text(headline,
                style: const pw.TextStyle(fontSize: 11.5)),
          ],
          if (contact.isNotEmpty) ...<pw.Widget>[
            pw.SizedBox(height: 6),
            pw.Text(contact.join('   ·   '),
                style: const pw.TextStyle(fontSize: 9.5),
                textAlign: align == pw.CrossAxisAlignment.center
                    ? pw.TextAlign.center
                    : pw.TextAlign.left),
          ],
        ]);

    switch (template.headerStyle) {
      case HeaderStyle.classicCentred:
        return pw.Column(children: <pw.Widget>[
          body(pw.CrossAxisAlignment.center),
          pw.SizedBox(height: 8),
          pw.Divider(color: accent, thickness: 0.8),
        ]);
      case HeaderStyle.leftAligned:
        return body(pw.CrossAxisAlignment.start);
      case HeaderStyle.bandedAccent:
        return pw.Container(
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
              color: PdfColor(accent.red, accent.green, accent.blue, 0.08)),
          child: body(pw.CrossAxisAlignment.start),
        );
      case HeaderStyle.twoLineRule:
        return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Divider(color: accent, thickness: 1.2),
              pw.SizedBox(height: 6),
              body(pw.CrossAxisAlignment.start),
              pw.SizedBox(height: 6),
              pw.Divider(color: accent, thickness: 0.4),
            ]);
      case HeaderStyle.initialMonogram:
        final String initials = _initials(name);
        return pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: <pw.Widget>[
              pw.Container(
                width: 44,
                height: 44,
                alignment: pw.Alignment.center,
                decoration: pw.BoxDecoration(
                  color: accent,
                  shape: pw.BoxShape.circle,
                ),
                child: pw.Text(initials,
                    style: pw.TextStyle(
                        color: PdfColors.white,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 16)),
              ),
              pw.SizedBox(width: 12),
              pw.Expanded(child: body(pw.CrossAxisAlignment.start)),
            ]);
    }
  }

  String _initials(String name) {
    final List<String> parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((String s) => s.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }

  // ---------------------------------------------------------------------------
  // Sections
  // ---------------------------------------------------------------------------

  List<pw.Widget> _sections(CvDocument doc, TemplateConfig template,
      CountryConfig country, PdfColor accent) {
    final List<pw.Widget> out = <pw.Widget>[];
    for (final CvSectionKind kind in template.sectionOrder) {
      final pw.Widget? w = _section(kind, doc, template, country, accent);
      if (w != null) {
        out.add(w);
        out.add(pw.SizedBox(height: 10 * template.spacingScale));
      }
    }
    return out;
  }

  pw.Widget? _section(CvSectionKind kind, CvDocument doc,
      TemplateConfig template, CountryConfig country, PdfColor accent) {
    switch (kind) {
      case CvSectionKind.summary:
        if (doc.profile.summary.trim().isEmpty) return null;
        return _block(
            template, accent,
            country.docKind == 'CV' ? 'Personal Profile' : 'Summary',
            <pw.Widget>[pw.Text(doc.profile.summary,
                style: const pw.TextStyle(fontSize: 10.5))]);
      case CvSectionKind.experience:
        if (doc.experience.isEmpty) return null;
        return _block(template, accent, 'Experience',
            doc.experience.map((dynamic e) {
          final dynamic exp = e;
          return _experienceItem(template, accent, exp);
        }).toList());
      case CvSectionKind.education:
        if (doc.education.isEmpty) return null;
        return _block(template, accent, 'Education',
            doc.education.map((dynamic e) {
          final dynamic ed = e;
          return _educationItem(template, accent, ed);
        }).toList());
      case CvSectionKind.skills:
        if (doc.skills.isEmpty) return null;
        return _block(template, accent, 'Skills', <pw.Widget>[
          pw.Wrap(
            spacing: 6,
            runSpacing: 4,
            children: doc.skills
                .map((dynamic s) => pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: accent, width: 0.4),
                        borderRadius: pw.BorderRadius.circular(999),
                      ),
                      child: pw.Text((s.name as String),
                          style: const pw.TextStyle(fontSize: 9.5)),
                    ))
                .toList(),
          ),
        ]);
      case CvSectionKind.projects:
        if (doc.projects.isEmpty) return null;
        return _block(template, accent, 'Projects',
            doc.projects.map((dynamic p) {
          final dynamic pr = p;
          return _projectItem(template, accent, pr);
        }).toList());
      case CvSectionKind.certifications:
        if (doc.certifications.isEmpty) return null;
        return _block(template, accent, 'Certifications',
            doc.certifications.map((dynamic c) {
          return pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 2),
              child: pw.Row(children: <pw.Widget>[
                _bulletGlyph(template, accent),
                pw.SizedBox(width: 6),
                pw.Expanded(
                    child: pw.Text(
                        <String>[
                          c.name as String,
                          if ((c.issuer as String).isNotEmpty) c.issuer as String,
                          if ((c.issueDate as String).isNotEmpty)
                            c.issueDate as String,
                        ].where((String e) => e.isNotEmpty).join(' — '),
                        style: const pw.TextStyle(fontSize: 10))),
              ]));
        }).toList());
      case CvSectionKind.languages:
        if (doc.languages.isEmpty) return null;
        return _block(template, accent, 'Languages', <pw.Widget>[
          pw.Wrap(
            spacing: 10,
            runSpacing: 4,
            children: doc.languages
                .map((dynamic l) => pw.Text(
                    '${l.language} — ${(l.proficiency as dynamic).label}',
                    style: const pw.TextStyle(fontSize: 10)))
                .toList(),
          ),
        ]);
      case CvSectionKind.references:
        final String r = doc.references.trim();
        if (r.isEmpty) return null;
        return _block(template, accent, 'References',
            <pw.Widget>[pw.Text(r, style: const pw.TextStyle(fontSize: 10))]);
    }
  }

  pw.Widget _block(TemplateConfig template, PdfColor accent, String title,
      List<pw.Widget> children) {
    final String t = template.uppercaseSectionHeaders ? title.toUpperCase() : title;
    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: <pw.Widget>[
          pw.Text(t,
              style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                  color: accent,
                  letterSpacing: template.uppercaseSectionHeaders ? 1.0 : 0)),
          pw.SizedBox(height: 4),
          _sectionDivider(template, accent),
          pw.SizedBox(height: 6),
          ...children,
        ]);
  }

  pw.Widget _sectionDivider(TemplateConfig template, PdfColor accent) {
    switch (template.dividerStyle) {
      case DividerStyle.thinLine:
        return pw.Container(height: 0.6, color: PdfColors.grey400);
      case DividerStyle.doubleLine:
        return pw.Column(children: <pw.Widget>[
          pw.Container(height: 0.6, color: accent),
          pw.SizedBox(height: 1.5),
          pw.Container(height: 0.4, color: PdfColors.grey400),
        ]);
      case DividerStyle.accentLine:
        return pw.Container(height: 0.9, color: accent);
      case DividerStyle.none:
        return pw.SizedBox();
    }
  }

  pw.Widget _bulletGlyph(TemplateConfig template, PdfColor accent) {
    final String g = switch (template.bulletStyle) {
      BulletStyle.dot => '•',
      BulletStyle.dash => '–',
      BulletStyle.square => '▪',
      BulletStyle.arrow => '›',
    };
    return pw.Text(g,
        style: pw.TextStyle(
            color: accent, fontWeight: pw.FontWeight.bold, fontSize: 10));
  }

  pw.Widget _experienceItem(
      TemplateConfig template, PdfColor accent, dynamic exp) {
    final String dates = _dateRange(
        exp.startDate as String, exp.endDate as String, exp.current as bool);
    final List<pw.Widget> bullets = (exp.bullets as List<String>)
        .where((String s) => s.trim().isNotEmpty)
        .map((String s) => pw.Padding(
              padding: const pw.EdgeInsets.only(top: 2),
              child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: <pw.Widget>[
                    _bulletGlyph(template, accent),
                    pw.SizedBox(width: 6),
                    pw.Expanded(
                        child: pw.Text(s,
                            style: const pw.TextStyle(fontSize: 10))),
                  ]),
            ))
        .toList();
    return pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 6),
        child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: <pw.Widget>[
                    pw.Expanded(
                        child: pw.Text(
                            '${exp.jobTitle as String} · ${exp.company as String}',
                            style: pw.TextStyle(
                                fontSize: 10.5,
                                fontWeight: pw.FontWeight.bold))),
                    if (dates.isNotEmpty)
                      pw.Text(dates,
                          style: const pw.TextStyle(
                              fontSize: 9.5, color: PdfColors.grey700)),
                  ]),
              if ((exp.location as String).isNotEmpty)
                pw.Text(exp.location as String,
                    style: const pw.TextStyle(
                        fontSize: 9.5, color: PdfColors.grey700)),
              ...bullets,
            ]));
  }

  pw.Widget _educationItem(
      TemplateConfig template, PdfColor accent, dynamic ed) {
    final String dates = _dateRange(
        ed.startDate as String, ed.endDate as String, false);
    return pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 4),
        child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: <pw.Widget>[
                    pw.Expanded(
                        child: pw.Text(
                            '${ed.degree as String} · ${ed.institution as String}',
                            style: pw.TextStyle(
                                fontSize: 10.5,
                                fontWeight: pw.FontWeight.bold))),
                    if (dates.isNotEmpty)
                      pw.Text(dates,
                          style: const pw.TextStyle(
                              fontSize: 9.5, color: PdfColors.grey700)),
                  ]),
              if ((ed.location as String).isNotEmpty ||
                  (ed.gradeOrGpa as String).isNotEmpty)
                pw.Text(
                    <String>[ed.location as String, ed.gradeOrGpa as String]
                        .where((String e) => e.isNotEmpty)
                        .join(' · '),
                    style: const pw.TextStyle(
                        fontSize: 9.5, color: PdfColors.grey700)),
              if ((ed.details as String).isNotEmpty)
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 2),
                  child: pw.Text(ed.details as String,
                      style: const pw.TextStyle(fontSize: 10)),
                ),
            ]));
  }

  pw.Widget _projectItem(
      TemplateConfig template, PdfColor accent, dynamic pr) {
    final List<pw.Widget> bullets = (pr.bullets as List<String>)
        .where((String s) => s.trim().isNotEmpty)
        .map((String s) => pw.Padding(
              padding: const pw.EdgeInsets.only(top: 2),
              child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: <pw.Widget>[
                    _bulletGlyph(template, accent),
                    pw.SizedBox(width: 6),
                    pw.Expanded(
                        child: pw.Text(s,
                            style: const pw.TextStyle(fontSize: 10))),
                  ]),
            ))
        .toList();
    return pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 6),
        child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Text(pr.name as String,
                  style: pw.TextStyle(
                      fontSize: 10.5, fontWeight: pw.FontWeight.bold)),
              if ((pr.role as String).isNotEmpty ||
                  (pr.url as String).isNotEmpty)
                pw.Text(
                    <String>[pr.role as String, pr.url as String]
                        .where((String e) => e.isNotEmpty)
                        .join(' · '),
                    style: const pw.TextStyle(
                        fontSize: 9.5, color: PdfColors.grey700)),
              if ((pr.description as String).isNotEmpty)
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 2),
                  child: pw.Text(pr.description as String,
                      style: const pw.TextStyle(fontSize: 10)),
                ),
              ...bullets,
            ]));
  }

  String _dateRange(String start, String end, bool current) {
    final String s = start.trim();
    final String e = current ? 'Present' : end.trim();
    if (s.isEmpty && e.isEmpty) return '';
    if (s.isEmpty) return e;
    if (e.isEmpty) return s;
    return '$s – $e';
  }
}
