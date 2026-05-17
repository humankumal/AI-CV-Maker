// Firebase implementation skeleton for [RemoteCvRepository].
//
// This file intentionally contains only documentation + reference code as
// triple-quoted Dart raw strings. It does NOT import firebase_core, so the
// default project builds without a Firebase configuration. Once your project
// is wired up (see steps below) replace this file with an active
// implementation, or copy the snippet into a sibling file and add it as a
// dependency in `app.dart`.
//
// ─────────────────────────────────────────────────────────────────────────
// ACTIVATION STEPS
// ─────────────────────────────────────────────────────────────────────────
//
// 1. Install the FlutterFire CLI:
//      dart pub global activate flutterfire_cli
//
// 2. Run the configurator from the project root. This creates
//    `lib/firebase_options.dart` and writes platform config files
//    (`google-services.json`, `GoogleService-Info.plist`):
//      flutterfire configure
//
// 3. Add Firebase packages to pubspec.yaml:
//      firebase_core: ^3.6.0
//      firebase_auth: ^5.3.0
//      cloud_firestore: ^5.4.0
//
// 4. Initialise Firebase in `lib/main.dart` before `runApp(...)`:
//      WidgetsFlutterBinding.ensureInitialized();
//      await Firebase.initializeApp(
//        options: DefaultFirebaseOptions.currentPlatform,
//      );
//
// 5. In `lib/app.dart` swap the default `InMemoryRemoteRepository()` for
//    `FirebaseRemoteRepository()`.
//
// ─────────────────────────────────────────────────────────────────────────
// REFERENCE IMPLEMENTATION — copy into a new file and uncomment.
// ─────────────────────────────────────────────────────────────────────────

const String firebaseRemoteRepositoryReference = r'''
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/cv_document.dart';
import 'remote_cv_repository.dart';

class FirebaseRemoteRepository implements RemoteCvRepository {
  FirebaseRemoteRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  @override
  String? get currentUserId => _auth.currentUser?.uid;

  @override
  Stream<String?> watchAuthState() =>
      _auth.authStateChanges().map((User? u) => u?.uid);

  @override
  Future<String> signInAnonymously() async {
    final UserCredential cred = await _auth.signInAnonymously();
    return cred.user!.uid;
  }

  @override
  Future<void> signOut() => _auth.signOut();

  CollectionReference<Map<String, dynamic>> _userCvs(String uid) =>
      _firestore.collection("users").doc(uid).collection("cvs");

  @override
  Future<List<CvDocument>> fetchAll() async {
    final String? uid = currentUserId;
    if (uid == null) return <CvDocument>[];
    final QuerySnapshot<Map<String, dynamic>> snap = await _userCvs(uid).get();
    return snap.docs
        .map((QueryDocumentSnapshot<Map<String, dynamic>> d) =>
            CvDocument.fromJson(d.data()))
        .toList();
  }

  @override
  Future<void> upsert(CvDocument doc) async {
    final String? uid = currentUserId;
    if (uid == null) return;
    await _userCvs(uid).doc(doc.id).set(doc.toJson());
  }

  @override
  Future<void> delete(String id) async {
    final String? uid = currentUserId;
    if (uid == null) return;
    await _userCvs(uid).doc(id).delete();
  }
}
''';
