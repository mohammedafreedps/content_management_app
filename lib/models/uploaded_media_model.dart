class UploadedMedia {
  final String id; // postId
  final String userId;
  final String description;
  final bool isStory;
  final String platform;
  final String status;
  final String storagePath;
  final String type;
  final bool isApproved;
  final String userName;
  final DateTime uploadedAt;

  // 🔥 NEW (non-breaking)
  final String? scheduledDate; // yyyy-MM-dd

  UploadedMedia({
    required this.id,
    required this.userId,
    required this.description,
    required this.isStory,
    required this.platform,
    required this.status,
    required this.storagePath,
    required this.type,
    required this.isApproved,
    required this.userName,
    required this.uploadedAt,
    this.scheduledDate,
  });

  factory UploadedMedia.fromMap(
    String id,
    Map<dynamic, dynamic> map,
  ) {
    return UploadedMedia(
      id: id,
      userId: map['userId'] ?? '',
      description: map['description'] ?? '',
      isStory: map['isStory'] ?? false,
      platform: map['platform'] ?? 'instagram',
      status: map['status'] ?? 'pending_upload',
      storagePath: map['downloadUrl'] ?? '',
      type: map['type'] ?? 'image',
      isApproved: map['isApproved'] ?? false,
      userName: map['userName'] ?? '',
      uploadedAt: DateTime.fromMillisecondsSinceEpoch(
        map['uploadedAt'] is int ? map['uploadedAt'] : 0,
      ),
      scheduledDate: map['scheduledDate'], // ✅ SAFE
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'description': description,
      'isStory': isStory,
      'platform': platform,
      'status': status,
      'storagePath': storagePath,
      'type': type,
      'isApproved': isApproved,
      'userName': userName,
      'uploadedAt': uploadedAt.millisecondsSinceEpoch,
      if (scheduledDate != null) 'scheduledDate': scheduledDate,
    };
  }
}
