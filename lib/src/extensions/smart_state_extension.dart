import 'package:smart_state_handler/smart_state_handler.dart';

/// Extension methods for SmartState enum for convenient state checking
extension SmartStateExtension on SmartState {
  /// Returns true if current state is loading
  bool get isLoading => this == SmartState.loading;

  /// Returns true if current state is error
  bool get isError => this == SmartState.error;

  /// Returns true if current state is empty
  bool get isEmpty => this == SmartState.empty;

  /// Returns true if current state is offline
  bool get isOffline => this == SmartState.offline;

  /// Returns true if current state is success
  bool get isSuccess => this == SmartState.success;

  /// Returns true if current state is loadingMore
  bool get isLoadingMore => this == SmartState.loadingMore;

  /// Returns true if current state is initial
  bool get isInitial => this == SmartState.initial;
}
