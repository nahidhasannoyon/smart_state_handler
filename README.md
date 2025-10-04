# 🚀 SmartStateHandler

[![pub package](https://img.shields.io/pub/v/smart_state_handler.svg)](https://pub.dev/packages/smart_state_handler)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A comprehensive, production-ready Flutter widget for handling all UI states (loading, error, success, empty, offline, initial) with smooth animations, overlay mode, pagination support, and extensive customization options.

Inspired by [smart_response_builder](https://pub.dev/packages/smart_response_builder), but with enhanced features and better developer experience.

## 📦 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  smart_state_handler: ^0.1.0
```

Then run:

```bash
flutter pub get
```

## 🚀 Quick Start

```dart
import 'package:flutter/material.dart';
import 'package:smart_state_handler/smart_state_handler.dart';

class ProductListScreen extends StatefulWidget {
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  SmartState _state = SmartState.loading;
  List<Product> _products = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _state = SmartState.loading);

    try {
      final products = await api.fetchProducts();
      setState(() {
        _products = products;
        _state = products.isEmpty ? SmartState.empty : SmartState.success;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _state = SmartState.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: SmartStateHandler<List<Product>>(
        currentState: _state,
        successData: _products,
        errorObject: _error,
        onRetryPressed: _loadProducts,
        onPullToRefresh: _loadProducts,
        successDataBuilder: (context, products) {
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) => ProductCard(products[index]),
          );
        },
      ),
    );
  }
}
```

That's it! SmartStateHandler automatically handles loading, error, empty, and success states for you.

## ✨ What SmartStateHandler Offers

### 🎯 **Enhanced State Management**

- **Single Enum Control**: Clean `SmartState` enum instead of multiple boolean flags
- **Type Safety**: Generic support with compile-time checks
- **Extension Methods**: Convenient `.isLoading`, `.isError`, `.isInitial` state checking
- **Debug Mode**: Built-in logging for development

### 🎨 **Advanced UI Features**

- **Initial State Support**: Perfect for forms and user-triggered operations
- **Overlay Mode**: Show loading/error/success overlays above existing content
- **Smooth Animations**: Fade, slide, scale transitions between states with custom builders
- **Widget Memoization**: Prevents unnecessary rebuilds for better performance
- **Custom Icons**: Easy icon customization without full builder overrides
- **Contextual Loading Messages**: Show specific loading text for different operations
- **Skeleton Loading**: Modern shimmer effects for better UX
- **Smart Retry Logic**: Configurable retry attempts with backoff
- **Snackbar Integration**: Non-intrusive error display options
- **Pull-to-Refresh**: Built-in refresh functionality
- **Auto-Pagination**: Debounced infinite scroll with auto-scroll triggers

### 🚀 **Production Ready**

- **Error Boundaries**: Graceful error handling with fallbacks
- **Performance Optimized**: Widget memoization and efficient state transitions
- **Accessibility**: WCAG compliant with proper semantics
- **Customization**: Simplified configuration with config objects and custom icons

## ⚡ Key Improvements

### 🎬 **Animation System**

- **Smooth Transitions**: Built-in fade, slide, and scale animations
- **Custom Animation Builders**: Create your own transition effects
- **Performance Optimized**: Animations don't interfere with widget rebuilds

### 🎯 **Simplified Configuration**

- **Icon Parameters**: Change icons without full builder overrides
- **Config Objects**: `SmartStateTextConfig` and `SmartStateWidgetConfig` for organized customization
- **Contextual Messages**: `customLoadingMessage` for operation-specific feedback

### ⚡ **Performance Enhancements**

- **Widget Memoization**: Prevents unnecessary rebuilds of expensive widgets
- **Debounced Pagination**: Prevents double-triggers on fast scrolling
- **Efficient State Transitions**: Optimized animation controllers and caching

### 🔧 **Developer Experience**

- **Removed Complexity**: No more `maxRetryAttempts` and `retryDelayDuration` (should be in controller layer)
- **Cleaner API**: Fewer overwhelming parameters with logical grouping
- **Better Debugging**: Enhanced debug logs with state transition tracking

## 🎯 Core Capabilities

### Basic State Handling

```dart
SmartStateHandler<List<Product>>(
  currentState: SmartState.success,
  successData: products,
  successDataBuilder: (context, data) => ProductGrid(products: data),
)
```

### Form Overlay Mode with Animations

```dart
SmartStateHandler<void>(
  currentState: formState,
  enableOverlayStates: true,
  enableAnimations: true,
  baseContentBuilder: (context) => MyForm(),
  overlayAlignment: Alignment.center,
  customLoadingMessage: 'Submitting your form...',

  // Custom transition
  animationConfig: SmartStateAnimationConfig(
    type: SmartStateTransitionType.scale,
    duration: Duration(milliseconds: 300),
  ),

  onRetryPressed: submitForm,
)
```

### Advanced Configuration with Animations

```dart
SmartStateHandler<List<Item>>(
  currentState: state,
  successData: data,
  errorObject: error,
  enablePullToRefresh: true,
  showErrorAsSnackbar: true,
  enableDebugLogs: kDebugMode,
  enableAnimations: true,

  // Animation configuration with overlay support
  animationConfig: SmartStateAnimationConfig(
    duration: Duration(milliseconds: 400),
    curve: Curves.easeInOutCubic,
    type: SmartStateTransitionType.fade, // fade, slide, slideUp, slideDown, slideLeft, slideRight, scale, rotate, bounce, elastic, none

    // Separate overlay animation settings
    overlayDuration: Duration(milliseconds: 300),
    overlayCurve: Curves.easeOut,
    overlayType: SmartStateTransitionType.scale, // Same options as main transitions
  ),

  // Custom icons (no need for full builders)
  errorIcon: Icons.error_outline_rounded,
  emptyIcon: Icons.inbox_outlined,
  loadingIcon: Icons.hourglass_top,

  // Contextual loading message
  customLoadingMessage: 'Uploading your files...',

  // Simplified text configuration
  textConfig: SmartStateTextConfig(
    retryButtonText: 'Try Again',
    loadingText: 'Please wait...',
    noDataFoundText: 'No items found',
  ),

  // Auto-pagination with debouncing
  autoScrollThreshold: 100.0,
  loadMoreDebounceMs: 300,

  onRetryPressed: retry,
  onPullToRefresh: refresh,
  onLoadMoreData: loadMore,
  successDataBuilder: (context, items) => ItemList(items),
)
```

## 🎭 Overlay Mode with Animations

SmartStateHandler supports overlay mode where states appear above your base content, perfect for forms and non-intrusive state changes. Overlay states now support their own animation configurations!

```dart
SmartStateHandler<String>(
  currentState: formState,
  enableOverlayStates: true,
  baseContentBuilder: (context) => MyFormWidget(),

  // Separate animation settings for overlays
  animationConfig: SmartStateAnimationConfig(
    // Main content transitions
    type: SmartStateTransitionType.fade,
    duration: Duration(milliseconds: 400),

    // Overlay-specific animations
    overlayType: SmartStateTransitionType.bounce,
    overlayDuration: Duration(milliseconds: 250),
    overlayCurve: Curves.elasticOut,
  ),

  // Custom overlay builders
  overlayLoadingBuilder: (context) => LoadingSpinner(),
  overlayErrorBuilder: (context, error) => ErrorDialog(error: error),
  overlaySuccessBuilder: (context) => SuccessCheckmark(),

  overlayAlignment: Alignment.center,
  overlayBackgroundColor: Colors.black.withOpacity(0.3),
)
```

## 🔌 State Management Integration

### With GetX

```dart
class DataController extends GetxController {
  final _state = SmartState.loading.obs;
  final _data = <Item>[].obs;

  SmartState get state => _state.value;
  List<Item> get data => _data;

  Future<void> loadData() async {
    _state.value = SmartState.loading;
    // API call...
    _state.value = SmartState.success;
  }
}

// In Widget
Obx(() => SmartStateHandler<List<Item>>(
  currentState: controller.state,
  successData: controller.data,
  onRetryPressed: controller.loadData,
  successDataBuilder: (context, data) => ItemList(data),
))
```

### With Provider

```dart
class DataProvider extends ChangeNotifier {
  SmartState _state = SmartState.loading;
  List<Item> _data = [];

  SmartState get state => _state;
  List<Item> get data => _data;

  Future<void> loadData() async {
    _state = SmartState.loading;
    notifyListeners();
    // API call...
  }
}

// In Widget
Consumer<DataProvider>(
  builder: (context, provider, _) => SmartStateHandler<List<Item>>(
    currentState: provider.state,
    successData: provider.data,
    onRetryPressed: provider.loadData,
    successDataBuilder: (context, data) => ItemList(data),
  ),
)
```

### With BLoC

```dart
// Convert BLoC states to SmartState
SmartState mapBlocState(DataState state) {
  return switch (state) {
    DataLoading() => SmartState.loading,
    DataError() => SmartState.error,
    DataEmpty() => SmartState.empty,
    DataLoaded() => SmartState.success,
  };
}

// In Widget
BlocBuilder<DataBloc, DataState>(
  builder: (context, state) => SmartStateHandler<List<Item>>(
    currentState: mapBlocState(state),
    successData: state is DataLoaded ? state.data : null,
    errorObject: state is DataError ? state.message : null,
    onRetryPressed: () => context.read<DataBloc>().add(LoadData()),
    successDataBuilder: (context, data) => ItemList(data),
  ),
)
```

## 🌐 Network & Connectivity Integration

### With connectivity_plus Package

```dart
class NetworkAwareController {
  SmartState _state = SmartState.loading;

  void checkConnectivity() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      _state = SmartState.offline;
    } else {
      await loadData();
    }
  }
}

