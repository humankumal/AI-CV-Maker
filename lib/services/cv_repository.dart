import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants.dart';
import '../models/cv_document.dart';

/// Storage interface for CV documents. On native platforms uses JSON files
/// in the app documents directory; on web falls back to SharedPreferences.
abstract class CvRepository {
  Future<List<CvDocument>> loadAll();
  Future<void> save(CvDocument doc);
  Future<void> delete(String id);

  static CvRepository create() {
    if (kIsWeb) return _PrefsCvRepository();
    return _FileCvRepository();
  }
}

class _FileCvRepository implements CvRepository {
  Future<Directory> _dir() async {
    final Directory base = await getApplicationDocumentsDirectory();
    final Directory dir =
        Directory('${base.path}/${AppConstants.cvsFolderName}');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  @override
  Future<List<CvDocument>> loadAll() async {
    final Directory dir = await _dir();
    final List<FileSystemEntity> entities = await dir.list().toList();
    final List<CvDocument> out = <CvDocument>[];
    for (final FileSystemEntity entity in entities) {
      if (entity is File && entity.path.endsWith('.json')) {
        try {
          final String raw = await entity.readAsString();
          final Map<String, dynamic> json =
              jsonDecode(raw) as Map<String, dynamic>;
          out.add(CvDocument.fromJson(json));
        } catch (_) {
          // ignore malformed file
        }
      }
    }
    out.sort((CvDocument a, CvDocument b) =>
        b.updatedAt.compareTo(a.updatedAt));
    return out;
  }

  @override
  Future<void> save(CvDocument doc) async {
    final Directory dir = await _dir();
    final File f = File('${dir.path}/${doc.id}.json');
    await f.writeAsString(jsonEncode(doc.toJson()));
  }

  @override
  Future<void> delete(String id) async {
    final Directory dir = await _dir();
    final File f = File('${dir.path}/$id.json');
    if (await f.exists()) {
      await f.delete();
    }
  }
}

class _PrefsCvRepository implements CvRepository {
  static const String _prefix = 'cv_doc_';

  @override
  Future<List<CvDocument>> loadAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<CvDocument> out = <CvDocument>[];
    for (final String key in prefs.getKeys()) {
      if (key.startsWith(_prefix)) {
        final String? raw = prefs.getString(key);
        if (raw == null) continue;
        try {
          out.add(CvDocument.fromJson(
              jsonDecode(raw) as Map<String, dynamic>));
        } catch (_) {/* skip */}
      }
    }
    out.sort((CvDocument a, CvDocument b) =>
        b.updatedAt.compareTo(a.updatedAt));
    return out;
  }

  @override
  Future<void> save(CvDocument doc) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_prefix${doc.id}', jsonEncode(doc.toJson()));
  }

  @override
  Future<void> delete(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_prefix$id');
  }
}
