import 'package:flutter_test/flutter_test.dart';

import 'package:all_in_one_document_reader_2026/models/file_type.dart';

void main() {
  group('FileTypeHelper.fromPath', () {
    test('detects PDF', () {
      expect(FileTypeHelper.fromPath('/docs/report.pdf'), FileType.pdf);
    });

    test('detects JPEG image', () {
      expect(FileTypeHelper.fromPath('/photos/photo.jpg'), FileType.image);
    });

    test('detects PNG image', () {
      expect(FileTypeHelper.fromPath('/photos/image.PNG'), FileType.image);
    });

    test('detects plain text', () {
      expect(FileTypeHelper.fromPath('/notes/readme.txt'), FileType.text);
    });

    test('detects markdown', () {
      expect(FileTypeHelper.fromPath('/docs/README.md'), FileType.text);
    });

    test('detects JSON', () {
      expect(FileTypeHelper.fromPath('/data/config.json'), FileType.text);
    });

    test('detects DOCX as office', () {
      expect(FileTypeHelper.fromPath('/docs/resume.docx'), FileType.office);
    });

    test('detects XLSX as office', () {
      expect(FileTypeHelper.fromPath('/sheets/budget.xlsx'), FileType.office);
    });

    test('detects PPTX as office', () {
      expect(FileTypeHelper.fromPath('/slides/demo.pptx'), FileType.office);
    });

    test('detects EPUB', () {
      expect(FileTypeHelper.fromPath('/books/novel.epub'), FileType.epub);
    });

    test('detects Kindle as unknown', () {
      expect(FileTypeHelper.fromPath('/books/ebook.mobi'), FileType.unknown);
    });

    test('detects unknown extension as unknown', () {
      expect(FileTypeHelper.fromPath('/files/archive.xyz123'), FileType.unknown);
    });

    test('handles path with no extension', () {
      expect(FileTypeHelper.fromPath('/files/Makefile'), FileType.unknown);
    });
  });

  group('FileTypeHelper.label', () {
    test('returns PDF for pdf type', () {
      expect(FileTypeHelper.label(FileType.pdf), 'PDF');
    });

    test('returns EPUB for epub type', () {
      expect(FileTypeHelper.label(FileType.epub), 'EPUB');
    });
  });
}
