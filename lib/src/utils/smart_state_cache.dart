/// Internal cache management utility for SmartStateHandler
/// Provides memory-efficient caching with automatic cleanup
library;

/// A simple LRU (Least Recently Used) cache for state management
class SmartStateCache<K, V> {
  SmartStateCache({this.maxSize = 100});

  final int maxSize;
  final Map<K, ({V value, DateTime timestamp})> _cache = {};

  /// Get a value from cache
  V? get(K key) {
    final entry = _cache[key];
    if (entry == null) {
      return null;
    }

    final updatedEntry = (value: entry.value, timestamp: DateTime.now());
    _cache[key] = updatedEntry;

    return updatedEntry.value;
  }

  /// Put a value into cache
  void put(K key, V value) {
    _cache[key] = (value: value, timestamp: DateTime.now());
    _cleanup();
  }

  /// Remove a specific key
  void remove(K key) {
    _cache.remove(key);
  }

  /// Clear all cache
  void clear() {
    _cache.clear();
  }

  /// Check if key exists
  bool containsKey(K key) {
    return _cache.containsKey(key);
  }

  /// Cleanup old entries when cache exceeds max size
  void _cleanup() {
    if (_cache.length > maxSize) {
      final sortedKeys = _cache.keys.toList()
        ..sort((a, b) => _cache[a]!.timestamp.compareTo(_cache[b]!.timestamp));

      final removeCount = (_cache.length - maxSize) + (maxSize ~/ 4);
      for (var i = 0; i < removeCount && i < sortedKeys.length; i++) {
        _cache.remove(sortedKeys[i]);
      }
    }
  }

  /// Get cache size
  int get size => _cache.length;
}
