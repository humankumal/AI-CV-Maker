import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';

import '../../models/document_file.dart';

class OfficeViewer extends StatelessWidget {
  const OfficeViewer({super.key, required this.file});
  final DocumentFile file;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(file.name, overflow: TextOverflow.ellipsis),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.table_chart_outlined,
              size: 80,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 20),
            Text(
              file.name,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              '${file.formattedSize} · ${file.extension}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => _openWithNativeApp(context),
                icon: const Icon(Icons.open_in_new),
                label: const Text('Open with device app'),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'In-app Office viewing is not available for local files.\n'
              'Open with Microsoft Word, Google Docs, or another compatible app on your device.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openWithNativeApp(BuildContext context) async {
    final result = await OpenFilex.open(file.path);
    if (result.type != ResultType.done && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No compatible app found: ${result.message}')),
      );
    }
  }
}
