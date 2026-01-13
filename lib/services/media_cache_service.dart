import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class MediaCacheService {
  MediaCacheService._();

  static final instance = MediaCacheService._();

  static final CacheManager _cacheManager = CacheManager(
    Config(
      'mediaCache',
      stalePeriod: const Duration(days: 14), // Keep files 2 weeks
      maxNrOfCacheObjects: 200, // Limit storage
      repo: JsonCacheInfoRepository(databaseName: 'mediaCache'),
      fileService: HttpFileService(),
    ),
  );

  /// Get any media file (image / video / thumbnail)
  /// Returns cached file if exists, otherwise downloads & caches it
  Future<File> getFile(String url) async {
    final cached = await _cacheManager.getFileFromCache(url);

    if (cached != null) {
      debugPrint("📦 CACHE HIT: $url");
      return cached.file;
    }

    debugPrint("🌐 DOWNLOAD: $url");
    return await _cacheManager.getSingleFile(url);
  }

  /// Check if file is already cached
  Future<bool> isCached(String url) async {
    final info = await _cacheManager.getFileFromCache(url);
    return info != null;
  }

  /// Force re-download (if admin updated file)
  Future<File> refresh(String url) async {
    await _cacheManager.removeFile(url);
    return await _cacheManager.getSingleFile(url);
  }

  /// Clear all cached media (debug / settings screen)
  Future<void> clearAll() async {
    await _cacheManager.emptyCache();
  }
}
