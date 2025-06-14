import 'dart:async';
import 'product_local_data_source.dart';

class ProductCacheManager {
  final ProductLocalDataSource _localDataSource;

  ProductCacheManager(this._localDataSource);

  /// Manually trigger cache cleanup
  Future<void> cleanupExpiredCache() async {
    await _localDataSource.clearExpiredCache();
  }

  /// Clear all cache data
  Future<void> clearAllCache() async {
    await _localDataSource.invalidateCache();
  }

  /// Get cache statistics
  Future<CacheStatistics> getCacheStatistics() async {
    // This would require additional methods in the local data source
    // For now, return basic stats
    return CacheStatistics(
      totalCachedProducts: 0, // Would need to implement counting
      expiredProducts: 0, // Would need to implement counting
      cacheSize: 0, // Would need to implement size calculation
      lastCleanup: DateTime.now(),
    );
  }

  /// Preload products into cache
  Future<void> preloadProducts(List<int> productIds) async {
    // This would be used to preload frequently accessed products
    // Implementation would depend on having access to remote data source
  }

  void dispose() {
    // No cleanup needed since we don't have periodic timers
  }
}

class CacheStatistics {
  final int totalCachedProducts;
  final int expiredProducts;
  final int cacheSize; // in bytes
  final DateTime lastCleanup;

  CacheStatistics({
    required this.totalCachedProducts,
    required this.expiredProducts,
    required this.cacheSize,
    required this.lastCleanup,
  });

  @override
  String toString() {
    return 'CacheStatistics(total: $totalCachedProducts, expired: $expiredProducts, size: ${cacheSize}B, lastCleanup: $lastCleanup)';
  }
}
