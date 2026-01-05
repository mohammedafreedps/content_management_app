class UploadedMedia {
  final String id; // postId
  final String userId;
  final String description;
  final bool isStory;
  final String platform;
  final String status;
  final String storagePath;
  final String type;
  final DateTime uploadedAt;

  UploadedMedia({
    required this.id,
    required this.userId,
    required this.description,
    required this.isStory,
    required this.platform,
    required this.status,
    required this.storagePath,
    required this.type,
    required this.uploadedAt,
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
      storagePath: map['storagePath'] ?? '',
      type: map['type'] ?? 'image',
      uploadedAt: DateTime.fromMillisecondsSinceEpoch(
        map['uploadedAt'] is int ? map['uploadedAt'] : 0,
      ),
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
      'uploadedAt': uploadedAt.millisecondsSinceEpoch,
    };
  }
}
