import 'package:flutter/material.dart';
import 'package:smart_state_handler/smart_state_handler.dart';

/// Complete runnable example for SmartStateHandler package
///
/// This example demonstrates:
/// - Basic list state handling with loading/error/success/empty
/// - Pull-to-refresh functionality
/// - Pagination with loading more data
/// - Overlay mode for form submissions
/// - Smooth animations between states
/// - Custom error and empty state builders
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartStateHandler Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SmartStateHandlerExample(),
    );
  }
}

/// Example demonstrating enhanced SmartStateHandler features
/// Shows animations, memoization, custom icons, and improved configurations

class SmartStateHandlerExample extends StatefulWidget {
  const SmartStateHandlerExample({super.key});

  @override
  State<SmartStateHandlerExample> createState() =>
      _SmartStateHandlerExampleState();
}

class _SmartStateHandlerExampleState extends State<SmartStateHandlerExample> {
  SmartState _currentState = SmartState.initial;
  List<String> _data = [];
  String? _error;
  bool _hasMoreData = true;
  bool _enableOverlayMode = false;
  SmartStateTransitionType _transitionType = SmartStateTransitionType.fade;
  SmartStateTransitionType _overlayTransitionType =
      SmartStateTransitionType.scale;

  // Form-related state for overlay demo
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Start with initial state - user can trigger loading manually
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Simulate form submission with different outcomes
  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _currentState = SmartState.loading;
        _error = null;
      });

      await Future.delayed(const Duration(seconds: 2));

      // Simulate different outcomes
      final outcomes = [
        () => setState(() => _currentState = SmartState.success),
        () => setState(() {
              _currentState = SmartState.error;
              _error = 'Form submission failed. Please try again.';
            }),
      ];

      final randomIndex = DateTime.now().millisecond % outcomes.length;
      outcomes[randomIndex]();

      // Auto-dismiss success after 3 seconds
      if (_currentState.isSuccess) {
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted && _currentState.isSuccess) {
            setState(() => _currentState = SmartState.initial);
          }
        });
      }
    }
  }

  /// Simulate API call with different outcomes
  Future<void> _simulateDataLoading({
    bool isRefresh = false,
    bool isLoadMore = false,
  }) async {
    if (!isLoadMore) {
      setState(() {
        _currentState = SmartState.loading;
        if (isRefresh) {
          _data.clear();
          _hasMoreData = true;
        }
        _error = null;
      });
    }

    await Future.delayed(const Duration(seconds: 2));

    // Simulate different scenarios randomly
    final scenarios = [
      () => _simulateSuccess(),
      () => _simulateError(),
      () => _simulateEmpty(),
      () => _simulateOffline(),
    ];

    final randomIndex = DateTime.now().millisecond % scenarios.length;
    scenarios[randomIndex]();
  }

  void _simulateSuccess() {
    setState(() {
      _data = List.generate(10, (index) => 'Item ${index + 1}');
      _currentState = SmartState.success;
      _error = null;
    });
  }

  void _simulateError() {
    setState(() {
      _currentState = SmartState.error;
      _error = 'Failed to fetch data from server';
    });
  }

  void _simulateEmpty() {
    setState(() {
      _data = [];
      _currentState = SmartState.empty;
      _error = null;
    });
  }

  void _simulateOffline() {
    setState(() {
      _currentState = SmartState.offline;
      _error = null;
    });
  }

  /// Simulate loading more data for pagination
  Future<void> _loadMoreData() async {
    if (!_hasMoreData) return;

    setState(() {
      _currentState = SmartState.loadingMore;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      final newItems = List.generate(
        5,
        (index) => 'Item ${_data.length + index + 1}',
      );
      _data.addAll(newItems);
      _currentState = SmartState.success;

      // Simulate end of data after 20 items
      if (_data.length >= 20) {
        _hasMoreData = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartStateHandler Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _simulateDataLoading(isRefresh: true),
          ),
        ],
      ),
      body: Column(
        children: [
          // Control buttons for testing different states
          _buildControlPanel(),

          // Main content with SmartStateHandler
          Expanded(
            child: SmartStateHandler<List<String>>(
              currentState: _currentState,
              successData: _data.isNotEmpty ? _data : null,
              errorObject: _error,
              hasMoreDataToLoad: _hasMoreData,
              enableDebugLogs: true,
              enableOverlayStates: _enableOverlayMode,
              enableAnimations: true,
              overlayBackgroundColor: Colors.black.withValues(alpha: 0.3),
              overlayAlignment: Alignment.center,
              autoScrollThreshold: 100.0,
              loadMoreDebounceMs: 300,

              // Animation configuration
              animationConfig: SmartStateAnimationConfig(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOutCubic,
                type: _transitionType,
                overlayDuration: const Duration(milliseconds: 300),
                overlayCurve: Curves.easeOut,
                overlayType: _overlayTransitionType,
              ),

              // Custom icons for better UX
              errorIcon: Icons.error_outline_rounded,
              emptyIcon: Icons.inbox_outlined,
              offlineIcon: Icons.wifi_off_rounded,
              loadingIcon: Icons.hourglass_top_rounded,

              // Custom loading message
              customLoadingMessage: _enableOverlayMode
                  ? 'Submitting your form...'
                  : 'Loading awesome data...',

              // Text configuration
              textConfig: const SmartStateTextConfig(
                retryButtonText: 'Try Again',
                noDataFoundText: 'No items found',
                loadingText: 'Please wait...',
                offlineConnectionText: 'Check your internet connection',
              ),

              // Callbacks
              onRetryPressed: _enableOverlayMode
                  ? _submitForm
                  : () => _simulateDataLoading(isRefresh: true),
              onPullToRefresh: () => _simulateDataLoading(isRefresh: true),
              onLoadMoreData: _loadMoreData,

              // Base content for overlay mode (persistent form)
              baseContentBuilder:
                  _enableOverlayMode ? (context) => _buildFormContent() : null,

              // Initial state builder for non-overlay mode
              initialStateBuilder: _enableOverlayMode
                  ? null
                  : (context) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.touch_app,
                                size: 64,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Welcome to SmartStateHandler Demo!',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Click "Load Data" to begin or try different states using the buttons above.',
                                style: Theme.of(context).textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: () => _simulateDataLoading(),
                                icon: const Icon(Icons.download),
                                label: const Text('Load Data'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },

              // Custom overlay builders for better UX
              overlayLoadingBuilder: (context) => Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(color: Colors.white),
                    const SizedBox(height: 12),
                    Text(
                      _enableOverlayMode
                          ? 'Submitting form...'
                          : 'Loading data...',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),

              overlayErrorBuilder: (context, error) => Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.white,
                      size: 40,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      error?.toString() ?? 'An error occurred',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _enableOverlayMode
                          ? _submitForm
                          : () => _simulateDataLoading(isRefresh: true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ),

              overlaySuccessBuilder: (context) => Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                      size: 40,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _enableOverlayMode
                          ? 'Form submitted successfully!'
                          : 'Data loaded successfully!',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Main data builder for non-overlay mode
              successDataBuilder: (context, data) {
                return NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    // Auto-load more when near bottom
                    if (scrollInfo.metrics.pixels >=
                        scrollInfo.metrics.maxScrollExtent - 200) {
                      if (_hasMoreData &&
                          _currentState != SmartState.loadingMore) {
                        _loadMoreData();
                      }
                    }
                    return false;
                  },
                  child: ListView.builder(
                    key: const PageStorageKey('data_list'),
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8),
                    itemCount: data.length +
                        (_currentState.isLoadingMore ? 1 : 0) +
                        (!_hasMoreData && data.isNotEmpty ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Show loading indicator
                      if (_currentState.isLoadingMore && index == data.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      // Show no more data message
                      if (!_hasMoreData &&
                          data.isNotEmpty &&
                          index ==
                              data.length +
                                  (_currentState.isLoadingMore ? 1 : 0)) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: Text(
                              'No more data to load',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        );
                      }

                      // Show regular item - ensure index is within data bounds
                      if (index >= data.length) {
                        return const SizedBox
                            .shrink(); // Return empty widget for invalid indices
                      }

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(child: Text('${index + 1}')),
                          title: Text(data[index]),
                          subtitle: Text('Subtitle for ${data[index]}'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Tapped ${data[index]}')),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },

              // Custom builders for different states
              loadingStateBuilder: (context) => const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading amazing content...'),
                  ],
                ),
              ),

              errorStateBuilder: (context, error) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Oops! Something went wrong',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => _simulateDataLoading(isRefresh: true),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                    ),
                  ],
                ),
              ),

              emptyStateBuilder: (context) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.inbox_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No items found',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Try refreshing or check back later',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => _simulateDataLoading(isRefresh: true),
                      child: const Text('Refresh'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds form content for overlay mode demonstration
  Widget _buildFormContent() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Contact Form Demo',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'This form demonstrates overlay states. Submit to see loading/error/success overlays.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Name field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email field
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Submit button
              ElevatedButton.icon(
                onPressed: _currentState.isLoading ? null : _submitForm,
                icon: const Icon(Icons.send),
                label: Text(
                  _currentState.isLoading ? 'Submitting...' : 'Submit Form',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),

              const SizedBox(height: 16),

              // Info text
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue[700],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Overlay Mode Demo',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'In overlay mode, this form stays visible while loading/error/success states appear as overlays above it. Try submitting the form to see the effect!',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[100],
      child: Column(
        children: [
          // Mode toggle section
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      _enableOverlayMode ? Icons.layers : Icons.view_stream,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _enableOverlayMode
                                ? 'Overlay Mode (Form Demo)'
                                : 'Normal Mode (List Demo)',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            _enableOverlayMode
                                ? 'States appear as overlays above the form'
                                : 'States replace the entire content area',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _enableOverlayMode,
                      onChanged: (value) {
                        setState(() {
                          _enableOverlayMode = value;
                          _currentState = SmartState.initial;
                          _data.clear();
                          _error = null;
                          _nameController.clear();
                          _emailController.clear();
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Animation controls
                if (!_enableOverlayMode) ...[
                  Row(
                    children: [
                      const Icon(Icons.animation, color: Colors.purple),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButton<SmartStateTransitionType>(
                          value: _transitionType,
                          isExpanded: true,
                          onChanged: (SmartStateTransitionType? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _transitionType = newValue;
                              });
                            }
                          },
                          items: SmartStateTransitionType.values
                              .map<DropdownMenuItem<SmartStateTransitionType>>((
                            SmartStateTransitionType value,
                          ) {
                            return DropdownMenuItem<SmartStateTransitionType>(
                              value: value,
                              child: Text(
                                '${value.name.toUpperCase()} Animation',
                                style: const TextStyle(fontSize: 14),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
                // Overlay Animation controls
                if (_enableOverlayMode) ...[
                  Row(
                    children: [
                      const Icon(Icons.layers, color: Colors.orange),
                      const SizedBox(width: 8),
                      Expanded(
                        child: DropdownButton<SmartStateTransitionType>(
                          value: _overlayTransitionType,
                          isExpanded: true,
                          onChanged: (SmartStateTransitionType? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _overlayTransitionType = newValue;
                              });
                            }
                          },
                          items: SmartStateTransitionType.values
                              .map<DropdownMenuItem<SmartStateTransitionType>>((
                            SmartStateTransitionType value,
                          ) {
                            return DropdownMenuItem<SmartStateTransitionType>(
                              value: value,
                              child: Text(
                                'OVERLAY ${value.name.toUpperCase()}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),

          // State testing buttons
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              children: [
                Text(
                  _enableOverlayMode
                      ? 'Test Form States:'
                      : 'Test List States:',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildStateButton(
                      'Initial',
                      SmartState.initial,
                      Colors.grey,
                    ),
                    _buildStateButton(
                      'Loading',
                      SmartState.loading,
                      Colors.blue,
                    ),
                    _buildStateButton(
                      'Success',
                      SmartState.success,
                      Colors.green,
                    ),
                    _buildStateButton('Error', SmartState.error, Colors.red),
                    if (!_enableOverlayMode) ...[
                      _buildStateButton(
                        'Empty',
                        SmartState.empty,
                        Colors.orange,
                      ),
                      _buildStateButton(
                        'Offline',
                        SmartState.offline,
                        Colors.purple,
                      ),
                    ],
                  ],
                ),
                if (_enableOverlayMode) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Tip: Fill out the form and click "Submit Form" to see realistic overlay behavior!',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStateButton(String label, SmartState state, Color color) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _currentState = state;
          switch (state) {
            case SmartState.initial:
              _data.clear();
              _error = null;
              break;
            case SmartState.loading:
              if (label == 'Load Data') {
                _simulateDataLoading();
              } else {
                // Just set loading state without simulation for testing
                _error = null;
              }
              break;
            case SmartState.success:
              _simulateSuccess();
              break;
            case SmartState.error:
              _simulateError();
              break;
            case SmartState.empty:
              _simulateEmpty();
              break;
            case SmartState.offline:
              _simulateOffline();
              break;
            case SmartState.loadingMore:
              // Simulate loading more data
              _loadMoreData();
              break;
          }
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      ),
      child: Text(label, style: const TextStyle(fontSize: 10)),
    );
  }
}

/// Example with GetX Controller
/// Uncomment if you're using GetX
/*
class ProductController extends GetxController {
  final _state = SmartState.loading.obs;
  final _products = <Product>[].obs;
  final _error = RxnString();
  final _hasMoreData = true.obs;

  SmartState get state => _state.value;
  List<Product> get products => _products;
  String? get error => _error.value;
  bool get hasMoreData => _hasMoreData.value;

  Future<void> fetchProducts({bool refresh = false}) async {
    try {
      if (refresh) {
        _state.value = SmartState.loading;
        _products.clear();
      }
      
      // Your API call here
      final newProducts = await ApiService.getProducts();
      
      if (newProducts.isEmpty) {
        _state.value = SmartState.empty;
      } else {
        _products.addAll(newProducts);
        _state.value = SmartState.success;
      }
    } catch (e) {
      _error.value = e.toString();
      _state.value = SmartState.error;
    }
  }

  Future<void> loadMore() async {
    if (!_hasMoreData.value) return;
    
    try {
      _state.value = SmartState.loadingMore;
      final newProducts = await ApiService.getProducts(page: _products.length ~/ 10 + 1);
      
      if (newProducts.isEmpty) {
        _hasMoreData.value = false;
      } else {
        _products.addAll(newProducts);
      }
      
      _state.value = SmartState.success;
    } catch (e) {
      _state.value = SmartState.success; // Keep current data visible
      // Handle pagination error separately if needed
    }
  }
}

// Usage in Widget
class ProductsPage extends StatelessWidget {
  final ProductController controller = Get.put(ProductController());
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => SmartStateHandler<List<Product>>(
        state: controller.state,
        data: controller.products.isNotEmpty ? controller.products : null,
        error: controller.error,
        hasMoreData: controller.hasMoreData,
        onRetry: () => controller.fetchProducts(refresh: true),
        onRefresh: () => controller.fetchProducts(refresh: true),
        onLoadMore: controller.loadMore,
        builder: (context, products) => ProductGrid(products: products),
      )),
    );
  }
}
*/
