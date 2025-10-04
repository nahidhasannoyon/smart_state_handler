import 'package:flutter_test/flutter_test.dart';
import 'package:smart_state_handler/smart_state_handler.dart';

void main() {
  group('SmartStateExtension', () {
    test('isLoading returns true for loading state', () {
      expect(SmartState.loading.isLoading, isTrue);
      expect(SmartState.success.isLoading, isFalse);
      expect(SmartState.error.isLoading, isFalse);
      expect(SmartState.initial.isLoading, isFalse);
      expect(SmartState.empty.isLoading, isFalse);
      expect(SmartState.offline.isLoading, isFalse);
      expect(SmartState.loadingMore.isLoading, isFalse);
    });

    test('isError returns true for error state', () {
      expect(SmartState.error.isError, isTrue);
      expect(SmartState.loading.isError, isFalse);
      expect(SmartState.success.isError, isFalse);
      expect(SmartState.initial.isError, isFalse);
      expect(SmartState.empty.isError, isFalse);
      expect(SmartState.offline.isError, isFalse);
      expect(SmartState.loadingMore.isError, isFalse);
    });

    test('isEmpty returns true for empty state', () {
      expect(SmartState.empty.isEmpty, isTrue);
      expect(SmartState.loading.isEmpty, isFalse);
      expect(SmartState.success.isEmpty, isFalse);
      expect(SmartState.error.isEmpty, isFalse);
      expect(SmartState.initial.isEmpty, isFalse);
      expect(SmartState.offline.isEmpty, isFalse);
      expect(SmartState.loadingMore.isEmpty, isFalse);
    });

    test('isOffline returns true for offline state', () {
      expect(SmartState.offline.isOffline, isTrue);
      expect(SmartState.loading.isOffline, isFalse);
      expect(SmartState.success.isOffline, isFalse);
      expect(SmartState.error.isOffline, isFalse);
      expect(SmartState.initial.isOffline, isFalse);
      expect(SmartState.empty.isOffline, isFalse);
      expect(SmartState.loadingMore.isOffline, isFalse);
    });

    test('isSuccess returns true for success state', () {
      expect(SmartState.success.isSuccess, isTrue);
      expect(SmartState.loading.isSuccess, isFalse);
      expect(SmartState.error.isSuccess, isFalse);
      expect(SmartState.initial.isSuccess, isFalse);
      expect(SmartState.empty.isSuccess, isFalse);
      expect(SmartState.offline.isSuccess, isFalse);
      expect(SmartState.loadingMore.isSuccess, isFalse);
    });

    test('isLoadingMore returns true for loadingMore state', () {
      expect(SmartState.loadingMore.isLoadingMore, isTrue);
      expect(SmartState.loading.isLoadingMore, isFalse);
      expect(SmartState.success.isLoadingMore, isFalse);
      expect(SmartState.error.isLoadingMore, isFalse);
      expect(SmartState.initial.isLoadingMore, isFalse);
      expect(SmartState.empty.isLoadingMore, isFalse);
      expect(SmartState.offline.isLoadingMore, isFalse);
    });

    test('isInitial returns true for initial state', () {
      expect(SmartState.initial.isInitial, isTrue);
      expect(SmartState.loading.isInitial, isFalse);
      expect(SmartState.success.isInitial, isFalse);
      expect(SmartState.error.isInitial, isFalse);
      expect(SmartState.empty.isInitial, isFalse);
      expect(SmartState.offline.isInitial, isFalse);
      expect(SmartState.loadingMore.isInitial, isFalse);
    });
  });

  group('SmartState enum', () {
    test('has all expected values', () {
      expect(SmartState.values, [
        SmartState.initial,
        SmartState.loading,
        SmartState.error,
        SmartState.empty,
        SmartState.offline,
        SmartState.success,
        SmartState.loadingMore,
      ]);
    });

    test('can be converted to string', () {
      expect(SmartState.loading.toString(), 'SmartState.loading');
      expect(SmartState.success.toString(), 'SmartState.success');
      expect(SmartState.error.toString(), 'SmartState.error');
    });
  });
}
