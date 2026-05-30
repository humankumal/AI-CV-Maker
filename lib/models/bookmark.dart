import 'dart:convert';

class Bookmark {
  const Bookmark({
    required this.id,
    required this.filePath,
    required this.fileName,
    required this.page,
    required this.label,
    required this.createdAt,
  });

  final String id;
  final String filePath;
  final String fileName;
  final int page;
  final String label;
  final DateTime createdAt;

  Bookmark copyWith({
    String? id,
    String? filePath,
    String? fileName,
    int? page,
    String? label,
    DateTime? createdAt,
  }) {
    return Bookmark(
      id: id ?? this.id,
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
      page: page ?? this.page,
      label: label ?? this.label,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'filePath': filePath,
        'fileName': fileName,
        'page': page,
        'label': label,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: json['id'] as String,
      filePath: json['filePath'] as String,
      fileName: json['fileName'] as String,
      page: (json['page'] as num).toInt(),
      label: json['label'] as String? ?? 'Page ${json['page']}',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  static List<Bookmark> listFromJson(String raw) {
    final List<dynamic> list = jsonDecode(raw) as List<dynamic>;
    return list
        .whereType<Map<String, dynamic>>()
        .map(Bookmark.fromJson)
        .toList();
  }

  static String listToJson(List<Bookmark> items) {
    return jsonEncode(items.map((b) => b.toJson()).toList());
  }
}
