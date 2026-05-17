import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/education_entry.dart';
import '../../../state/cv_editor_notifier.dart';
import '../widgets/form_helpers.dart';

class EducationSection extends StatelessWidget {
  const EducationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final CvEditorNotifier ed = context.watch<CvEditorNotifier>();
    final List<EducationEntry> items = ed.document!.education;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SectionTitle('Education'),
        for (int i = 0; i < items.length; i++)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: <Widget>[
                  Row(children: <Widget>[
                    Expanded(
                      child: Text('Education ${i + 1}',
                          style: Theme.of(context).textTheme.titleSmall),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => ed.removeEducation(i),
                    ),
                  ]),
                  LabeledTextField(
                    label: 'Degree / Qualification',
                    value: items[i].degree,
                    onChanged: (String v) => ed.updateEducation(
                        i, items[i].copyWith(degree: v)),
                  ),
                  LabeledTextField(
                    label: 'Institution',
                    value: items[i].institution,
                    onChanged: (String v) => ed.updateEducation(
                        i, items[i].copyWith(institution: v)),
                  ),
                  LabeledTextField(
                    label: 'Location',
                    value: items[i].location,
                    onChanged: (String v) => ed.updateEducation(
                        i, items[i].copyWith(location: v)),
                  ),
                  Row(children: <Widget>[
                    Expanded(
                      child: LabeledTextField(
                        label: 'Start',
                        value: items[i].startDate,
                        onChanged: (String v) => ed.updateEducation(
                            i, items[i].copyWith(startDate: v)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: LabeledTextField(
                        label: 'End',
                        value: items[i].endDate,
                        onChanged: (String v) => ed.updateEducation(
                            i, items[i].copyWith(endDate: v)),
                      ),
                    ),
                  ]),
                  LabeledTextField(
                    label: 'Grade / GPA (optional)',
                    value: items[i].gradeOrGpa,
                    onChanged: (String v) => ed.updateEducation(
                        i, items[i].copyWith(gradeOrGpa: v)),
                  ),
                  LabeledTextField(
                    label: 'Details (optional)',
                    value: items[i].details,
                    multiline: true,
                    onChanged: (String v) => ed.updateEducation(
                        i, items[i].copyWith(details: v)),
                  ),
                ],
              ),
            ),
          ),
        OutlinedButton.icon(
          onPressed: () => ed.addEducation(),
          icon: const Icon(Icons.add),
          label: const Text('Add education'),
        ),
      ],
    );
  }
}
