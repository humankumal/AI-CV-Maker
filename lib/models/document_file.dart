import 'dart:convert';

import 'file_type.dart';

class DocumentFile {
  const DocumentFile({
    required this.path,
    required this.name,
    required this.sizeBytes,
    required this.type,
    required this.mimeType,
    required this.lastOpened,
  });

  final String path;
  final String name;
  final int sizeBytes;
  final FileType type;
  final String mimeType;
  final DateTime lastOpened;

  String get extension {
    if (!name.contains('.')) return 'FILE';
    return name.split('.').last.toUpperCase();
  }

  String get formattedSize {
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1024 * 1024) {
      return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    }
    if (sizeBytes < 1024 * 1024 * 1024) {
      return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(sizeBytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  DocumentFile copyWith({
    String? path,
    String? name,
    int? sizeBytes,
    FileType? type,
    String? mimeType,
    DateTime? lastOpened,
  }) {
    return DocumentFile(
      path: path ?? this.path,
      name: name ?? this.name,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      type: type ?? this.type,
      mimeType: mimeType ?? this.mimeType,
      lastOpened: lastOpened ?? this.lastOpened,
    );
  }

  Map<String, dynamic> toJson() => {
        'path': path,
        'name': name,
        'sizeBytes': sizeBytes,
        'type': type.name,
        'mimeType': mimeType,
        'lastOpened': lastOpened.toIso8601String(),
      };

  factory DocumentFile.fromJson(Map<String, dynamic> json) {
    return DocumentFile(
      path: json['path'] as String,
      name: json['name'] as String,
      sizeBytes: (json['sizeBytes'] as num).toInt(),
      type: FileType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => FileType.unknown,
      ),
      mimeType: json['mimeType'] as String? ?? 'application/octet-stream',
      lastOpened: DateTime.parse(json['lastOpened'] as String),
    );
  }

  static List<DocumentFile> listFromJson(String raw) {
    final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
    return list
        .whereType<Map<String, dynamic>>()
        .map(DocumentFile.fromJson)
        .toList();
  }

  static String listToJson(List<DocumentFile> files) {
    return jsonEncode(files.map((f) => f.toJson()).toList());
  }
}
