import 'package:flutter/foundation.dart';

import '../models/document_file.dart';
import '../services/iap_service.dart';
import '../services/recent_files_service.dart';

class RecentFilesNotifier extends ChangeNotifier {
  RecentFilesNotifier(this._service, this._iap);

  final RecentFilesService _service;
  final IapService _iap;

  List<DocumentFile> _files = [];
  bool _loading = false;

  List<DocumentFile> get files => _files;
  bool get loading => _loading;

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    _files = await _service.loadAll();
    _loading = false;
    notifyListeners();
  }

  Future<void> addFile(DocumentFile file) async {
    await _service.add(file, isPro: _iap.isPro);
    await load();
  }

  Future<void> remove(String path) async {
    await _service.remove(path);
    await load();
  }

  Future<void> clear() async {
    await _service.clear();
    _files = [];
    notifyListeners();
  }

}
