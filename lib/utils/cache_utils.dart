import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class AppCacheManager {
  static final CacheManager instance = CacheManager(
    Config(
      'globalImageCache',
      stalePeriod: const Duration(hours: 12),
      maxNrOfCacheObjects: 100,
    ),
  );
}
