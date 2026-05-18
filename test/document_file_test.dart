import 'package:flutter_test/flutter_test.dart';

import 'package:all_in_one_document_reader_2026/models/document_file.dart';
import 'package:all_in_one_document_reader_2026/models/file_type.dart';

DocumentFile _sample() => DocumentFile(
      path: '/docs/report.pdf',
      name: 'report.pdf',
      sizeBytes: 1024 * 1024 * 2, // 2 MB
      type: FileType.pdf,
      mimeType: 'application/pdf',
      lastOpened: DateTime(2026, 5, 1, 10, 0),
    );

void main() {
  group('DocumentFile', () {
    test('formattedSize returns KB for small files', () {
      final f = _sample().copyWith(sizeBytes: 512 * 1024);
      expect(f.formattedSize, '512.0 KB');
    });

    test('formattedSize returns MB for large files', () {
      expect(_sample().formattedSize, '2.0 MB');
    });

    test('extension returns uppercase extension', () {
      expect(_sample().extension, 'PDF');
    });

    test('extension returns FILE for no extension', () {
      final f = _sample().copyWith(name: 'Makefile', path: '/Makefile');
      expect(f.extension, 'FILE');
    });

    test('JSON round-trip preserves all fields', () {
      final original = _sample();
      final json = original.toJson();
      final restored = DocumentFile.fromJson(json);
      expect(restored.path, original.path);
      expect(restored.name, original.name);
      expect(restored.sizeBytes, original.sizeBytes);
      expect(restored.type, original.type);
      expect(restored.mimeType, original.mimeType);
      expect(restored.lastOpened.toIso8601String(),
          original.lastOpened.toIso8601String());
    });

    test('listToJson / listFromJson round-trip', () {
      final files = [_sample(), _sample().copyWith(name: 'other.txt')];
      final json = DocumentFile.listToJson(files);
      final restored = DocumentFile.listFromJson(json);
      expect(restored.length, 2);
      expect(restored[0].name, 'report.pdf');
      expect(restored[1].name, 'other.txt');
    });

    test('unknown type preserved through JSON', () {
      final f = _sample().copyWith(type: FileType.unknown);
      final restored = DocumentFile.fromJson(f.toJson());
      expect(restored.type, FileType.unknown);
    });
  });
}
