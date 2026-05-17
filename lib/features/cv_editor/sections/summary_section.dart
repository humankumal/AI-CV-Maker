import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/ai_service.dart';
import '../../../services/country_catalog.dart';
import '../../../state/cv_editor_notifier.dart';
import '../widgets/form_helpers.dart';

class SummarySection extends StatelessWidget {
  const SummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    final CvEditorNotifier ed = context.watch<CvEditorNotifier>();
    final dynamic doc = ed.document!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SectionTitle('Professional summary'),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            CountryCatalog.countryFor(doc.countryCode).docKind == 'CV'
                ? 'A short personal profile (3–4 lines) at the top of your CV.'
                : 'A short summary (2–3 lines) at the top of your resume.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        LabeledTextField(
          label: 'Summary',
          value: doc.profile.summary as String,
          multiline: true,
          aiKind: AiFieldKind.summary,
          country: CountryCatalog.countryFor(doc.countryCode),
          onChanged: (String v) => ed.setProfile(doc.profile.copyWith(summary: v)),
          hint:
              'Write a draft in your own words. Tap the spark icon to polish it.',
        ),
      ],
    );
  }
}
