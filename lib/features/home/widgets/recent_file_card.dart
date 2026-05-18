import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../models/document_file.dart';
import '../../../state/recent_files_notifier.dart';
import 'file_type_icon.dart';

class RecentFileCard extends StatelessWidget {
  const RecentFileCard({super.key, required this.file});
  final DocumentFile file;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => context.push('/viewer', extra: file),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              FileTypeIcon(type: file.type, extension: file.extension),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      file.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${file.formattedSize} · ${_relativeTime(file.lastOpened)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _MoreMenu(file: file),
            ],
          ),
        ),
      ),
    );
  }

  String _relativeTime(DateTime dt) {
    final Duration diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

class _MoreMenu extends StatelessWidget {
  const _MoreMenu({required this.file});
  final DocumentFile file;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: 18),
      onSelected: (value) async {
        if (value == 'open') {
          context.push('/viewer', extra: file);
        } else if (value == 'remove') {
          await context.read<RecentFilesNotifier>().remove(file.path);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'open', child: Text('Open')),
        const PopupMenuItem(
          value: 'remove',
          child: Text('Remove from recents'),
        ),
      ],
    );
  }
}
