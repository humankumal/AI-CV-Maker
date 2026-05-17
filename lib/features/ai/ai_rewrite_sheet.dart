import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/country_config.dart';
import '../../services/ai_service.dart';
import '../../state/ai_notifier.dart';
import '../../shared/widgets/primary_button.dart';

/// Modal bottom sheet that shows the AI's rewrite of a single field so the
/// user can accept it, edit it, or discard it. Never auto-replaces.
class AiRewriteSheet extends StatefulWidget {
  const AiRewriteSheet({
    super.key,
    required this.original,
    required this.kind,
    required this.country,
  });

  final String original;
  final AiFieldKind kind;
  final CountryConfig country;

  @override
  State<AiRewriteSheet> createState() => _AiRewriteSheetState();
}

class _AiRewriteSheetState extends State<AiRewriteSheet> {
  String? _rewritten;
  String? _error;
  bool _running = false;
  final TextEditingController _editCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    setState(() {
      _running = true;
      _error = null;
    });
    final AiNotifier ai = context.read<AiNotifier>();
    if (!ai.isConfigured) {
      setState(() {
        _running = false;
        _error = 'Set your Gemini API key in Settings to use AI rewriting.';
      });
      return;
    }
    final String? out = await ai.rewrite(
      text: widget.original,
      kind: widget.kind,
      country: widget.country,
    );
    if (!mounted) return;
    setState(() {
      _running = false;
      _rewritten = out;
      _error = ai.error;
      if (out != null) _editCtrl.text = out;
    });
  }

  @override
  void dispose() {
    _editCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    final TextTheme t = Theme.of(context).textTheme;
    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.auto_awesome_outlined, color: cs.primary),
                  const SizedBox(width: 8),
                  Text('Improve with AI', style: t.titleMedium),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'The AI rewrites your text in a professional tone. '
                'It never invents new facts.',
                style: t.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              ),
              const SizedBox(height: 14),
              if (_running)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_error != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cs.errorContainer.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(_error!,
                      style: TextStyle(color: cs.onErrorContainer)),
                )
              else if (_rewritten != null)
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 320),
                  child: SingleChildScrollView(
                    child: TextField(
                      controller: _editCtrl,
                      minLines: 4,
                      maxLines: 16,
                      decoration: const InputDecoration(
                        labelText: 'Rewritten text — edit freely',
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 14),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _running ? null : () => Navigator.pop(context),
                      child: const Text('Discard'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      onPressed: _running ? null : _run,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: PrimaryButton(
                      label: 'Accept',
                      icon: Icons.check,
                      onPressed: (_running || _rewritten == null)
                          ? null
                          : () => Navigator.pop(context, _editCtrl.text),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
