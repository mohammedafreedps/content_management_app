import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FirebaseFileUpload {
  FirebaseFileUpload._();
  static final instance = FirebaseFileUpload._();

  final DatabaseReference _db = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://content-review-bbd55-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref();

  final SupabaseClient _supabase = Supabase.instance.client;

  void uploadFile({
    required File file,
    required String folder,
    required String userId,
    required String fileType, // "image" | "video"
    required String platform,
    required bool isStory,
    required String description,
    required void Function(double progress) onProgress,
    required void Function(Map<String, dynamic> data) onComplete,
    required void Function(String error) onError,
  }) async {
    try {
      onProgress(0.1);

      final fileName =
          "${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}";

      String? downloadUrl;
      String? storagePath;

      // -----------------------------------------
      // IMAGE → SUPABASE (NO REAL PROGRESS)
      // -----------------------------------------
      if (fileType == "image") {
        storagePath = "images/$userId/$fileName";

        onProgress(0.3);

        await _supabase.storage.from('content').upload(
          storagePath,
          file,
          fileOptions: const FileOptions(
            upsert: false,
            contentType: 'image/jpeg',
          ),
        );

        onProgress(0.8);

        downloadUrl = _supabase.storage
            .from('content')
            .getPublicUrl(storagePath);
      }

      onProgress(0.9);

      final Map<String, dynamic> data = {
        "userId": userId,
        "downloadUrl": downloadUrl,
        "storagePath": storagePath,
        "type": fileType,
        "isStory": isStory,
        "platform": platform,
        "description": description,
        "status":
            fileType == "image" ? "uploaded" : "pending_upload",
        "isApproved": false,
        "uploadedAt": ServerValue.timestamp,
      };

      await _db.child("uploads").push().set(data);

      onProgress(1.0);
      onComplete(data);
    } catch (e) {
      onError(e.toString());
    }
  }
}
