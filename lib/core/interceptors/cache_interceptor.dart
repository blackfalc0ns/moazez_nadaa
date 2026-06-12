import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:developer' as developer;
import '../storage/local_storage.dart';

/// Cache interceptor for offline-first architecture
/// Caches GET requests and serves from cache when offline
/// 
/// Features:
/// - Offline-first support
/// - Performance optimization
/// - Reduced API load
/// - Configurable TTL (Time To Live)
class CacheInterceptor extends Interceptor {
  final LocalStorage _localStorage;
  final Duration defaultTTL;
  final bool forceRefresh;

  CacheInterceptor(
    this._localStorage, {
    this.defaultTTL = const Duration(minutes: 5),
    this.forceRefresh = false,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Only cache GET requests
    if (options.method.toUpperCase() != 'GET') {
      return handler.next(options);
    }

    // Check if force refresh is requested
    if (forceRefresh || options.extra['force_refresh'] == true) {
      developer.log(
        '🔄 Force refresh requested: ${options.uri}',
        name: 'CacheInterceptor',
      );
      return handler.next(options);
    }

    // Generate cache key
    final cacheKey = _generateCacheKey(options);

    // Try to get from cache
    final cachedData = await _getFromCache(cacheKey);

    if (cachedData != null) {
      developer.log(
        '✅ Serving from cache: ${options.uri}',
        name: 'CacheInterceptor',
      );

      // Return cached response
      return handler.resolve(
        Response(
          requestOptions: options,
          data: cachedData['data'],
          statusCode: 200,
          headers: Headers.fromMap({
            'x-cache': ['HIT'],
            'x-cache-time': [cachedData['timestamp'].toString()],
          }),
        ),
      );
    }

    developer.log(
      '❌ Cache miss: ${options.uri}',
      name: 'CacheInterceptor',
    );

    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    // Only cache successful GET requests
    if (response.requestOptions.method.toUpperCase() == 'GET' &&
        response.statusCode == 200) {
      final cacheKey = _generateCacheKey(response.requestOptions);

      // Get TTL from options or use default
      final ttl = response.requestOptions.extra['cache_ttl'] as Duration? ??
          defaultTTL;

      await _saveToCache(cacheKey, response.data, ttl);

      developer.log(
        '💾 Saved to cache: ${response.requestOptions.uri} (TTL: ${ttl.inMinutes}m)',
        name: 'CacheInterceptor',
      );
    }

    handler.next(response);
  }

  /// Generate cache key from request options
  String _generateCacheKey(RequestOptions options) {
    final path = options.path;
    final queryParams = options.queryParameters.toString();
    return 'cache:$path:$queryParams';
  }

  /// Get data from cache
  Future<Map<String, dynamic>?> _getFromCache(String key) async {
    try {
      final cachedJson = _localStorage.getJson(key);

      if (cachedJson == null) return null;

      final timestamp = DateTime.parse(cachedJson['timestamp'] as String);
      final ttl = Duration(milliseconds: cachedJson['ttl'] as int);
      final expiryTime = timestamp.add(ttl);

      // Check if cache is expired
      if (DateTime.now().isAfter(expiryTime)) {
        developer.log(
          '⏰ Cache expired: $key',
          name: 'CacheInterceptor',
        );
        await _localStorage.remove(key);
        return null;
      }

      return cachedJson;
    } catch (e) {
      developer.log(
        '❌ Error reading cache: $e',
        name: 'CacheInterceptor',
      );
      return null;
    }
  }

  /// Save data to cache
  Future<void> _saveToCache(String key, dynamic data, Duration ttl) async {
    try {
      final cacheData = {
        'data': data,
        'timestamp': DateTime.now().toIso8601String(),
        'ttl': ttl.inMilliseconds,
      };

      await _localStorage.setJson(key, cacheData);
    } catch (e) {
      developer.log(
        '❌ Error saving to cache: $e',
        name: 'CacheInterceptor',
      );
    }
  }

  /// Clear all cache
  Future<void> clearCache() async {
    final keys = _localStorage.getKeys();
    for (final key in keys) {
      if (key.startsWith('cache:')) {
        await _localStorage.remove(key);
      }
    }
    developer.log(
      '🗑️ Cache cleared',
      name: 'CacheInterceptor',
    );
  }

  /// Clear specific cache by pattern
  Future<void> clearCacheByPattern(String pattern) async {
    final keys = _localStorage.getKeys();
    for (final key in keys) {
      if (key.startsWith('cache:') && key.contains(pattern)) {
        await _localStorage.remove(key);
      }
    }
    developer.log(
      '🗑️ Cache cleared for pattern: $pattern',
      name: 'CacheInterceptor',
    );
  }
}

/// Extension for easy cache control
extension CacheOptionsExtension on RequestOptions {
  /// Set cache TTL for this request
  RequestOptions withCacheTTL(Duration ttl) {
    extra['cache_ttl'] = ttl;
    return this;
  }

  /// Force refresh (skip cache)
  RequestOptions withForceRefresh() {
    extra['force_refresh'] = true;
    return this;
  }
}
