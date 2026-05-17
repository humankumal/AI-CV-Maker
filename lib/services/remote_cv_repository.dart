import 'dart:async';

import '../models/cv_document.dart';

/// Remote backend interface used by [SyncOrchestrator]. Keeping the cloud
/// behind an interface lets us swap Firebase, Supabase, or a custom backend
/// without touching UI code.
///
/// The default implementation is [InMemoryRemoteRepository] which is useful
/// for tests and demos. To enable Firebase, follow the steps in
/// `lib/services/firebase_remote_repository.dart`.
abstract class RemoteCvRepository {
  /// A stable identifier for the currently signed-in user, or `null` if
  /// the user is signed out. The orchestrator skips syncing when null.
  String? get currentUserId;

  /// Stream of auth state changes — emits the user id (or null).
  Stream<String?> watchAuthState();

  /// Anonymous sign-in. Used as a low-friction first-time sync option.
  Future<String> signInAnonymously();

  Future<void> signOut();

  Future<List<CvDocument>> fetchAll();

  Future<void> upsert(CvDocument doc);

  Future<void> delete(String id);
}

/// In-memory implementation. Holds documents in a single instance — useful
/// for development, demos, and unit tests.
class InMemoryRemoteRepository implements RemoteCvRepository {
  final Map<String, CvDocument> _store = <String, CvDocument>{};
  String? _userId;
  final StreamController<String?> _authCtrl =
      StreamController<String?>.broadcast();

  @override
  String? get currentUserId => _userId;

  @override
  Stream<String?> watchAuthState() async* {
    yield _userId;
    yield* _authCtrl.stream;
  }

  @override
  Future<String> signInAnonymously() async {
    _userId = 'mock-user';
    _authCtrl.add(_userId);
    return _userId!;
  }

  @override
  Future<void> signOut() async {
    _userId = null;
    _authCtrl.add(null);
  }

  @override
  Future<List<CvDocument>> fetchAll() async {
    if (_userId == null) return <CvDocument>[];
    return _store.values.toList()
      ..sort((CvDocument a, CvDocument b) =>
          b.updatedAt.compareTo(a.updatedAt));
  }

  @override
  Future<void> upsert(CvDocument doc) async {
    if (_userId == null) return;
    _store[doc.id] = doc;
  }

  @override
  Future<void> delete(String id) async {
    if (_userId == null) return;
    _store.remove(id);
  }
}
