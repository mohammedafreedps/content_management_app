import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:content_managing_app/models/uploaded_media_model.dart';

class FirebaseScheduledPostFunctions {
  FirebaseScheduledPostFunctions._();
  static final instance = FirebaseScheduledPostFunctions._();

  final DatabaseReference _db = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://content-review-bbd55-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref();

  // =========================================================
  // READ: Stream scheduled & approved posts for a date
  // =========================================================
  Stream<List<UploadedMedia>> streamScheduledPostsForDate(
    String scheduledDate,
  ) {
    return _db
        .child('uploads')
        .orderByChild('scheduledDate')
        .equalTo(scheduledDate)
        .onValue
        .map((event) {
          try {
            final value = event.snapshot.value;

            if (value == null || value is! Map) {
              return <UploadedMedia>[];
            }

            final Map<dynamic, dynamic> raw = Map<dynamic, dynamic>.from(value);

            final List<UploadedMedia> result = [];

            for (final entry in raw.entries) {
              final data = Map<dynamic, dynamic>.from(entry.value);

              // Extra safety filters
              if (data['isApproved'] != true) continue;
              if (data['scheduledDate'] == null) continue;

              result.add(UploadedMedia.fromMap(entry.key, data));
            }

            result.sort((a, b) => a.uploadedAt.compareTo(b.uploadedAt));

            return result;
          } catch (e, st) {
            debugPrint('🔥 Scheduled post parse error: $e');
            debugPrintStack(stackTrace: st);
            return <UploadedMedia>[];
          }
        })
        .handleError((error, stackTrace) {
          debugPrint('🔥 Scheduled post stream error: $error');
          debugPrintStack(stackTrace: stackTrace);
        });
  }

  // =========================================================
  // WRITE: Update schedule date for a post (yyyy-MM-dd)
  // =========================================================
  Future<void> updateScheduledDate({
    required String postId,
    required String scheduledDate, // yyyy-MM-dd
  }) async {
    try {
      if (scheduledDate.isEmpty) {
        throw Exception('Scheduled date cannot be empty');
      }

      await _db.child('uploads').child(postId).update({
        'scheduledDate': scheduledDate,
        'status': 'scheduled',
      });
    } catch (e, st) {
      debugPrint('🔥 Update scheduled date failed: $e');
      debugPrintStack(stackTrace: st);
      rethrow; // 🔥 IMPORTANT for Cubit
    }
  }

  // =========================================================
  // OPTIONAL: Unschedule a post (clean revert)
  // =========================================================
  Future<void> clearScheduledDate({required String postId}) async {
    try {
      await _db.child('uploads').child(postId).update({
        'scheduledDate': null,
        'status': 'uploaded',
      });
    } catch (e, st) {
      debugPrint('🔥 Clear scheduled date failed: $e');
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }

  Stream<Set<DateTime>> streamScheduledDaysForMonth(DateTime month) {
    final String monthPrefix =
        "${month.year}-${month.month.toString().padLeft(2, '0')}";

    return _db
        .child('uploads')
        .orderByChild('scheduledDate')
        .startAt(monthPrefix)
        .endAt("$monthPrefix\uf8ff")
        .onValue
        .map((event) {
          final snapshot = event.snapshot.value;

          if (snapshot == null || snapshot is! Map) {
            return <DateTime>{};
          }

          final Map<dynamic, dynamic> raw = Map<dynamic, dynamic>.from(
            snapshot,
          );

          final Set<DateTime> result = {};

          for (final entry in raw.entries) {
            final data = Map<dynamic, dynamic>.from(entry.value);

            if (data['isApproved'] != true) continue;
            if (data['scheduledDate'] == null) continue;

            final String dateStr = data['scheduledDate']; // yyyy-MM-dd

            final parts = dateStr.split('-');
            if (parts.length != 3) continue;

            final dt = DateTime(
              int.parse(parts[0]),
              int.parse(parts[1]),
              int.parse(parts[2]),
            );

            result.add(dt);
          }

          return result;
        });
  }
}
