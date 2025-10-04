import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_state_handler/smart_state_handler.dart';

void main() {
  group('SmartStateHandler', () {
    testWidgets('displays loading state correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartStateHandler<List<String>>(
              currentState: SmartState.loading,
              successDataBuilder: (context, data) => const Text('Success'),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading...'), findsOneWidget);
    });

    testWidgets('displays custom loading message', (WidgetTester tester) async {
      const customMessage = 'Loading your data...';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartStateHandler<List<String>>(
              currentState: SmartState.loading,
              customLoadingMessage: customMessage,
              successDataBuilder: (context, data) => const Text('Success'),
            ),
          ),
        ),
      );

      expect(find.text(customMessage), findsOneWidget);
    });

    testWidgets('displays error state with error message',
        (WidgetTester tester) async {
      const errorMessage = 'Network error occurred';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartStateHandler<List<String>>(
              currentState: SmartState.error,
              errorObject: errorMessage,
              successDataBuilder: (context, data) => const Text('Success'),
            ),
          ),
        ),
      );

      expect(find.text(errorMessage), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('displays success state with data',
        (WidgetTester tester) async {
      final testData = ['Item 1', 'Item 2', 'Item 3'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartStateHandler<List<String>>(
              currentState: SmartState.success,
              successData: testData,
              successDataBuilder: (context, data) {
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) => Text(data[index]),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
    });

    testWidgets('displays empty state when data is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartStateHandler<List<String>>(
              currentState: SmartState.success,
              successData: null,
              successDataBuilder: (context, data) => const Text('Success'),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
      expect(find.text('No data available'), findsOneWidget);
    });

    testWidgets('displays empty state correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartStateHandler<List<String>>(
              currentState: SmartState.empty,
              successDataBuilder: (context, data) => const Text('Success'),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
      expect(find.text('No data available'), findsOneWidget);
    });

    testWidgets('displays offline state correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartStateHandler<List<String>>(
              currentState: SmartState.offline,
              successDataBuilder: (context, data) => const Text('Success'),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.wifi_off_outlined), findsOneWidget);
      expect(find.text('No internet connection'), findsOneWidget);
    });

    testWidgets('displays initial state correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartStateHandler<List<String>>(
              currentState: SmartState.initial,
              successDataBuilder: (context, data) => const Text('Success'),
            ),
          ),
        ),
      );

      expect(find.text('Ready to start'), findsOneWidget);
    });

    testWidgets('retry button calls onRetryPressed',
        (WidgetTester tester) async {
      var retryPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartStateHandler<List<String>>(
              currentState: SmartState.error,
              errorObject: 'Error occurred',
              onRetryPressed: () => retryPressed = true,
              successDataBuilder: (context, data) => const Text('Success'),
            ),
          ),
        ),
      );

      expect(find.text('Retry'), findsOneWidget);
      await tester.tap(find.text('Retry'));
      expect(retryPressed, isTrue);
    });

    testWidgets('uses custom error state builder', (WidgetTester tester) async {
      const customErrorText = 'Custom error widget';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartStateHandler<List<String>>(
              currentState: SmartState.error,
              errorObject: 'Error',
              errorStateBuilder: (context, error) =>
                  const Text(customErrorText),
              successDataBuilder: (context, data) => const Text('Success'),
            ),
          ),
        ),
      );

      expect(find.text(customErrorText), findsOneWidget);
    });

    testWidgets('uses custom loading state builder',
        (WidgetTester tester) async {
      const customLoadingText = 'Custom loading widget';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartStateHandler<List<String>>(
              currentState: SmartState.loading,
              loadingStateBuilder: (context) => const Text(customLoadingText),
              successDataBuilder: (context, data) => const Text('Success'),
            ),
          ),
        ),
      );

      expect(find.text(customLoadingText), findsOneWidget);
    });

    testWidgets('uses custom empty state builder', (WidgetTester tester) async {
      const customEmptyText = 'Custom empty widget';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartStateHandler<List<String>>(
              currentState: SmartState.empty,
              emptyStateBuilder: (context) => const Text(customEmptyText),
              successDataBuilder: (context, data) => const Text('Success'),
            ),
          ),
        ),
      );

      expect(find.text(customEmptyText), findsOneWidget);
    });

    testWidgets('uses custom offline state builder',
        (WidgetTester tester) async {
      const customOfflineText = 'Custom offline widget';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartStateHandler<List<String>>(
              currentState: SmartState.offline,
              offlineStateBuilder: (context) => const Text(customOfflineText),
              successDataBuilder: (context, data) => const Text('Success'),
            ),
          ),
        ),
      );

      expect(find.text(customOfflineText), findsOneWidget);
    });

    testWidgets('uses custom initial state builder',
        (WidgetTester tester) async {
      const customInitialText = 'Custom initial widget';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartStateHandler<List<String>>(
              currentState: SmartState.initial,
              initialStateBuilder: (context) => const Text(customInitialText),
              successDataBuilder: (context, data) => const Text('Success'),
            ),
          ),
        ),
      );

      expect(find.text(customInitialText), findsOneWidget);
    });

    testWidgets('uses custom text config', (WidgetTester tester) async {
      const customRetryText = 'Try Once More';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartStateHandler<List<String>>(
              currentState: SmartState.error,
              errorObject: 'Error',
              onRetryPressed: () {},
              textConfig: const SmartStateTextConfig(
                retryButtonText: customRetryText,
              ),
              successDataBuilder: (context, data) => const Text('Success'),
            ),
          ),
        ),
      );

      expect(find.text(customRetryText), findsOneWidget);
    });

    testWidgets('uses custom icons', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartStateHandler<List<String>>(
              currentState: SmartState.error,
              errorIcon: Icons.sentiment_dissatisfied,
              successDataBuilder: (context, data) => const Text('Success'),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.sentiment_dissatisfied), findsOneWidget);
    });

    testWidgets('wraps content with RefreshIndicator when enabled',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartStateHandler<List<String>>(
              currentState: SmartState.success,
              successData: ['Item 1'],
              enablePullToRefresh: true,
              onPullToRefresh: () async {},
              successDataBuilder: (context, data) {
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) => Text(data[index]),
                );
              },
            ),
          ),
        ),
      );

      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('does not show RefreshIndicator when disabled',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartStateHandler<List<String>>(
              currentState: SmartState.success,
              successData: ['Item 1'],
              enablePullToRefresh: false,
              successDataBuilder: (context, data) {
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) => Text(data[index]),
                );
              },
            ),
          ),
        ),
      );

      expect(find.byType(RefreshIndicator), findsNothing);
    });

    testWidgets('applies container styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartStateHandler<List<String>>(
              currentState: SmartState.success,
              successData: ['Item 1'],
              containerBackgroundColor: Colors.blue,
              contentPadding: const EdgeInsets.all(16),
              successDataBuilder: (context, data) => Text(data[0]),
            ),
          ),
        ),
      );

      // Find the outermost container
      final containers = tester.widgetList<Container>(find.byType(Container));
      expect(containers, isNotEmpty);

      // Verify that container styling is applied
      final styledContainer = containers.firstWhere(
        (container) => container.color == Colors.blue,
      );
      expect(styledContainer.color, Colors.blue);
      expect(styledContainer.padding, const EdgeInsets.all(16));
    });
  });

  group('SmartStateHandler Overlay Mode', () {
    testWidgets('displays base content in overlay mode',
        (WidgetTester tester) async {
      const baseContentText = 'Base Form Content';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartStateHandler<String>(
              currentState: SmartState.initial,
              enableOverlayStates: true,
              baseContentBuilder: (context) => const Text(baseContentText),
              successDataBuilder: (context, data) => Text(data),
            ),
          ),
        ),
      );

      expect(find.text(baseContentText), findsOneWidget);
    });

    testWidgets('shows loading overlay in overlay mode',
        (WidgetTester tester) async {
      const baseContentText = 'Base Form Content';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartStateHandler<String>(
              currentState: SmartState.loading,
              enableOverlayStates: true,
              baseContentBuilder: (context) => const Text(baseContentText),
              successDataBuilder: (context, data) => Text(data),
            ),
          ),
        ),
      );

      // Base content should still be visible
      expect(find.text(baseContentText), findsOneWidget);
      // Loading indicator should be shown as overlay
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error overlay in overlay mode',
        (WidgetTester tester) async {
      const baseContentText = 'Base Form Content';
      const errorMessage = 'Submission failed';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartStateHandler<String>(
              currentState: SmartState.error,
              errorObject: errorMessage,
              enableOverlayStates: true,
              baseContentBuilder: (context) => const Text(baseContentText),
              successDataBuilder: (context, data) => Text(data),
            ),
          ),
        ),
      );

      // Base content should still be visible
      expect(find.text(baseContentText), findsOneWidget);
      // Error should be shown as overlay
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('shows success overlay in overlay mode',
        (WidgetTester tester) async {
      const baseContentText = 'Base Form Content';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartStateHandler<String>(
              currentState: SmartState.success,
              enableOverlayStates: true,
              baseContentBuilder: (context) => const Text(baseContentText),
              successDataBuilder: (context, data) => const Text('Success data'),
            ),
          ),
        ),
      );

      // Base content should still be visible
      expect(find.text(baseContentText), findsOneWidget);
      // Success indicator should be shown
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('uses custom overlay builders', (WidgetTester tester) async {
      const customOverlayText = 'Custom Loading Overlay';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartStateHandler<String>(
              currentState: SmartState.loading,
              enableOverlayStates: true,
              baseContentBuilder: (context) => const Text('Base'),
              overlayLoadingBuilder: (context) => const Text(customOverlayText),
              successDataBuilder: (context, data) => Text(data),
            ),
          ),
        ),
      );

      expect(find.text(customOverlayText), findsOneWidget);
    });
  });

  group('SmartStateHandler Animations', () {
    testWidgets('wraps content with AnimatedSwitcher when animations enabled',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartStateHandler<List<String>>(
              currentState: SmartState.success,
              successData: ['Item 1'],
              enableAnimations: true,
              successDataBuilder: (context, data) => Text(data[0]),
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedSwitcher), findsWidgets);
    });

    testWidgets('does not use animations when disabled',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartStateHandler<List<String>>(
              currentState: SmartState.success,
              successData: ['Item 1'],
              enableAnimations: false,
              successDataBuilder: (context, data) => Text(data[0]),
            ),
          ),
        ),
      );

      // Content should be displayed directly without AnimatedSwitcher wrapper
      expect(find.text('Item 1'), findsOneWidget);
    });
  });

  group('SmartStateHandler Pagination', () {
    testWidgets('displays loading more state', (WidgetTester tester) async {
      final data = List.generate(10, (index) => 'Item $index');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SmartStateHandler<List<String>>(
              currentState: SmartState.loadingMore,
              successData: data,
              hasMoreDataToLoad: true,
              successDataBuilder: (context, items) {
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) => Text(items[index]),
                );
              },
            ),
          ),
        ),
      );

      // All items should be visible
      expect(find.text('Item 0'), findsOneWidget);
      expect(find.text('Item 9'), findsOneWidget);
    });
  });
}
