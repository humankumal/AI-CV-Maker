import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../state/cv_editor_notifier.dart';
import '../widgets/form_helpers.dart';

class ReferencesSection extends StatelessWidget {
  const ReferencesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final CvEditorNotifier ed = context.watch<CvEditorNotifier>();
    final dynamic doc = ed.document!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SectionTitle('References (optional)'),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            'You can list references here, or simply write "Available on request".',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        LabeledTextField(
          label: 'References',
          value: doc.references as String,
          multiline: true,
          onChanged: ed.setReferences,
        ),
      ],
    );
  }
}
