import 'package:flutter/widgets.dart';

/// Mixin to provide memoization capabilities for widgets
/// Helps prevent unnecessary rebuilds
mixin SmartStateMemoization {
  /// Cache for memoized values.
  ///
  /// Note: This cache has a bounded size controlled by [maxMemoEntries].
  /// When the limit is reached, the oldest entry is evicted automatically.
  final Map<String, dynamic> _memoCache = {};

  /// Maximum number of entries to keep in the memoization cache.
  ///
  /// Classes mixing in [SmartStateMemoization] can override this getter
  /// to customize the cache size if needed.
  int get maxMemoEntries => 1000;

  /// Memoize a value based on dependencies
  T memoize<T>(String key, T Function() compute, List<Object?> dependencies) {
    final depKey = '$key-${Object.hashAll(dependencies)}';

    if (!_memoCache.containsKey(depKey)) {
      // Enforce a maximum cache size by evicting the oldest entry
      // when the limit is reached.
      if (_memoCache.length >= maxMemoEntries && _memoCache.isNotEmpty) {
        final oldestKey = _memoCache.keys.first;
        _memoCache.remove(oldestKey);
      }

      _memoCache[depKey] = compute();
    }

    return _memoCache[depKey] as T;
  }

  /// Clear all memoized values from the cache.
  void clearMemoCache() {
    _memoCache.clear();
  }
}

/// A widget that prevents rebuilds if the child hasn't changed
class SmartStateKeepAlive extends StatefulWidget {
  const SmartStateKeepAlive({
    super.key,
    required this.child,
    this.keepAlive = true,
  });

  final Widget child;
  final bool keepAlive;

  @override
  State<SmartStateKeepAlive> createState() => _SmartStateKeepAliveState();
}

class _SmartStateKeepAliveState extends State<SmartStateKeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => widget.keepAlive;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
