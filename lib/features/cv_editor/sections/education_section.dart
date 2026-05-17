import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/education_entry.dart';
import '../../../state/cv_editor_notifier.dart';
import '../widgets/date_range_field.dart';
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
        ReorderableListView.builder(
          shrinkWrap: true,
          buildDefaultDragHandles: false,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          onReorder: (int o, int n) => ed.reorderEducation(o, n),
          itemBuilder: (BuildContext context, int i) => _EducationCard(
            key: ValueKey<String>(items[i].id),
            index: i,
            item: items[i],
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

class _EducationCard extends StatelessWidget {
  const _EducationCard({
    super.key,
    required this.index,
    required this.item,
  });
  final int index;
  final EducationEntry item;

  @override
  Widget build(BuildContext context) {
    final CvEditorNotifier ed = context.read<CvEditorNotifier>();
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(children: <Widget>[
              ReorderableDragStartListener(
                index: index,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(Icons.drag_indicator, size: 20),
                ),
              ),
              Expanded(
                child: Text('Education ${index + 1}',
                    style: Theme.of(context).textTheme.titleSmall),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => ed.removeEducation(index),
              ),
            ]),
            LabeledTextField(
              label: 'Degree / Qualification',
              value: item.degree,
              onChanged: (String v) =>
                  ed.updateEducation(index, item.copyWith(degree: v)),
            ),
            LabeledTextField(
              label: 'Institution',
              value: item.institution,
              onChanged: (String v) =>
                  ed.updateEducation(index, item.copyWith(institution: v)),
            ),
            LabeledTextField(
              label: 'Location',
              value: item.location,
              onChanged: (String v) =>
                  ed.updateEducation(index, item.copyWith(location: v)),
            ),
            const SizedBox(height: 4),
            DateRangeField(
              start: item.startDate,
              end: item.endDate,
              current: false,
              showCurrentToggle: false,
              onStartChanged: (String v) =>
                  ed.updateEducation(index, item.copyWith(startDate: v)),
              onEndChanged: (String v) =>
                  ed.updateEducation(index, item.copyWith(endDate: v)),
              onCurrentChanged: (_) {},
            ),
            LabeledTextField(
              label: 'Grade / GPA (optional)',
              value: item.gradeOrGpa,
              onChanged: (String v) =>
                  ed.updateEducation(index, item.copyWith(gradeOrGpa: v)),
            ),
            LabeledTextField(
              label: 'Details (optional)',
              value: item.details,
              multiline: true,
              onChanged: (String v) =>
                  ed.updateEducation(index, item.copyWith(details: v)),
            ),
          ],
        ),
      ),
    );
  }
}
