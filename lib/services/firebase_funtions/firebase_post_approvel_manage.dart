import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class PostApprovalManager {
  PostApprovalManager._();
  static final instance = PostApprovalManager._();

  final DatabaseReference _db =
      FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL:
            'https://content-review-bbd55-default-rtdb.asia-southeast1.firebasedatabase.app',
      ).ref();

  Future<void> approvePost({required String postId}) async {
    try {
      await _db.child('uploads').child(postId).update({
        'isApproved': true,
        // 'status': 'approved', // optional but recommended
      });
    } catch (e, st) {
      debugPrint('🔥 Approve post failed: $e');
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }
}
