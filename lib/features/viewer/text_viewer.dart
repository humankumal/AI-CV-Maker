import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

import '../../models/document_file.dart';
import '../../state/pro_notifier.dart';
import '../../state/settings_notifier.dart';

class TextViewer extends StatefulWidget {
  const TextViewer({super.key, required this.file});
  final DocumentFile file;

  @override
  State<TextViewer> createState() => _TextViewerState();
}

class _TextViewerState extends State<TextViewer> {
  String? _content;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadFile();
  }

  Future<void> _loadFile() async {
    try {
      // Guard: don't load files over 10 MB into memory
      final File file = File(widget.file.path);
      if (widget.file.sizeBytes > 10 * 1024 * 1024) {
        setState(() {
          _error = 'File is too large to display (${widget.file.formattedSize}).\n'
              'Try opening it with another app.';
          _loading = false;
        });
        return;
      }
      final String content = await file.readAsString();
      setState(() {
        _content = content;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Cannot read file: ${e.toString()}';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isPro = context.watch<ProNotifier>().isPro;
    final settings = context.watch<SettingsNotifier>();
    final String ext = widget.file.extension.toLowerCase();
    final bool isMarkdown = ext == 'md' || ext == 'markdown';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.file.name, overflow: TextOverflow.ellipsis),
        actions: [
          if (isPro)
            IconButton(
              icon: const Icon(Icons.text_fields),
              tooltip: 'Text options',
              onPressed: () => _showTextOptions(context, settings),
            ),
        ],
      ),
      body: _buildBody(context, isPro, settings, isMarkdown),
    );
  }

  Widget _buildBody(BuildContext context, bool isPro,
      SettingsNotifier settings, bool isMarkdown) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _error!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
          ),
        ),
      );
    }
    if (isMarkdown) {
      return Markdown(
        data: _content!,
        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
        padding: const EdgeInsets.all(16),
      );
    }
    return Scrollbar(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SelectableText(
          _content!,
          style: TextStyle(
            fontFamily: isPro ? settings.fontFamily : 'monospace',
            fontSize: isPro ? settings.fontSize : 14.0,
            height: 1.6,
          ),
        ),
      ),
    );
  }

  void _showTextOptions(BuildContext context, SettingsNotifier settings) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => _TextOptionsSheet(settings: settings),
    );
  }
}

class _TextOptionsSheet extends StatelessWidget {
  const _TextOptionsSheet({required this.settings});
  final SettingsNotifier settings;

  static const List<String> _fonts = [
    'Inter',
    'monospace',
    'serif',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Text Options',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            Text('Font size: ${settings.fontSize.toInt()}px',
                style: Theme.of(context).textTheme.bodySmall),
            Slider(
              value: settings.fontSize,
              min: 10,
              max: 26,
              divisions: 8,
              onChanged: (v) => settings.setFontSize(v),
            ),
            const SizedBox(height: 8),
            Text('Font family',
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _fonts.map((f) {
                final bool selected = settings.fontFamily == f;
                return ChoiceChip(
                  label: Text(f),
                  selected: selected,
                  onSelected: (_) => settings.setFontFamily(f),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
