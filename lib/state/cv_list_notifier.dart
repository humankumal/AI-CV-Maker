import 'package:flutter/foundation.dart';

import '../models/cv_document.dart';
import '../services/cv_repository.dart';

class CvListNotifier extends ChangeNotifier {
  CvListNotifier(this._repo);

  final CvRepository _repo;
  List<CvDocument> _cvs = <CvDocument>[];
  bool _loading = false;

  List<CvDocument> get cvs => List<CvDocument>.unmodifiable(_cvs);
  bool get loading => _loading;
  bool get isEmpty => !_loading && _cvs.isEmpty;

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    _cvs = await _repo.loadAll();
    _loading = false;
    notifyListeners();
  }

  Future<void> upsert(CvDocument doc) async {
    await _repo.save(doc);
    final int i = _cvs.indexWhere((CvDocument c) => c.id == doc.id);
    if (i >= 0) {
      _cvs[i] = doc;
    } else {
      _cvs.insert(0, doc);
    }
    _cvs.sort((CvDocument a, CvDocument b) =>
        b.updatedAt.compareTo(a.updatedAt));
    notifyListeners();
  }

  Future<void> rename(String id, String newName) async {
    final int i = _cvs.indexWhere((CvDocument c) => c.id == id);
    if (i < 0) return;
    final CvDocument updated = _cvs[i].copyWith(name: newName);
    await upsert(updated);
  }

  Future<CvDocument> duplicate(String id) async {
    final CvDocument original = _cvs.firstWhere((CvDocument c) => c.id == id);
    final CvDocument copy = CvDocument(
      name: '${original.name} (copy)',
      countryCode: original.countryCode,
      templateId: original.templateId,
      profile: original.profile,
      experience: original.experience,
      education: original.education,
      skills: original.skills,
      projects: original.projects,
      certifications: original.certifications,
      languages: original.languages,
      references: original.references,
    );
    await upsert(copy);
    return copy;
  }

  Future<void> remove(String id) async {
    await _repo.delete(id);
    _cvs.removeWhere((CvDocument c) => c.id == id);
    notifyListeners();
  }

  CvDocument? find(String id) {
    try {
      return _cvs.firstWhere((CvDocument c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
