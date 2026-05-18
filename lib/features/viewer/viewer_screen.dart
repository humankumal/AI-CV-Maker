import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/document_file.dart';
import '../../models/file_type.dart';
import '../../state/pro_notifier.dart';
import '../../state/recent_files_notifier.dart';
import 'epub_viewer.dart';
import 'image_viewer.dart';
import 'office_viewer.dart';
import 'pdf_viewer.dart';
import 'pro_gate_screen.dart';
import 'text_viewer.dart';
import 'unknown_viewer.dart';

class ViewerScreen extends StatefulWidget {
  const ViewerScreen({super.key, required this.file});
  final DocumentFile file;

  @override
  State<ViewerScreen> createState() => _ViewerScreenState();
}

class _ViewerScreenState extends State<ViewerScreen> {
  @override
  void initState() {
    super.initState();
    // Register file in recents on first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<RecentFilesNotifier>().addFile(widget.file);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isPro = context.watch<ProNotifier>().isPro;

    return switch (widget.file.type) {
      FileType.pdf => PdfViewer(file: widget.file),
      FileType.image => ImageViewer(file: widget.file),
      FileType.text => TextViewer(file: widget.file),
      FileType.office => isPro
          ? OfficeViewer(file: widget.file)
          : ProGateScreen(file: widget.file),
      FileType.epub => isPro
          ? EpubViewer(file: widget.file)
          : ProGateScreen(file: widget.file),
      FileType.unknown => UnknownViewer(file: widget.file),
    };
  }
}