SmartStateHandler<List<Data>>(
  currentState: controller.state,
  successData: controller.data,
  offlineStateBuilder: (context) => OfflineWidget(),
  onRetryPressed: controller.checkConnectivity,
  successDataBuilder: (context, data) => DataList(data),
)
```

### State Extensions for Clean Code

```dart
// Extension methods for readable code
if (state.isLoading) {
  // Handle loading
}

if (state.isError) {
  // Handle error
}

if (state.isInitial) {
  // Handle initial state
}
```

## 📦 Package Integrations

### With HTTP Packages (dio, http)

```dart
class ApiService {
  SmartState _state = SmartState.loading;

  Future<void> fetchData() async {
    try {
      _state = SmartState.loading;
      final response = await dio.get('/api/data');

      if (response.data.isEmpty) {
        _state = SmartState.empty;
      } else {
        _state = SmartState.success;
      }
    } catch (e) {
      _state = SmartState.error;
    }
  }
}
```

### With Caching (hive, shared_preferences)

```dart
class CachedDataController {
  Future<void> loadData() async {
    // Try cache first
    final cached = await getCachedData();
    if (cached != null) {
      _state = SmartState.success;
      _data = cached;
    } else {
      _state = SmartState.loading;
      await fetchFromNetwork();
    }
  }
}
```

### With Image Loading (cached_network_image)

```dart
SmartStateHandler<String>(
  currentState: imageState,
  successData: imageUrl,
  loadingStateBuilder: (context) => ShimmerPlaceholder(),
  errorStateBuilder: (context, error) => ErrorImageWidget(),
  successDataBuilder: (context, url) => CachedNetworkImage(imageUrl: url),
)
```

## 🎯 Use Cases & Scenarios

### Form Submissions

```dart
SmartStateHandler<void>(
  currentState: formState,
  enableOverlayStates: true,
  baseContentBuilder: (context) => MyForm(),
  onRetryPressed: submitForm,
)
```

### Data Lists with Pagination

```dart
SmartStateHandler<List<Item>>(
  currentState: state,
  successData: items,
  hasMoreDataToLoad: hasMore,
  onLoadMoreData: loadMore,
  enablePullToRefresh: true,
  onPullToRefresh: refresh,
  successDataBuilder: (context, items) => ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, index) => ItemCard(items[index]),
  ),
)
```

### Animation Showcase

```dart
// Fade transition (default)
SmartStateHandler<List<Item>>(
  animationConfig: SmartStateAnimationConfig(
    type: SmartStateTransitionType.fade,
    duration: Duration(milliseconds: 300),
  ),
  // ... other params
)

