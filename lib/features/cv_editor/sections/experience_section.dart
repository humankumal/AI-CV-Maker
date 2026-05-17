import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/work_experience.dart';
import '../../../services/ai_service.dart';
import '../../../services/country_catalog.dart';
import '../../../state/cv_editor_notifier.dart';
import '../widgets/form_helpers.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final CvEditorNotifier ed = context.watch<CvEditorNotifier>();
    final List<WorkExperience> items = ed.document!.experience;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SectionTitle('Work experience'),
        for (int i = 0; i < items.length; i++)
          _ExperienceCard(index: i, item: items[i]),
        const SizedBox(height: 4),
        OutlinedButton.icon(
          onPressed: () => ed.addExperience(),
          icon: const Icon(Icons.add),
          label: const Text('Add work experience'),
        ),
      ],
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  const _ExperienceCard({required this.index, required this.item});
  final int index;
  final WorkExperience item;

  @override
  Widget build(BuildContext context) {
    final CvEditorNotifier ed = context.read<CvEditorNotifier>();
    final dynamic doc = ed.document!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(children: <Widget>[
              Expanded(
                child: Text('Role ${index + 1}',
                    style: Theme.of(context).textTheme.titleSmall),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => ed.removeExperience(index),
              ),
            ]),
            LabeledTextField(
              label: 'Job title',
              value: item.jobTitle,
              onChanged: (String v) =>
                  ed.updateExperience(index, item.copyWith(jobTitle: v)),
            ),
            LabeledTextField(
              label: 'Company',
              value: item.company,
              onChanged: (String v) =>
                  ed.updateExperience(index, item.copyWith(company: v)),
            ),
            LabeledTextField(
              label: 'Location',
              value: item.location,
              onChanged: (String v) =>
                  ed.updateExperience(index, item.copyWith(location: v)),
            ),
            Row(children: <Widget>[
              Expanded(
                child: LabeledTextField(
                  label: 'Start',
                  hint: 'MMM YYYY',
                  value: item.startDate,
                  onChanged: (String v) =>
                      ed.updateExperience(index, item.copyWith(startDate: v)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: LabeledTextField(
                  label: 'End',
                  hint: item.current ? 'Present' : 'MMM YYYY',
                  value: item.current ? '' : item.endDate,
                  onChanged: (String v) =>
                      ed.updateExperience(index, item.copyWith(endDate: v)),
                ),
              ),
            ]),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              value: item.current,
              onChanged: (bool v) =>
                  ed.updateExperience(index, item.copyWith(current: v)),
              title: const Text('I currently work here'),
            ),
            const SizedBox(height: 4),
            _BulletsEditor(
              bullets: item.bullets,
              roleForAi: '${item.jobTitle} at ${item.company}',
              onChanged: (List<String> next) =>
                  ed.updateExperience(index, item.copyWith(bullets: next)),
              countryCode: doc.countryCode as String,
            ),
          ],
        ),
      ),
    );
  }
}

class _BulletsEditor extends StatelessWidget {
  const _BulletsEditor({
    required this.bullets,
    required this.onChanged,
    required this.countryCode,
    required this.roleForAi,
  });

  final List<String> bullets;
  final ValueChanged<List<String>> onChanged;
  final String countryCode;
  final String roleForAi;

  @override
  Widget build(BuildContext context) {
    final List<String> list = List<String>.from(bullets);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text('Achievements & responsibilities',
            style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 4),
        for (int i = 0; i < list.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: LabeledTextField(
                    label: 'Bullet ${i + 1}',
                    value: list[i],
                    multiline: true,
                    aiKind: AiFieldKind.experienceBullet,
                    country: CountryCatalog.countryFor(countryCode),
                    onChanged: (String v) {
                      final List<String> next = List<String>.from(list)
                        ..[i] = v;
                      onChanged(next);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    final List<String> next = List<String>.from(list)
                      ..removeAt(i);
                    onChanged(next);
                  },
                ),
              ],
            ),
          ),
        const SizedBox(height: 4),
        OutlinedButton.icon(
          onPressed: () => onChanged(<String>[...list, '']),
          icon: const Icon(Icons.add),
          label: const Text('Add bullet'),
        ),
      ],
    );
  }
}
