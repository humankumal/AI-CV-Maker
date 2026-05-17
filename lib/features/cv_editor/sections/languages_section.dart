import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/language_item.dart';
import '../../../state/cv_editor_notifier.dart';
import '../widgets/form_helpers.dart';

class LanguagesSection extends StatefulWidget {
  const LanguagesSection({super.key});

  @override
  State<LanguagesSection> createState() => _LanguagesSectionState();
}

class _LanguagesSectionState extends State<LanguagesSection> {
  final TextEditingController _lang = TextEditingController();
  LanguageProficiency _level = LanguageProficiency.professional;

  @override
  void dispose() {
    _lang.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CvEditorNotifier ed = context.watch<CvEditorNotifier>();
    final List<LanguageItem> items = ed.document!.languages;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SectionTitle('Languages (optional)'),
        Row(children: <Widget>[
          Expanded(
            child: TextField(
              controller: _lang,
              decoration: const InputDecoration(labelText: 'Language'),
            ),
          ),
          const SizedBox(width: 8),
          DropdownButton<LanguageProficiency>(
            value: _level,
            items: LanguageProficiency.values
                .map((LanguageProficiency p) => DropdownMenuItem<LanguageProficiency>(
                      value: p,
                      child: Text(p.label),
                    ))
                .toList(),
            onChanged: (LanguageProficiency? p) =>
                setState(() => _level = p ?? _level),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: () {
              if (_lang.text.trim().isEmpty) return;
              ed.addLanguage(LanguageItem(
                  language: _lang.text.trim(), proficiency: _level));
              _lang.clear();
            },
            child: const Text('Add'),
          ),
        ]),
        const SizedBox(height: 12),
        for (int i = 0; i < items.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                      '${items[i].language} — ${items[i].proficiency.label}'),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => ed.removeLanguage(i),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