// Custom slide transition
SmartStateHandler<List<Item>>(
  customTransitionBuilder: (context, child, animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(1.0, 0.0), // Slide from right
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  },
  // ... other params
)

// Scale with bounce
SmartStateHandler<List<Item>>(
  animationConfig: SmartStateAnimationConfig(
    type: SmartStateTransitionType.scale,
    curve: Curves.bounceInOut,
    duration: Duration(milliseconds: 500),
  ),
  // ... other params
)
```

### E-commerce Product Lists

```dart
SmartStateHandler<List<Product>>(
  currentState: productState,
  successData: products,
  enablePullToRefresh: true,
  enableSkeletonLoading: true,
  skeletonLoadingBuilder: (context) => ProductListSkeleton(),
  emptyStateBuilder: (context) => NoProductsFound(),
  onPullToRefresh: refreshProducts,
  successDataBuilder: (context, products) => ProductGrid(products),
)
```

### Real-time Chat Messages

```dart
SmartStateHandler<List<Message>>(
  currentState: chatState,
  successData: messages,
  enablePullToRefresh: true,
  loadMoreIndicatorBuilder: (context) => ChatLoadingIndicator(),
  onLoadMoreData: loadOlderMessages,
  successDataBuilder: (context, messages) => ChatMessageList(messages),
)
```

## 🔧 Advanced Configuration

### Custom Error Handling

```dart
SmartStateHandler<List<Item>>(
  currentState: state,
  successData: items,
  errorObject: error,
  maxRetryAttempts: 5,
  retryDelayDuration: Duration(seconds: 3),
  showErrorAsSnackbar: true,
  errorStateBuilder: (context, error) => CustomErrorWidget(error),
  onRetryPressed: retry,
  successDataBuilder: (context, items) => ItemList(items),
)
```

### Performance Optimization

```dart
SmartStateHandler<List<Item>>(
  currentState: state,
  successData: items,
  enableDebugLogs: kDebugMode,
  containerBackgroundColor: Colors.grey[50],
  contentPadding: EdgeInsets.all(16),
  loadingIndicatorColor: Colors.blue,
  successDataBuilder: (context, items) => ItemList(items),
)
```

## 🧪 Testing Integration

```dart
testWidgets('SmartStateHandler shows loading state', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: SmartStateHandler<List<String>>(
        currentState: SmartState.loading,
        successDataBuilder: (context, data) => Text('Success'),
      ),
    ),
  );

  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});
