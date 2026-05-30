import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';

import '../../models/bookmark.dart';
import '../../models/document_file.dart';
import '../../models/file_type.dart';
import '../../state/bookmarks_notifier.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: Consumer<BookmarksNotifier>(
        builder: (context, notifier, _) {
          if (notifier.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (notifier.bookmarks.isEmpty) {
            return _EmptyState();
          }
          return _BookmarkList(bookmarks: notifier.bookmarks);
        },
      ),
    );
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
          Icon(Icons.bookmarks_outlined, size: 72, color: color),
          const SizedBox(height: 16),
          Text(
            'No bookmarks yet',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: color, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Open a PDF and tap the bookmark icon to save a page',
            textAlign: TextAlign.center,
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

class _BookmarkList extends StatelessWidget {
  const _BookmarkList({required this.bookmarks});
  final List<Bookmark> bookmarks;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
      itemCount: bookmarks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return _BookmarkTile(bookmark: bookmarks[index]);
      },
    );
  }
}

class _BookmarkTile extends StatelessWidget {
  const _BookmarkTile({required this.bookmark});
  final Bookmark bookmark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: Icon(
          Icons.bookmark,
          color: theme.colorScheme.primary,
        ),
        title: Text(
          bookmark.fileName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(bookmark.label),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          tooltip: 'Remove bookmark',
          onPressed: () =>
              context.read<BookmarksNotifier>().remove(bookmark.id),
        ),
        onTap: () => _openFile(context),
      ),
    );
  }

  void _openFile(BuildContext context) {
    final DocumentFile file = DocumentFile(
      path: bookmark.filePath,
      name: bookmark.fileName,
      sizeBytes: 0,
      type: FileTypeHelper.fromPath(bookmark.filePath),
      mimeType:
          lookupMimeType(bookmark.filePath) ?? 'application/octet-stream',
      lastOpened: DateTime.now(),
    );
    context.push('/viewer', extra: file);
  }
}
