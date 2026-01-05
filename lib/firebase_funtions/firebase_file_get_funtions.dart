import 'package:content_managing_app/models/uploaded_media_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FirebaseFileGetFunction {
  FirebaseFileGetFunction._();
  static final instance = FirebaseFileGetFunction._();

  final DatabaseReference _db = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://content-review-bbd55-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref();

  // ==============================
  // GLOBAL FEED (ALL USERS)
  // ==============================
  Future<List<UploadedMedia>> getGlobalFeed() async {
    try {
      final snapshot =
          await _db.child('uploads').orderByChild('uploadedAt').get();

      if (!snapshot.exists || snapshot.value == null) {
        return [];
      }

      final raw = snapshot.value as Map<dynamic, dynamic>;
      final List<UploadedMedia> list = [];

      raw.forEach((key, value) {
        if (value is Map<dynamic, dynamic>) {
          list.add(UploadedMedia.fromMap(key, value));
        }
      });

      // Newest first (Instagram-style)
      list.sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));

      return list;
    } catch (e, st) {
      debugPrint('Global feed error: $e');
      debugPrintStack(stackTrace: st);
      return [];
    }
  }

  // ==============================
  // REALTIME GLOBAL FEED
  // ==============================
  Stream<List<UploadedMedia>> streamGlobalFeed() {
    return _db
        .child('uploads')
        .orderByChild('uploadedAt')
        .onValue
        .map((event) {
      if (event.snapshot.value == null) return [];

      final raw = event.snapshot.value as Map<dynamic, dynamic>;
      final List<UploadedMedia> list = [];

      raw.forEach((key, value) {
        if (value is Map<dynamic, dynamic>) {
          list.add(UploadedMedia.fromMap(key, value));
        }
      });

      list.sort((a, b) => b.uploadedAt.compareTo(a.uploadedAt));
      return list;
    });
  }

  // ==============================
  // FILTER BY USER (PROFILE PAGE)
  // ==============================
  Future<List<UploadedMedia>> getUserPosts(String userId) async {
    final all = await getGlobalFeed();
    return all.where((e) => e.userId == userId).toList();
  }
}
