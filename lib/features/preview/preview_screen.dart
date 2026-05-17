import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/country_config.dart';
import '../../models/cv_document.dart';
import '../../models/template_config.dart';
import '../../services/country_catalog.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/primary_button.dart';
import '../../state/cv_editor_notifier.dart';
import '../../state/cv_list_notifier.dart';
import 'cv_renderer.dart';

class PreviewScreen extends StatefulWidget {
  const PreviewScreen({super.key, required this.cvId});
  final String cvId;

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  String? _switcherTemplateId;

  @override
  Widget build(BuildContext context) {
    final CvEditorNotifier editor = context.watch<CvEditorNotifier>();
    final CvListNotifier list = context.watch<CvListNotifier>();
    final CvDocument? doc = editor.document?.id == widget.cvId
        ? editor.document
        : list.find(widget.cvId);
    if (doc == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Preview')),
        body: const EmptyState(
            icon: Icons.visibility_outlined,
            title: 'CV not found',
            message: 'This CV no longer exists.'),
      );
    }
    final CountryConfig country = CountryCatalog.countryFor(doc.countryCode);
    final String templateId = _switcherTemplateId ?? doc.templateId;
    final TemplateConfig template = CountryCatalog.templateFor(templateId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live preview'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.go('/editor/${doc.id}'),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          _TemplateSwitcher(
            doc: doc,
            currentId: templateId,
            onSelect: (String id) {
              setState(() => _switcherTemplateId = id);
              editor.setTemplate(id);
            },
          ),
          const Divider(height: 1),
          Expanded(
            child: InteractiveViewer(
              minScale: 0.6,
              maxScale: 2,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 700),
                    child: Material(
                      elevation: 6,
                      shadowColor: Colors.black.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      child: CvRenderer(
                        document: doc,
                        template: template,
                        country: country,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: PrimaryButton(
            label: 'Export as PDF',
            icon: Icons.picture_as_pdf_outlined,
            expanded: true,
            onPressed: () => context.push('/export/${doc.id}'),
          ),
        ),
      ),
    );
  }
}

class _TemplateSwitcher extends StatelessWidget {
  const _TemplateSwitcher({
    required this.doc,
    required this.currentId,
    required this.onSelect,
  });
  final CvDocument doc;
  final String currentId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final List<TemplateConfig> templates =
        CountryCatalog.templatesFor(doc.countryCode);
    return SizedBox(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        itemCount: templates.length,
        separatorBuilder: (BuildContext _, int __) =>
            const SizedBox(width: 6),
        itemBuilder: (BuildContext context, int i) {
          final TemplateConfig t = templates[i];
          return ChoiceChip(
            label: Text(t.name),
            selected: t.id == currentId,
            onSelected: (_) => onSelect(t.id),
          );
        },
      ),
    );
  }
}
