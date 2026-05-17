import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/project_item.dart';
import '../../../services/ai_service.dart';
import '../../../services/country_catalog.dart';
import '../../../state/cv_editor_notifier.dart';
import '../widgets/form_helpers.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final CvEditorNotifier ed = context.watch<CvEditorNotifier>();
    final dynamic doc = ed.document!;
    final List<ProjectItem> items = ed.document!.projects;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SectionTitle('Projects (optional)'),
        for (int i = 0; i < items.length; i++)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: <Widget>[
                  Row(children: <Widget>[
                    Expanded(
                      child: Text('Project ${i + 1}',
                          style: Theme.of(context).textTheme.titleSmall),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => ed.removeProject(i),
                    ),
                  ]),
                  LabeledTextField(
                    label: 'Project name',
                    value: items[i].name,
                    onChanged: (String v) =>
                        ed.updateProject(i, items[i].copyWith(name: v)),
                  ),
                  LabeledTextField(
                    label: 'Role',
                    value: items[i].role,
                    onChanged: (String v) =>
                        ed.updateProject(i, items[i].copyWith(role: v)),
                  ),
                  LabeledTextField(
                    label: 'URL (optional)',
                    value: items[i].url,
                    onChanged: (String v) =>
                        ed.updateProject(i, items[i].copyWith(url: v)),
                  ),
                  LabeledTextField(
                    label: 'Description',
                    value: items[i].description,
                    multiline: true,
                    aiKind: AiFieldKind.projectBullet,
                    country: CountryCatalog.countryFor(doc.countryCode as String),
                    onChanged: (String v) =>
                        ed.updateProject(i, items[i].copyWith(description: v)),
                  ),
                ],
              ),
            ),
          ),
        OutlinedButton.icon(
          onPressed: () => ed.addProject(),
          icon: const Icon(Icons.add),
          label: const Text('Add project'),
        ),
      ],
    );
  }
}
