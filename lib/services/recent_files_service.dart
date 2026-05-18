import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants.dart';
import '../models/document_file.dart';

class RecentFilesService {
  Future<List<DocumentFile>> loadAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(AppConstants.recentFilesKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      return DocumentFile.listFromJson(raw);
    } catch (_) {
      return [];
    }
  }

  Future<void> add(DocumentFile file, {bool isPro = false}) async {
    final List<DocumentFile> all = await loadAll();
    all.removeWhere((f) => f.path == file.path);
    all.insert(0, file);
    final int limit =
        isPro ? 10000 : AppConstants.freeRecentFilesLimit;
    final List<DocumentFile> trimmed = all.take(limit).toList();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        AppConstants.recentFilesKey, DocumentFile.listToJson(trimmed));
  }

  Future<void> remove(String path) async {
    final List<DocumentFile> all = await loadAll();
    all.removeWhere((f) => f.path == path);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        AppConstants.recentFilesKey, DocumentFile.listToJson(all));
  }

  Future<void> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.recentFilesKey);
  }
}