```

## 🎨 Theming & Customization

### Custom Loading States

```dart
SmartStateHandler<List<Item>>(
  currentState: state,
  successData: items,
  loadingStateBuilder: (context) => CustomLoadingAnimation(),
  skeletonLoadingBuilder: (context) => ShimmerSkeleton(),
  enableSkeletonLoading: true,
  successDataBuilder: (context, items) => ItemList(items),
)
```

### Custom Empty States

```dart
SmartStateHandler<List<Item>>(
  currentState: state,
  successData: items,
  emptyStateBuilder: (context) => EmptyStateWidget(
    icon: Icons.inbox_outlined,
    title: 'No items found',
    subtitle: 'Try adjusting your search filters',
    actionButton: ElevatedButton(
      onPressed: clearFilters,
      child: Text('Clear Filters'),
    ),
  ),
  successDataBuilder: (context, items) => ItemList(items),
)
```

## 🔄 Migration Guide

### From Basic State Management

```dart
// Before: Manual state handling
bool isLoading = true;
bool hasError = false;
String? errorMessage;
List<Item>? data;

// After: SmartStateHandler
SmartState state = SmartState.loading;
List<Item>? data;
String? error;

SmartStateHandler<List<Item>>(
  currentState: state,
  successData: data,
  errorObject: error,
  successDataBuilder: (context, items) => ItemList(items),
)
```

## 🎯 Best Practices

### 1. Use Descriptive State Management

```dart
// ✅ Good
SmartState currentState = SmartState.loading;

// ❌ Avoid
bool isLoading = true;
bool hasError = false;
```

### 2. Handle All Possible States

```dart
SmartStateHandler<List<Item>>(
  currentState: state,
  successData: data,
  errorObject: error,
  loadingStateBuilder: (context) => CustomLoader(),
  errorStateBuilder: (context, error) => CustomError(error),
  emptyStateBuilder: (context) => CustomEmpty(),
  successDataBuilder: (context, items) => ItemList(items),
)
```

### 3. Enable Debug Mode in Development

```dart
SmartStateHandler<List<Item>>(
  enableDebugLogs: kDebugMode, // ✅ Enable in development
  currentState: state,
  successData: data,
  successDataBuilder: (context, items) => ItemList(items),
)
```

---

**SmartStateHandler** makes Flutter state management more professional, maintainable, and developer-friendly! 🚀
