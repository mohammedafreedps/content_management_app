import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class FirebaseCommentFunctions {
  FirebaseCommentFunctions._();
  static final instance = FirebaseCommentFunctions._();

  final DatabaseReference _db = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://content-review-bbd55-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref();

  // ==========================================================
  // POST COMMENT
  // ==========================================================
  Future<void> postComment({
    required String postId,
    required String userId,
    required String text,
    required String userName,
    required void Function() onSuccess,
    required void Function(String error) onError,
  }) async {
    try {
      final trimmedText = text.trim();

      if (trimmedText.isEmpty) {
        onError('Comment cannot be empty');
        return;
      }

      final commentData = {
        'text': trimmedText,
        'userId': userId,
        'userName' : userName,
        'createdAt': ServerValue.timestamp,
      };

      await _db
          .child('comments')
          .child(postId)
          .push()
          .set(commentData);

      onSuccess();
    } on FirebaseException catch (e, st) {
      debugPrint('🔥 Firebase comment error: ${e.message}');
      debugPrintStack(stackTrace: st);
      onError(e.message ?? 'Failed to post comment');
    } catch (e, st) {
      debugPrint('🔥 Unknown comment error: $e');
      debugPrintStack(stackTrace: st);
      onError('Something went wrong');
    }
  }

  // ==========================================================
  // DELETE COMMENT (NEW)
  // ==========================================================
  Future<void> deleteComment({
    required String postId,
    required String commentId,
    required void Function() onSuccess,
    required void Function(String error) onError,
  }) async {
    try {
      await _db
          .child('comments')
          .child(postId)
          .child(commentId)
          .remove();

      onSuccess();
    } on FirebaseException catch (e, st) {
      debugPrint('🔥 Firebase delete comment error: ${e.message}');
      debugPrintStack(stackTrace: st);
      onError(e.message ?? 'Failed to delete comment');
    } catch (e, st) {
      debugPrint('🔥 Unknown delete error: $e');
      debugPrintStack(stackTrace: st);
      onError('Something went wrong');
    }
  }

  // ==========================================================
  // STREAM COMMENTS FOR A POST
  // ==========================================================
  Stream<List<Map<String, dynamic>>> streamPostComments(
    String postId,
  ) {
    return _db
        .child('comments')
        .child(postId)
        .orderByChild('createdAt')
        .onValue
        .map((event) {
          try {
            final snapshotValue = event.snapshot.value;

            if (snapshotValue == null || snapshotValue is! Map) {
              return <Map<String, dynamic>>[];
            }

            final Map<String, dynamic> rawMap =
                Map<String, dynamic>.from(snapshotValue);

            return rawMap.entries.map((entry) {
              final value = Map<String, dynamic>.from(entry.value);
              return {
                'id': entry.key, // 👈 required for delete
                ...value,
              };
            }).toList();
          } catch (e, st) {
            debugPrint('🔥 Stream parse error: $e');
            debugPrintStack(stackTrace: st);
            return <Map<String, dynamic>>[];
          }
        })
        .handleError((error, stackTrace) {
          debugPrint('🔥 Stream DB error: $error');
          debugPrintStack(stackTrace: stackTrace);
        });
  }
}
