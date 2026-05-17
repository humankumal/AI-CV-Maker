import 'dart:async';

import 'package:flutter/foundation.dart';

import '../services/sync_orchestrator.dart';
import 'cv_list_notifier.dart';

/// Exposes sync state to the UI and triggers pulls when the user signs in.
class SyncNotifier extends ChangeNotifier {
  SyncNotifier({required this.orchestrator, required this.list}) {
    _authSub = orchestrator.authStream.listen(_onAuth);
  }

  final SyncOrchestrator orchestrator;
  final CvListNotifier list;
  StreamSubscription<String?>? _authSub;

  bool _syncing = false;
  String? _userId;
  DateTime? _lastSyncAt;
  String? _error;

  bool get isSignedIn => _userId != null;
  String? get userId => _userId;
  bool get syncing => _syncing;
  DateTime? get lastSyncAt => _lastSyncAt;
  String? get error => _error;

  Future<void> signInAndSync() async {
    _error = null;
    notifyListeners();
    try {
      await orchestrator.signInAnonymously();
      await syncNow();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await orchestrator.signOut();
  }

  Future<void> syncNow() async {
    _syncing = true;
    _error = null;
    notifyListeners();
    try {
      await orchestrator.syncNow();
      await list.load();
      _lastSyncAt = DateTime.now();
    } catch (e) {
      _error = e.toString();
    } finally {
      _syncing = false;
      notifyListeners();
    }
  }

  void _onAuth(String? uid) {
    _userId = uid;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
