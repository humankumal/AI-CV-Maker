import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:provider/provider.dart';

import '../../models/document_file.dart';
import '../../state/bookmarks_notifier.dart';
import '../../state/pro_notifier.dart';

class PdfViewer extends StatefulWidget {
  const PdfViewer({super.key, required this.file});
  final DocumentFile file;

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  late PdfController _controller;
  int _currentPage = 1;
  int _totalPages = 0;

  @override
  void initState() {
    super.initState();
    _controller = PdfController(
      document: PdfDocument.openFile(widget.file.path),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isPro = context.watch<ProNotifier>().isPro;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.file.name,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          Consumer<BookmarksNotifier>(
            builder: (context, bookmarks, _) {
              final bool marked =
                  bookmarks.isBookmarked(widget.file.path, _currentPage);
              return IconButton(
                icon: Icon(marked ? Icons.bookmark : Icons.bookmark_outline),
                tooltip: marked ? 'Remove bookmark' : 'Bookmark page',
                onPressed: () => bookmarks.toggle(
                  filePath: widget.file.path,
                  fileName: widget.file.name,
                  page: _currentPage,
                ),
              );
            },
          ),
          if (_totalPages > 0)
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '$_currentPage / $_totalPages',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
        ],
      ),
      body: PdfView(
        controller: _controller,
        onDocumentLoaded: (document) {
          setState(() {
            _totalPages = document.pagesCount;
          });
        },
        onPageChanged: (page) {
          setState(() {
            _currentPage = page;
          });
        },
      ),
    );
  }
}
