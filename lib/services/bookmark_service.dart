import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants.dart';
import '../models/bookmark.dart';

class BookmarkService {
  Future<List<Bookmark>> loadAll() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(AppConstants.bookmarksKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      return Bookmark.listFromJson(raw);
    } catch (_) {
      return [];
    }
  }

  Future<void> add(Bookmark bookmark) async {
    final List<Bookmark> all = await loadAll();
    all.removeWhere((b) => b.id == bookmark.id);
    all.insert(0, bookmark);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.bookmarksKey, Bookmark.listToJson(all));
  }

  Future<void> remove(String id) async {
    final List<Bookmark> all = await loadAll();
    all.removeWhere((b) => b.id == id);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.bookmarksKey, Bookmark.listToJson(all));
  }

  Future<void> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.bookmarksKey);
  }
}
