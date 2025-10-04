# SmartStateHandler Example

This example demonstrates all the features of the SmartStateHandler package.

## Features Demonstrated

### 1. Product List Example

- Loading state with initial state
- Success state with data display
- Error state with custom error message
- Empty state handling
- Pull-to-refresh functionality
- Pagination with "load more" functionality
- Smooth animations between states
- Custom error and empty state builders

### 2. Form Example

- Overlay mode demonstration
- Loading overlay while submitting
- Error overlay with retry button
- Success overlay with auto-dismiss
- Form validation
- Base content stays visible during state changes

## Running the Example

1. Navigate to the example directory:

```bash
cd example
```

2. Get dependencies:

```bash
flutter pub get
```

3. Run the app:

```bash
flutter run
```

## Code Overview

### Product List

The product list example shows how to use SmartStateHandler for typical list views with pagination:

```dart
SmartStateHandler<List<Product>>(
  currentState: _currentState,
  successData: _products,
  errorObject: _error,
  hasMoreDataToLoad: _hasMoreData,
  enablePullToRefresh: true,
  onRetryPressed: () => _loadProducts(isRefresh: true),
  onPullToRefresh: () => _loadProducts(isRefresh: true),
  onLoadMoreData: _loadMoreProducts,
  successDataBuilder: (context, products) {
    return ListView.builder(...);
  },
)
```

### Form with Overlay

The form example demonstrates overlay mode for non-intrusive state changes:

```dart
SmartStateHandler<void>(
  currentState: _formState,
  errorObject: _error,
  enableOverlayStates: true,
  baseContentBuilder: (context) => MyForm(),
  overlayLoadingBuilder: (context) => LoadingOverlay(),
  overlayErrorBuilder: (context, error) => ErrorOverlay(error),
  overlaySuccessBuilder: (context) => SuccessOverlay(),
)
```

## Tips

- The example simulates a 75% success rate to help you test error states
- Use the refresh button in the app bar to test pull-to-refresh
- Scroll to the bottom to trigger pagination
- Try the form example to see overlay mode in action
- States auto-update to demonstrate different scenarios

## Learn More

For more information, visit the [main README](../README.md) or check out the [API documentation](https://pub.dev/documentation/smart_state_handler/latest/).
