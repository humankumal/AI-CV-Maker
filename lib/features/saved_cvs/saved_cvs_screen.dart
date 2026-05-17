import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/cv_document.dart';
import '../../services/country_catalog.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/primary_button.dart';
import '../../state/cv_editor_notifier.dart';
import '../../state/cv_list_notifier.dart';
import '../../utils/extensions.dart';

class SavedCvsScreen extends StatelessWidget {
  const SavedCvsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CvListNotifier list = context.watch<CvListNotifier>();
    return Scaffold(
      appBar: AppBar(title: const Text('My CVs')),
      body: list.loading
          ? const Center(child: CircularProgressIndicator())
          : list.isEmpty
              ? EmptyState(
                  icon: Icons.folder_open_outlined,
                  title: 'No CVs yet',
                  message: 'Create your first CV to see it here.',
                  action: PrimaryButton(
                    label: 'Create new CV',
                    icon: Icons.add,
                    onPressed: () => context.push('/country'),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.cvs.length,
                  separatorBuilder: (BuildContext _, int __) =>
                      const SizedBox(height: 10),
                  itemBuilder: (BuildContext ctx, int i) =>
                      _CvTile(doc: list.cvs[i]),
                ),
      floatingActionButton: list.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () => context.push('/country'),
              icon: const Icon(Icons.add),
              label: const Text('New CV'),
            ),
    );
  }
}

class _CvTile extends StatelessWidget {
  const _CvTile({required this.doc});
  final CvDocument doc;

  @override
  Widget build(BuildContext context) {
    final dynamic country = CountryCatalog.countryFor(doc.countryCode);
    final dynamic template = CountryCatalog.templateFor(doc.templateId);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          context.read<CvEditorNotifier>().open(doc);
          context.push('/editor/${doc.id}');
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundColor:
                    Theme.of(context).colorScheme.primaryContainer,
                child: Text(country.flag as String,
                    style: const TextStyle(fontSize: 18)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(doc.name,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      '${country.name} · ${template.name} · ${doc.updatedAt.relativeShort}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (String value) => _onAction(context, value),
                itemBuilder: (BuildContext _) => const <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(value: 'rename', child: Text('Rename')),
                  PopupMenuItem<String>(
                      value: 'duplicate', child: Text('Duplicate')),
                  PopupMenuItem<String>(value: 'export', child: Text('Export')),
                  PopupMenuDivider(),
                  PopupMenuItem<String>(value: 'delete', child: Text('Delete')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onAction(BuildContext context, String action) async {
    final CvListNotifier list = context.read<CvListNotifier>();
    switch (action) {
      case 'rename':
        final String? name = await _prompt(context, 'Rename CV', doc.name);
        if (name != null && name.isNotEmpty) {
          await list.rename(doc.id, name);
        }
        break;
      case 'duplicate':
        await list.duplicate(doc.id);
        break;
      case 'export':
        if (!context.mounted) return;
        context.push('/export/${doc.id}');
        break;
      case 'delete':
        if (!context.mounted) return;
        final bool? ok = await showDialog<bool>(
          context: context,
          builder: (BuildContext ctx) => AlertDialog(
            title: const Text('Delete CV?'),
            content: Text('"${doc.name}" will be removed permanently.'),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Cancel')),
              FilledButton.tonal(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Delete')),
            ],
          ),
        );
        if (ok == true) await list.remove(doc.id);
        break;
    }
  }

  Future<String?> _prompt(
      BuildContext context, String title, String initial) async {
    final TextEditingController c = TextEditingController(text: initial);
    return showDialog<String>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: c,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, c.text.trim()),
              child: const Text('Save')),
        ],
      ),
    );
  }
}
