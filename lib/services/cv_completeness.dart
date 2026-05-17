import '../models/cv_document.dart';
import '../models/template_config.dart';

/// Computes how complete each section of a CV is. Used by the editor stepper
/// to show progress and by the preview screen for a small completeness chip.
class CvCompleteness {
  CvCompleteness._();

  /// Returns 0.0 — 1.0 for the given section.
  static double scoreFor(CvSectionKind kind, CvDocument doc) {
    switch (kind) {
      case CvSectionKind.summary:
        final int len = doc.profile.summary.trim().length;
        if (len == 0) return 0;
        if (len < 80) return 0.5;
        return 1;
      case CvSectionKind.experience:
        if (doc.experience.isEmpty) return 0;
        final int withBullets = doc.experience
            .where((e) => e.bullets.any((b) => b.trim().isNotEmpty))
            .length;
        if (withBullets == 0) return 0.4;
        if (withBullets < doc.experience.length) return 0.7;
        return 1;
      case CvSectionKind.education:
        return doc.education.isEmpty ? 0 : 1;
      case CvSectionKind.skills:
        if (doc.skills.isEmpty) return 0;
        if (doc.skills.length < 4) return 0.5;
        return 1;
      case CvSectionKind.projects:
        return doc.projects.isEmpty ? 0 : 1;
      case CvSectionKind.certifications:
        return doc.certifications.isEmpty ? 0 : 1;
      case CvSectionKind.languages:
        return doc.languages.isEmpty ? 0 : 1;
      case CvSectionKind.references:
        return doc.references.trim().isEmpty ? 0 : 1;
    }
  }

  /// Score for the contact details (basics).
  static double basicsScore(CvDocument doc) {
    final List<String> required = <String>[
      doc.profile.fullName,
      doc.profile.email,
      doc.profile.phone,
      doc.profile.location,
    ];
    final int filled =
        required.where((String s) => s.trim().isNotEmpty).length;
    return filled / required.length;
  }

  /// Overall score 0..1 across all required sections (basics + summary +
  /// experience + education + skills).
  static double overall(CvDocument doc) {
    final List<double> scores = <double>[
      basicsScore(doc),
      scoreFor(CvSectionKind.summary, doc),
      scoreFor(CvSectionKind.experience, doc),
      scoreFor(CvSectionKind.education, doc),
      scoreFor(CvSectionKind.skills, doc),
    ];
    return scores.reduce((double a, double b) => a + b) / scores.length;
  }
}
