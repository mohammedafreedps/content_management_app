import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class PostDeleteManager {
  PostDeleteManager._();
  static final instance = PostDeleteManager._();

  final DatabaseReference _db =
      FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL:
            'https://content-review-bbd55-default-rtdb.asia-southeast1.firebasedatabase.app',
      ).ref();

  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> deletePost({required String postId}) async {
    try {
      debugPrint('🟡 Fetching post: $postId');

      final postSnap =
          await _db.child('uploads').child(postId).get();

      debugPrint('🟢 Post snapshot fetched');

      if (!postSnap.exists) {
        throw Exception('Post not found');
      }

      final postData =
          Map<String, dynamic>.from(postSnap.value as Map);

      final String? storagePath = postData['storagePath'];

      // Delete Supabase image
      if (storagePath != null && storagePath.isNotEmpty) {
        try {
          await _supabase.storage
              .from('content')
              .remove([storagePath]);
        } catch (e) {
          debugPrint('⚠️ Supabase delete failed: $e');
        }
      }

      await _db.child('comments').child(postId).remove();
      await _db.child('uploads').child(postId).remove();

      debugPrint('✅ Post deleted successfully');
    } catch (e, st) {
      debugPrint('🔥 Delete post failed: $e');
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }
}
