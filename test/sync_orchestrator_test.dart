import 'package:ai_cv_maker/models/cv_document.dart';
import 'package:ai_cv_maker/services/cv_repository.dart';
import 'package:ai_cv_maker/services/remote_cv_repository.dart';
import 'package:ai_cv_maker/services/sync_orchestrator.dart';
import 'package:flutter_test/flutter_test.dart';

class _InMemoryLocal implements CvRepository {
  final Map<String, CvDocument> _store = <String, CvDocument>{};

  @override
  Future<List<CvDocument>> loadAll() async => _store.values.toList();

  @override
  Future<void> save(CvDocument doc) async => _store[doc.id] = doc;

  @override
  Future<void> delete(String id) async => _store.remove(id);
}

void main() {
  group('SyncOrchestrator', () {
    late _InMemoryLocal local;
    late InMemoryRemoteRepository remote;
    late SyncOrchestrator sync;

    setUp(() {
      local = _InMemoryLocal();
      remote = InMemoryRemoteRepository();
      sync = SyncOrchestrator(local: local, remote: remote);
    });

    test('writes go to local only when signed out', () async {
      await sync.upsert(_doc('a', updated: DateTime(2026, 1, 1)));
      expect((await local.loadAll()).length, 1);
      expect((await remote.fetchAll()).length, 0);
    });

    test('syncNow uploads local-only docs after sign in', () async {
      await sync.upsert(_doc('a', updated: DateTime(2026, 1, 1)));
      await sync.signInAnonymously();
      await sync.syncNow();
      expect((await remote.fetchAll()).length, 1);
    });

    test('remote-newer overwrites local', () async {
      await sync.signInAnonymously();
      await local.save(_doc('a',
          name: 'Local', updated: DateTime(2026, 1, 1)));
      await remote.upsert(_doc('a',
          name: 'Remote', updated: DateTime(2026, 5, 1)));
      await sync.syncNow();
      final List<CvDocument> after = await local.loadAll();
      expect(after.single.name, 'Remote');
    });

    test('local-newer pushes back to remote', () async {
      await sync.signInAnonymously();
      await local.save(_doc('a',
          name: 'Local', updated: DateTime(2026, 6, 1)));
      await remote.upsert(_doc('a',
          name: 'Remote', updated: DateTime(2026, 1, 1)));
      await sync.syncNow();
      final List<CvDocument> after = await remote.fetchAll();
      expect(after.single.name, 'Local');
    });

    test('sign out clears the user id', () async {
      await sync.signInAnonymously();
      expect(sync.isSignedIn, true);
      await sync.signOut();
      expect(sync.isSignedIn, false);
    });
  });
}

CvDocument _doc(String id,
    {String name = 'Test', required DateTime updated}) {
  return CvDocument(
    id: id,
    name: name,
    countryCode: 'GB',
    templateId: 'GB-01',
    updatedAt: updated,
  );
}
