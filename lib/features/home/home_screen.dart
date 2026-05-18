import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../models/document_file.dart';
import '../../services/file_service.dart';
import '../../state/pro_notifier.dart';
import '../../state/recent_files_notifier.dart';
import 'widgets/recent_file_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Document Reader 2026',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: Consumer<RecentFilesNotifier>(
        builder: (context, notifier, _) {
          if (notifier.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (notifier.files.isEmpty) {
            return _EmptyState();
          }
          return _FileList(files: notifier.files);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openFile(context),
        icon: const Icon(Icons.folder_open_outlined),
        label: const Text('Open File'),
      ),
      bottomNavigationBar: Consumer<ProNotifier>(
        builder: (context, pro, _) {
          if (pro.isPro) return const SizedBox.shrink();
          return _ProBanner();
        },
      ),
    );
  }

  Future<void> _openFile(BuildContext context) async {
    final FileService service = context.read<FileService>();
    DocumentFile? file;
    try {
      file = await service.pickFile();
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open file picker.')),
        );
      }
      return;
    }
    if (file == null) return;
    if (context.mounted) {
      context.push('/viewer', extra: file);
    }
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.description_outlined, size: 72, color: color),
          const SizedBox(height: 16),
          Text(
            'No files opened yet',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: color, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap "Open File" to browse your device',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _FileList extends StatelessWidget {
  const _FileList({required this.files});
  final List<DocumentFile> files;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
      itemCount: files.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return RecentFileCard(file: files[index]);
      },
    );
  }
}

class _ProBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<RecentFilesNotifier>(
      builder: (context, notifier, _) {
        final bool atLimit = notifier.files.length >= 5;
        if (!atLimit) return const SizedBox.shrink();
        return Container(
          color: theme.colorScheme.surface,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Upgrade Pro for unlimited history',
                      style: theme.textTheme.bodySmall
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: () => context.push('/pro'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                    child: const Text('\$0.99'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
