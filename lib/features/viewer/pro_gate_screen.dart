import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/document_file.dart';
import '../../state/pro_notifier.dart';

class ProGateScreen extends StatelessWidget {
  const ProGateScreen({super.key, required this.file});
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.onSurface),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'PRO',
                style: theme.textTheme.labelMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Pro Feature',
              style: theme.textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Text(
              'Opening ${file.extension} files is available in the Pro plan.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => context.push('/pro'),
                child: const Text('Upgrade to Pro — \$0.99'),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.read<ProNotifier>().restore(),
              child: const Text('Restore purchase'),
            ),
          ],
        ),
      ),
    );
  }
}
