import 'package:smart_state_handler/src/enums/smart_state_enum.dart';

/// Service for managing SmartStateHandler internal state to prevent memory leaks
/// and provide proper lifecycle management for shared state across widgets.
class SmartStateTrackingService {
  static final SmartStateTrackingService _instance =
      SmartStateTrackingService._internal();
  factory SmartStateTrackingService() => _instance;
  SmartStateTrackingService._internal();

  // Track snackbar states with unique keys instead of hashCode
  final Map<String, ({SmartState state, DateTime timestamp})> _snackbarStates =
      {};
  static const _snackbarCooldownMs = 500;

  // Track load more triggers
  final Map<String, DateTime> _loadMoreTriggers = {};

  // Generate stable keys for widgets based on an optional identifier
  String generateKey([Object? widgetIdentifier]) {
    final baseId = widgetIdentifier?.hashCode ?? hashCode;
    return baseId.toString();
  }

  /// Check if snackbar should be shown for given state and key
  bool shouldShowSnackbar(String key, SmartState currentState) {
    final now = DateTime.now();
    final lastEntry = _snackbarStates[key];

    final shouldShow = lastEntry == null ||
        lastEntry.state != currentState ||
        now.difference(lastEntry.timestamp).inMilliseconds >
            _snackbarCooldownMs;

    if (shouldShow) {
      _snackbarStates[key] = (state: currentState, timestamp: now);
      _cleanupOldEntries();
    }

    return shouldShow;
  }

  /// Check if load more should be triggered for given key
  bool shouldTriggerLoadMore(String key, int debounceMs) {
    final now = DateTime.now();
    final lastTrigger = _loadMoreTriggers[key];

    final shouldTrigger = lastTrigger == null ||
        now.difference(lastTrigger).inMilliseconds >= debounceMs;

    if (shouldTrigger) {
      _loadMoreTriggers[key] = now;
      _cleanupOldEntries();
    }

    return shouldTrigger;
  }

  /// Clean up old entries to prevent memory leaks
  void _cleanupOldEntries() {
    final now = DateTime.now();
    const maxAge = Duration(minutes: 5);

    // Clean up snackbar states
    _snackbarStates
        .removeWhere((key, value) => now.difference(value.timestamp) > maxAge);

    // Clean up load more triggers
    _loadMoreTriggers
        .removeWhere((key, value) => now.difference(value) > maxAge);

    // Limit total entries
    if (_snackbarStates.length > 100) {
      final sortedKeys = _snackbarStates.keys.toList()
        ..sort((a, b) => _snackbarStates[a]!
            .timestamp
            .compareTo(_snackbarStates[b]!.timestamp));
      for (var i = 0; i < 50; i++) {
        _snackbarStates.remove(sortedKeys[i]);
      }
    }

    if (_loadMoreTriggers.length > 50) {
      final sortedKeys = _loadMoreTriggers.keys.toList()
        ..sort(
            (a, b) => _loadMoreTriggers[a]!.compareTo(_loadMoreTriggers[b]!));
      for (var i = 0; i < 25; i++) {
        _loadMoreTriggers.remove(sortedKeys[i]);
      }
    }
  }

  /// Clear all tracked state (useful for testing)
  void clear() {
    _snackbarStates.clear();
    _loadMoreTriggers.clear();
  }
}
