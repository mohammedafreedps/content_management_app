import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseFileUpload {
  FirebaseFileUpload._();
  static final instance = FirebaseFileUpload._();

  final DatabaseReference _db = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://content-review-bbd55-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref();

  /// TEMPORARY IMPLEMENTATION
  /// - No Firebase Storage upload
  /// - Saves GLOBAL metadata to Realtime DB
  /// - Easy to enable storage later
  void uploadFile({
    required File file,
    required String folder, // ex: "content"
    required String userId,
    required String fileType, // "image" | "video"
    required String platform, // "instagram" | "facebook" | "both"
    required bool isStory,
    required String description,
    required void Function(double progress) onProgress,
    required void Function(Map<String, dynamic> data) onComplete,
    required void Function(String error) onError,
  }) {
    try {
      // -----------------------------
      // Simulate progress
      // -----------------------------
      onProgress(0.3);

      final fileName =
          "${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}";

      final storagePath = "$folder/$userId/$fileName";

      final Map<String, dynamic> data = {
        "userId": userId, // 👈 REQUIRED for global feed
        "downloadUrl": null, // temporarily unavailable
        "storagePath": storagePath,
        "type": fileType,
        "isStory": isStory,
        "platform": platform,
        "description": description,
        "status": "pending_upload", // retry / upload later
        "uploadedAt": ServerValue.timestamp,
      };

      onProgress(0.8);

      // -----------------------------
      // GLOBAL WRITE (NO userId nesting)
      // -----------------------------
      _db
          .child("uploads")
          .push()
          .set(data)
          .then((_) {
        onProgress(1.0);
        onComplete(data);
      }).catchError((e) {
        onError(e.toString());
      });
    } catch (e) {
      onError(e.toString());
    }
  }
}
