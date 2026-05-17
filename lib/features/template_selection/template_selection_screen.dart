import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/country_config.dart';
import '../../models/cv_document.dart';
import '../../models/template_config.dart';
import '../../services/country_catalog.dart';
import '../../shared/widgets/primary_button.dart';
import '../../state/cv_editor_notifier.dart';
import 'template_card.dart';

class TemplateSelectionScreen extends StatefulWidget {
  const TemplateSelectionScreen({super.key, required this.countryCode});
  final String countryCode;

  @override
  State<TemplateSelectionScreen> createState() =>
      _TemplateSelectionScreenState();
}

class _TemplateSelectionScreenState extends State<TemplateSelectionScreen> {
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    final List<TemplateConfig> list =
        CountryCatalog.templatesFor(widget.countryCode);
    _selectedId = list.first.id;
  }

  @override
  Widget build(BuildContext context) {
    final CountryConfig country = CountryCatalog.countryFor(widget.countryCode);
    final List<TemplateConfig> templates =
        CountryCatalog.templatesFor(widget.countryCode);

    return Scaffold(
      appBar: AppBar(
        title: Text('${country.flag}  Pick a template'),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints c) {
          final int cols = c.maxWidth >= 1100
              ? 4
              : c.maxWidth >= 800
                  ? 3
                  : c.maxWidth >= 520
                      ? 2
                      : 2;
          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.55,
            ),
            itemCount: templates.length,
            itemBuilder: (BuildContext context, int i) {
              final TemplateConfig t = templates[i];
              return TemplateCard(
                template: t,
                selected: t.id == _selectedId,
                onTap: () => setState(() => _selectedId = t.id),
              );
            },
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: PrimaryButton(
            label: 'Use this template',
            icon: Icons.arrow_forward,
            expanded: true,
            onPressed: _selectedId == null
                ? null
                : () {
                    final CvDocument doc = CvDocument(
                      countryCode: country.code,
                      templateId: _selectedId!,
                    );
                    context.read<CvEditorNotifier>().open(doc);
                    context.push('/editor/${doc.id}');
                  },
          ),
        ),
      ),
    );
  }
}
