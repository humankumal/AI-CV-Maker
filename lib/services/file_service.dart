import 'dart:io';

import 'package:file_picker/file_picker.dart' as fp;
import 'package:mime/mime.dart';

import '../models/document_file.dart';
import '../models/file_type.dart';

class FileService {
  /// Opens the OS file picker and returns a DocumentFile, or null if cancelled.
  Future<DocumentFile?> pickFile() async {
    final fp.FilePickerResult? result = await fp.FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: fp.FileType.any,
      withData: false,
    );
    if (result == null || result.files.isEmpty) return null;
    final fp.PlatformFile pf = result.files.first;
    final String? path = pf.path;
    if (path == null) return null;
    return _build(path, pf.name, pf.size);
  }

  /// Creates a DocumentFile from a file path (e.g. received via intent).
  Future<DocumentFile?> fromPath(String path) async {
    final File file = File(path);
    if (!file.existsSync()) return null;
    final String name = path.split(Platform.pathSeparator).last;
    final int size = file.lengthSync();
    return _build(path, name, size);
  }

  DocumentFile _build(String path, String name, int size) {
    final String mime = lookupMimeType(path) ??
        lookupMimeType(name) ??
        'application/octet-stream';
    final FileType type = FileTypeHelper.fromPath(path);
    return DocumentFile(
      path: path,
      name: name,
      sizeBytes: size,
      type: type,
      mimeType: mime,
      lastOpened: DateTime.now(),
    );
  }
}
