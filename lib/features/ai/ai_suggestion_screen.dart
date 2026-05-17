import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/country_catalog.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/primary_button.dart';
import '../../state/ai_notifier.dart';
import '../../state/cv_editor_notifier.dart';

class AiSuggestionScreen extends StatefulWidget {
  const AiSuggestionScreen({super.key});

  @override
  State<AiSuggestionScreen> createState() => _AiSuggestionScreenState();
}

class _AiSuggestionScreenState extends State<AiSuggestionScreen> {
  final TextEditingController _role = TextEditingController();
  List<String> _keywords = <String>[];
  bool _running = false;
  String? _error;

  @override
  void dispose() {
    _role.dispose();
    super.dispose();
  }

  Future<void> _run() async {
    final AiNotifier ai = context.read<AiNotifier>();
    final CvEditorNotifier editor = context.read<CvEditorNotifier>();
    if (editor.document == null) return;
    setState(() {
      _running = true;
      _error = null;
    });
    if (!ai.isConfigured) {
      setState(() {
        _running = false;
        _error = 'Set your Gemini API key in Settings to use AI suggestions.';
      });
      return;
    }
    final List<String>? out = await ai.suggestKeywords(
      role: _role.text,
      country: CountryCatalog.countryFor(editor.document!.countryCode),
    );
    if (!mounted) return;
    setState(() {
      _running = false;
      _keywords = out ?? <String>[];
      _error = ai.error;
    });
  }

  @override
  Widget build(BuildContext context) {
    final CvEditorNotifier editor = context.watch<CvEditorNotifier>();
    if (editor.document == null) {
      return const Scaffold(
        body: EmptyState(
          icon: Icons.auto_awesome_outlined,
          title: 'No CV in progress',
          message: 'Open a CV first to use AI suggestions.',
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('AI suggestions')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Text(
            'Enter the role you are targeting and we will suggest ATS-friendly keywords. '
            'You decide what to keep.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _role,
            decoration: const InputDecoration(
              labelText: 'Target role',
              hintText: 'e.g. Senior Backend Engineer',
            ),
          ),
          const SizedBox(height: 12),
          PrimaryButton(
            label: 'Suggest keywords',
            icon: Icons.auto_awesome_outlined,
            onPressed: _running ? null : _run,
          ),
          const SizedBox(height: 20),
          if (_running) const Center(child: CircularProgressIndicator()),
          if (_error != null)
            Text(_error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
          if (_keywords.isNotEmpty) ...<Widget>[
            Text('Suggested keywords',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _keywords
                  .map((String k) => InputChip(
                        label: Text(k),
                        onPressed: () {
                          context.read<CvEditorNotifier>().addSkill(k);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Added "$k" to skills')),
                          );
                        },
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}
