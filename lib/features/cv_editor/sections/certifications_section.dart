import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/certification_item.dart';
import '../../../state/cv_editor_notifier.dart';
import '../widgets/form_helpers.dart';

class CertificationsSection extends StatelessWidget {
  const CertificationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final CvEditorNotifier ed = context.watch<CvEditorNotifier>();
    final List<CertificationItem> items = ed.document!.certifications;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SectionTitle('Certifications (optional)'),
        for (int i = 0; i < items.length; i++)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: <Widget>[
                  Row(children: <Widget>[
                    Expanded(
                      child: Text('Certification ${i + 1}',
                          style: Theme.of(context).textTheme.titleSmall),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => ed.removeCertification(i),
                    ),
                  ]),
                  LabeledTextField(
                    label: 'Name',
                    value: items[i].name,
                    onChanged: (String v) =>
                        ed.updateCertification(i, items[i].copyWith(name: v)),
                  ),
                  LabeledTextField(
                    label: 'Issuer',
                    value: items[i].issuer,
                    onChanged: (String v) => ed.updateCertification(
                        i, items[i].copyWith(issuer: v)),
                  ),
                  LabeledTextField(
                    label: 'Issue date',
                    value: items[i].issueDate,
                    onChanged: (String v) => ed.updateCertification(
                        i, items[i].copyWith(issueDate: v)),
                  ),
                ],
              ),
            ),
          ),
        OutlinedButton.icon(
          onPressed: () => ed.addCertification(),
          icon: const Icon(Icons.add),
          label: const Text('Add certification'),
        ),
      ],
    );
  }
}
