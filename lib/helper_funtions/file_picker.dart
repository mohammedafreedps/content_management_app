import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum MediaType { image, video }

class PickedMedia {
  final File file;
  final MediaType type;

  PickedMedia({
    required this.file,
    required this.type,
  });
}

class FilePickerService {
  static Future<PickedMedia?> pickMedia() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.media, // image + video
        allowMultiple: false,
        withData: false, // avoid loading large files into memory
      );

      if (result == null || result.files.isEmpty) {
        debugPrint('FilePicker: user cancelled');
        return null;
      }

      final picked = result.files.first;

      if (picked.path == null) {
        debugPrint('FilePicker: file path is null');
        return null;
      }

      final File file = File(picked.path!);

      final String extension =
          picked.extension?.toLowerCase() ?? '';

      final MediaType type =
          _isVideo(extension) ? MediaType.video : MediaType.image;

      debugPrint(
        'FilePicker: picked ${type.name} file at ${file.path}',
      );

      return PickedMedia(
        file: file,
        type: type,
      );
    } on PlatformException catch (e) {
      debugPrint(
        'FilePicker PlatformException: ${e.message}',
      );
      return null;
    } catch (e, st) {
      debugPrint('FilePicker unexpected error: $e');
      debugPrintStack(stackTrace: st);
      return null;
    }
  }

  static bool _isVideo(String ext) {
    const videoExts = {
      'mp4',
      'mov',
      'mkv',
      'avi',
      'webm',
      '3gp',
    };
    return videoExts.contains(ext);
  }
}
