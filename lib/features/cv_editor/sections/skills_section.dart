import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../state/cv_editor_notifier.dart';
import '../widgets/form_helpers.dart';

class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});

  @override
  State<SkillsSection> createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> {
  final TextEditingController _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CvEditorNotifier ed = context.watch<CvEditorNotifier>();
    final dynamic items = ed.document!.skills;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SectionTitle('Skills'),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            'Add 6–12 skills relevant to the role. Press Enter to add each one.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _ctrl,
                onSubmitted: (String v) {
                  ed.addSkill(v);
                  _ctrl.clear();
                },
                decoration: const InputDecoration(
                  hintText: 'e.g. Python, Stakeholder management, Figma',
                ),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: () {
                ed.addSkill(_ctrl.text);
                _ctrl.clear();
              },
              child: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: <Widget>[
            for (int i = 0; i < items.length; i++)
              InputChip(
                label: Text(items[i].name as String),
                onDeleted: () => ed.removeSkill(i),
              ),
          ],
        ),
      ],
    );
  }
}
