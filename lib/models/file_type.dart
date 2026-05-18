import 'package:mime/mime.dart';

enum FileType { pdf, image, text, office, epub, unknown }

class FileTypeHelper {
  FileTypeHelper._();

  static const Set<String> _officeMimes = {
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    'application/msword',
    'application/vnd.ms-excel',
    'application/vnd.ms-powerpoint',
  };

  static const Set<String> _textMimes = {
    'text/plain',
    'text/csv',
    'text/html',
    'text/xml',
    'text/markdown',
    'application/json',
    'application/xml',
    'application/yaml',
    'application/x-yaml',
  };

  static const Set<String> _officeExts = {
    'docx', 'doc', 'xlsx', 'xls', 'pptx', 'ppt', 'odt', 'ods', 'odp',
  };

  static const Set<String> _textExts = {
    'txt', 'csv', 'json', 'xml', 'html', 'htm', 'md', 'markdown',
    'yaml', 'yml', 'log', 'ini', 'cfg', 'conf', 'toml', 'rs', 'py',
    'js', 'ts', 'dart', 'java', 'kt', 'swift', 'go', 'rb', 'php', 'c',
    'cpp', 'h', 'css', 'scss', 'sh', 'bash', 'sql',
  };

  static const Set<String> _imageExts = {
    'jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'tiff', 'tif', 'heic', 'heif',
  };

  static FileType fromPath(String path) {
    final String lower = path.toLowerCase();
    final String ext = lower.contains('.') ? lower.split('.').last : '';

    // EPUB
    if (ext == 'epub') return FileType.epub;
    if (ext == 'mobi' || ext == 'azw' || ext == 'azw3') return FileType.unknown;

    // PDF
    if (ext == 'pdf') return FileType.pdf;

    // Extension-based lookup first (more reliable than MIME for office docs)
    if (_officeExts.contains(ext)) return FileType.office;
    if (_textExts.contains(ext)) return FileType.text;
    if (_imageExts.contains(ext)) return FileType.image;

    // MIME fallback
    final String? mime = lookupMimeType(path);
    if (mime == null) return FileType.unknown;
    if (mime == 'application/pdf') return FileType.pdf;
    if (mime.startsWith('image/')) return FileType.image;
    if (_officeMimes.contains(mime)) return FileType.office;
    if (_textMimes.contains(mime) || mime.startsWith('text/')) return FileType.text;

    return FileType.unknown;
  }

  static String label(FileType type) {
    return switch (type) {
      FileType.pdf => 'PDF',
      FileType.image => 'IMG',
      FileType.text => 'TXT',
      FileType.office => 'DOC',
      FileType.epub => 'EPUB',
      FileType.unknown => 'FILE',
    };
  }
}
