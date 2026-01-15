import 'package:flutter/widgets.dart';

/// Mixin to provide memoization capabilities for widgets
/// Helps prevent unnecessary rebuilds
mixin SmartStateMemoization {
  /// Cache for memoized values
  final Map<String, dynamic> _memoCache = {};

  /// Memoize a value based on dependencies
  T memoize<T>(String key, T Function() compute, List<Object?> dependencies) {
    final depKey = '$key-${dependencies.hashCode}';

    if (!_memoCache.containsKey(depKey)) {
      _memoCache[depKey] = compute();
    }

    return _memoCache[depKey] as T;
  }

  /// Clear memoization cache
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
