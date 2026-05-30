import 'package:flutter/foundation.dart';

import '../models/bookmark.dart';
import '../services/bookmark_service.dart';

class BookmarksNotifier extends ChangeNotifier {
  BookmarksNotifier(this._service);

  final BookmarkService _service;

  List<Bookmark> _bookmarks = [];
  bool _loading = false;

  List<Bookmark> get bookmarks => _bookmarks;
  bool get loading => _loading;

  bool isBookmarked(String filePath, int page) =>
      _bookmarks.any((b) => b.filePath == filePath && b.page == page);

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    _bookmarks = await _service.loadAll();
    _loading = false;
    notifyListeners();
  }

  Future<void> add(Bookmark bookmark) async {
    await _service.add(bookmark);
    await load();
  }

  Future<void> remove(String id) async {
    await _service.remove(id);
    await load();
  }

  Future<void> clear() async {
    await _service.clear();
    _bookmarks = [];
    notifyListeners();
  }

  Future<void> toggle({
    required String filePath,
    required String fileName,
    required int page,
  }) async {
    final String id = '${filePath.hashCode.toRadixString(16)}_p$page';
    if (isBookmarked(filePath, page)) {
      await remove(id);
    } else {
      await add(Bookmark(
        id: id,
        filePath: filePath,
        fileName: fileName,
        page: page,
        label: 'Page $page',
        createdAt: DateTime.now(),
      ));
    }
  }
}
