import 'dart:async';

import '../models/cv_document.dart';
import 'cv_repository.dart';
import 'remote_cv_repository.dart';

/// Coordinates local-first storage with an optional remote backend.
///
/// Rules:
/// - Reads always come from the local repository.
/// - Writes go to local first, then opportunistically to remote (best-effort).
/// - On `syncNow`, we merge local + remote by `updatedAt` (last write wins).
class SyncOrchestrator {
  SyncOrchestrator({
    required CvRepository local,
    required RemoteCvRepository remote,
  })  : _local = local,
        _remote = remote;

  final CvRepository _local;
  final RemoteCvRepository _remote;

  bool get isSignedIn => _remote.currentUserId != null;
  Stream<String?> get authStream => _remote.watchAuthState();

  Future<void> upsert(CvDocument doc) async {
    await _local.save(doc);
    if (isSignedIn) {
      // Best-effort — never block the UI on cloud writes.
      unawaited(_safe(() => _remote.upsert(doc)));
    }
  }

  Future<void> delete(String id) async {
    await _local.delete(id);
    if (isSignedIn) {
      unawaited(_safe(() => _remote.delete(id)));
    }
  }

  Future<List<CvDocument>> loadAll() => _local.loadAll();

  /// Pull-then-push merge. Returns the resulting merged list.
  Future<List<CvDocument>> syncNow() async {
    final List<CvDocument> localList = await _local.loadAll();
    if (!isSignedIn) return localList;

    final List<CvDocument> remoteList = await _remote.fetchAll();

    final Map<String, CvDocument> merged = <String, CvDocument>{};
    for (final CvDocument d in localList) {
      merged[d.id] = d;
    }
    for (final CvDocument r in remoteList) {
      final CvDocument? existing = merged[r.id];
      if (existing == null || r.updatedAt.isAfter(existing.updatedAt)) {
        merged[r.id] = r;
        // Remote is newer than local — overwrite local.
        if (existing == null || r.updatedAt.isAfter(existing.updatedAt)) {
          await _local.save(r);
        }
      } else if (existing.updatedAt.isAfter(r.updatedAt)) {
        // Local is newer than remote — push it back up.
        await _safe(() => _remote.upsert(existing));
      }
    }
    // Push purely-local docs to remote.
    for (final CvDocument d in localList) {
      final bool inRemote = remoteList.any((CvDocument r) => r.id == d.id);
      if (!inRemote) await _safe(() => _remote.upsert(d));
    }
    return merged.values.toList()
      ..sort((CvDocument a, CvDocument b) =>
          b.updatedAt.compareTo(a.updatedAt));
  }

  Future<String> signInAnonymously() => _remote.signInAnonymously();
  Future<void> signOut() => _remote.signOut();

  Future<void> _safe(Future<void> Function() op) async {
    try {
      await op();
    } catch (_) {
      // Swallow remote errors — local is the source of truth.
    }
  }
}
