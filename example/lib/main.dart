import 'package:flutter/material.dart';
import 'package:smart_state_handler/smart_state_handler.dart';

/// Complete runnable example for SmartStateHandler package
///
/// This example demonstrates ALL FEATURES including v1.0.2 updates:
/// ✨ Dismissible overlays with custom styling
/// 🎯 Top/bottom positioned snackbars with actions
/// 🎨 Per-state overlay customization
/// 📱 Selective overlay states (show overlay only for specific states)
/// 🔄 Pull-to-refresh with smart configurations
/// 📄 Pagination with debouncing (300ms)
/// 🎭 Multiple animation transitions
/// 💾 SmartStateCache for data caching
/// ⚡ SmartStateMemoization for performance
/// 🔄 SmartStateKeepAlive for list optimization
/// 💡 Smart defaults with easy customization
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
/// NOW WITH v1.0.2 Performance Features:
/// - SmartStateCache for efficient data caching
/// - SmartStateMemoization for preventing rebuilds
/// - SmartStateKeepAlive for list state preservation

class SmartStateHandlerExample extends StatefulWidget {
  const SmartStateHandlerExample({super.key});

  @override
  State<SmartStateHandlerExample> createState() =>
      _SmartStateHandlerExampleState();
}

class _SmartStateHandlerExampleState extends State<SmartStateHandlerExample>
    with SmartStateMemoization {
  SmartState _currentState = SmartState.initial;
  List<String> _data = [];
  String? _error;
  bool _hasMoreData = true;
  bool _enableOverlayMode = false;
  bool _enableSnackbar = false;
  bool _snackbarAtTop = true;
  bool _dismissibleOverlay = true;
  SmartStateTransitionType _transitionType = SmartStateTransitionType.fade;
  SmartStateTransitionType _overlayTransitionType =
      SmartStateTransitionType.scale;

  // Form-related state for overlay demo
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _scrollController = ScrollController();

  // 💾 NEW v1.0.2: Cache utility for efficient data management
  final _dataCache = SmartStateCache<String, List<String>>(maxSize: 50);

  @override
  void initState() {
    super.initState();
    // Start with initial state - user can trigger loading manually

    // Check if we have cached data
    final cachedData = _dataCache.get('main_data');
    if (cachedData != null) {
      setState(() {
        _data = cachedData;
        _currentState = SmartState.success;
      });
    }
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

      // 💾 NEW v1.0.2: Cache the data
      _dataCache.put('main_data', _data);
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

      // 💾 NEW v1.0.2: Update cache with new data
      _dataCache.put('main_data', _data);

      // Simulate end of data after 20 items
      if (_data.length >= 20) {
        _hasMoreData = false;
      }
    });
  }

  /// Show control panel in a modal bottom sheet
  void _showControlPanel(BuildContext context, VoidCallback onStateChanged) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => StatefulBuilder(
          builder: (context, setState) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Handle
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 0.5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.settings, color: Colors.deepPurple),
                      const SizedBox(width: 12),
                      const Text(
                        'Demo Controls',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    child: // Mode toggle section
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
                                _enableOverlayMode
                                    ? Icons.layers
                                    : Icons.view_stream,
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
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
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
                                  _enableOverlayMode = value;
                                  if (value) {
                                    _currentState = SmartState.initial;
                                    _data.clear();
                                    _error = null;
                                    _nameController.clear();
                                    _emailController.clear();
                                  }
                                  onStateChanged();
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // 🎯 NEW FEATURE: Error Display Toggle
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.blue.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _enableSnackbar
                                      ? Icons.info_outline
                                      : Icons.error_outline,
                                  color: _enableSnackbar
                                      ? Colors.blue
                                      : Colors.red,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Error Display Style',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        _enableSnackbar
                                            ? 'Showing as Snackbar'
                                            : 'Showing as Full Screen',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Switch(
                                  value: _enableSnackbar,
                                  onChanged: (value) {
                                    _enableSnackbar = value;
                                    onStateChanged();
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                          ),

                          if (_enableSnackbar) ...[
                            const SizedBox(height: 12),
                            // 📍 NEW FEATURE: Snackbar Position Toggle
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.green.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _snackbarAtTop
                                        ? Icons.vertical_align_top
                                        : Icons.vertical_align_bottom,
                                    color: Colors.green,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Snackbar Position',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                        Text(
                                          _snackbarAtTop
                                              ? 'Showing at Top'
                                              : 'Showing at Bottom',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Switch(
                                    value: _snackbarAtTop,
                                    onChanged: (value) {
                                      _snackbarAtTop = value;
                                      onStateChanged();
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],

                          if (_enableOverlayMode) ...[
                            const SizedBox(height: 12),
                            // 🚪 NEW FEATURE: Dismissible Overlay Toggle
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.orange.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.orange.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _dismissibleOverlay
                                        ? Icons.touch_app
                                        : Icons.block,
                                    color: Colors.orange,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Dismissible Overlay',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                        Text(
                                          _dismissibleOverlay
                                              ? 'Tap to dismiss'
                                              : 'Cannot dismiss',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Switch(
                                    value: _dismissibleOverlay,
                                    onChanged: (value) {
                                      _dismissibleOverlay = value;
                                      onStateChanged();
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],

                          const SizedBox(height: 12),
                          // Animation controls
                          if (!_enableOverlayMode) ...[
                            Row(
                              children: [
                                const Icon(Icons.animation,
                                    color: Colors.purple),
                                const SizedBox(width: 8),
                                Expanded(
                                  child:
                                      DropdownButton<SmartStateTransitionType>(
                                    value: _transitionType,
                                    isExpanded: true,
                                    onChanged:
                                        (SmartStateTransitionType? newValue) {
                                      if (newValue != null) {
                                        _transitionType = newValue;
                                        onStateChanged();
                                        setState(() {});
                                      }
                                    },
                                    items: SmartStateTransitionType.values.map<
                                        DropdownMenuItem<
                                            SmartStateTransitionType>>((
                                      SmartStateTransitionType value,
                                    ) {
                                      return DropdownMenuItem<
                                          SmartStateTransitionType>(
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
                                const Icon(Icons.layers, color: Colors.purple),
                                const SizedBox(width: 8),
                                Expanded(
                                  child:
                                      DropdownButton<SmartStateTransitionType>(
                                    value: _overlayTransitionType,
                                    isExpanded: true,
                                    onChanged:
                                        (SmartStateTransitionType? newValue) {
                                      if (newValue != null) {
                                        _overlayTransitionType = newValue;
                                        onStateChanged();
                                        setState(() {});
                                      }
                                    },
                                    items: SmartStateTransitionType.values.map<
                                        DropdownMenuItem<
                                            SmartStateTransitionType>>((
                                      SmartStateTransitionType value,
                                    ) {
                                      return DropdownMenuItem<
                                          SmartStateTransitionType>(
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
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => _showControlPanel(context, () => setState(() {})),
        ),
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
              showErrorAsSnackbar: _enableSnackbar,
              enableAnimations: true,
              overlayBackgroundColor: Colors.black.withValues(alpha: 0.3),
              overlayAlignment: Alignment.center,
              autoScrollThreshold: 100.0,
              loadMoreDebounceMs: 300,

              // 🎨 NEW: Overlay Configuration with dismissible options
              overlayConfig: SmartStateOverlayConfig(
                isDismissible: _dismissibleOverlay,
                barrierDismissible: _dismissibleOverlay,
                barrierColor: _enableOverlayMode
                    ? Colors.black.withValues(alpha: 0.6)
                    : Colors.black.withValues(alpha: 0.3),

                // Customize loading overlay
                loadingConfig: OverlayStateConfig(
                  backgroundColor: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(20),
                  padding: const EdgeInsets.all(32),
                  elevation: 12.0,
                  iconColor: Colors.blue,
                  textColor: Colors.black87,
                  iconSize: 48.0,
                  maxWidth: 300.0,
                ),

                // Customize error overlay
                errorConfig: OverlayStateConfig(
                  backgroundColor: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  padding: const EdgeInsets.all(32),
                  elevation: 16.0,
                  iconColor: Colors.red.shade700,
                  textColor: Colors.black87,
                  iconSize: 64.0,
                  maxWidth: 320.0,
                ),

                // Customize success overlay
                successConfig: OverlayStateConfig(
                  backgroundColor: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  padding: const EdgeInsets.all(32),
                  elevation: 12.0,
                  iconColor: Colors.green.shade600,
                  textColor: Colors.black87,
                  iconSize: 64.0,
                  maxWidth: 300.0,
                ),
              ),

              // 🎯 NEW: Snackbar Configuration with top/bottom positioning
              snackbarConfig: SmartStateSnackbarConfig(
                position: _snackbarAtTop
                    ? SnackbarPosition.top
                    : SnackbarPosition.bottom,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 4),
                showCloseIcon: true,
                margin: const EdgeInsets.all(16),
                errorConfig: SnackbarStateConfig(
                  backgroundColor: Colors.red.shade700,
                  textColor: Colors.white,
                  icon: Icons.error_outline_rounded,
                  iconSize: 24.0,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  borderRadius: BorderRadius.circular(12),
                  elevation: 8.0,
                  action: SnackBarAction(
                    label: 'RETRY',
                    textColor: Colors.white,
                    onPressed: () => _simulateDataLoading(isRefresh: true),
                  ),
                ),
                successConfig: SnackbarStateConfig(
                  backgroundColor: Colors.green.shade700,
                  textColor: Colors.white,
                  icon: Icons.check_circle_outline_rounded,
                  iconSize: 24.0,
                  fontSize: 15.0,
                  borderRadius: BorderRadius.circular(12),
                  elevation: 8.0,
                ),
              ),

              // Callback when overlay is dismissed
              onOverlayDismiss: () {
                if (_dismissibleOverlay) {
                  setState(() => _currentState = SmartState.initial);
                }
              },

              // Animation configuration
              animationConfig: SmartStateAnimationConfig(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOutCubic,
                type: _transitionType,
                overlayDuration: const Duration(milliseconds: 350),
                overlayCurve: Curves.easeOutBack,
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
                // ⚡ NEW v1.0.2: Memoize list building for performance
                return memoize(
                  'data-list',
                  () => NotificationListener<ScrollNotification>(
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
                        if (_currentState.isLoadingMore &&
                            index == data.length) {
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
                          return const SizedBox.shrink();
                        }

                        // 🔄 NEW v1.0.2: Use SmartStateKeepAlive for list optimization
                        return SmartStateKeepAlive(
                          keepAlive: true,
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            child: ListTile(
                              leading:
                                  CircleAvatar(child: Text('${index + 1}')),
                              title: Text(data[index]),
                              subtitle: Text('Subtitle for ${data[index]}'),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Tapped ${data[index]}'),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  [data.length, _currentState, _hasMoreData],
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
      child: Container(
        width: double.infinity,
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
                  Icons.science_outlined,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _enableOverlayMode
                      ? 'Test Form States:'
                      : 'Test List States:',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
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
          ],
        ),
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

/// Example with GetX Controller + v1.0.2 Performance Features
/// Uncomment if you're using GetX
/*
class ProductController extends GetxController with SmartStateMemoization {
  final _state = SmartState.loading.obs;
  final _products = <Product>[].obs;
  final _error = RxnString();
  final _hasMoreData = true.obs;
  
  // 💾 NEW v1.0.2: Use cache for efficient data management
  final _cache = SmartStateCache<String, List<Product>>(maxSize: 100);

  SmartState get state => _state.value;
  List<Product> get products => _products;
  String? get error => _error.value;
  bool get hasMoreData => _hasMoreData.value;

  Future<void> fetchProducts({bool refresh = false}) async {
    try {
      if (refresh) {
        _state.value = SmartState.loading;
        _products.clear();
      } else {
        // 💾 Check cache first
        final cached = _cache.get('products');
        if (cached != null && cached.isNotEmpty) {
          _products.value = cached;
          _state.value = SmartState.success;
          return;
        }
      }
      
      // Your API call here
      final newProducts = await ApiService.getProducts();
      
      if (newProducts.isEmpty) {
        _state.value = SmartState.empty;
      } else {
        _products.value = newProducts;
        _state.value = SmartState.success;
        
        // 💾 Cache the result
        _cache.put('products', newProducts);
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
        
        // 💾 Update cache
        _cache.put('products', _products);
      }
      
      _state.value = SmartState.success;
    } catch (e) {
      _state.value = SmartState.success; // Keep current data visible
      // Handle pagination error separately if needed
    }
  }
  
  @override
  void onClose() {
    // 💾 Optionally clear cache on dispose
    _cache.clear();
    super.onClose();
  }
}

// Usage in Widget with memoization
class ProductsPage extends StatelessWidget {
  final ProductController controller = Get.put(ProductController());
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => SmartStateHandler<List<Product>>(
        currentState: controller.state,
        successData: controller.products.isNotEmpty ? controller.products : null,
        errorObject: controller.error,
        hasMoreDataToLoad: controller.hasMoreData,
        
        // ⚡ NEW v1.0.2: Performance configurations
        loadMoreDebounceMs: 300,  // Debounce pagination
        enableDebugLogs: true,    // See cache/debounce in action
        
        onRetryPressed: () => controller.fetchProducts(refresh: true),
        onPullToRefresh: () => controller.fetchProducts(refresh: true),
        onLoadMoreData: controller.loadMore,
        
        successDataBuilder: (context, products) {
          // ⚡ Use memoization for expensive widgets
          return controller.memoize(
            'product-grid',
            () => GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                // 🔄 NEW v1.0.2: KeepAlive for grid items
                return SmartStateKeepAlive(
                  child: ProductCard(products[index]),
                );
              },
            ),
            [products.length], // Rebuild only when count changes
          );
        },
      )),
    );
  }
}
*/

/// Example with Provider + v1.0.2 Performance Features
/// Uncomment if you're using Provider
/*
class ProductProvider extends ChangeNotifier with SmartStateMemoization {
  SmartState _state = SmartState.loading;
  List<Product> _products = [];
  String? _error;
  bool _hasMoreData = true;
  
  // 💾 NEW v1.0.2: Add cache
  final _cache = SmartStateCache<String, List<Product>>(maxSize: 100);

  SmartState get state => _state;
  List<Product> get products => _products;
  String? get error => _error;
  bool get hasMoreData => _hasMoreData;

  Future<void> fetchProducts({bool refresh = false}) async {
    try {
      if (!refresh) {
        // 💾 Check cache first
        final cached = _cache.get('products');
        if (cached != null && cached.isNotEmpty) {
          _products = cached;
          _state = SmartState.success;
          notifyListeners();
          return;
        }
      }
      
      _state = SmartState.loading;
      notifyListeners();
      
      final newProducts = await ApiService.getProducts();
      
      if (newProducts.isEmpty) {
        _state = SmartState.empty;
      } else {
        _products = newProducts;
        _state = SmartState.success;
        
        // 💾 Cache the data
        _cache.put('products', newProducts);
      }
    } catch (e) {
      _error = e.toString();
      _state = SmartState.error;
    }
    notifyListeners();
  }
  
  @override
  void dispose() {
    // 💾 Clean up cache
    _cache.clear();
    clearMemoCache(); // Clear memoization cache
    super.dispose();
  }
}
*/

/// v1.0.2 Performance Tips:
///
/// 1. Use SmartStateCache for data caching:
///    - Reduces API calls
///    - Improves perceived performance
///    - Automatic LRU cleanup
///
/// 2. Use SmartStateMemoization to prevent rebuilds:
///    - Memoize expensive widget builders
///    - Only rebuild when dependencies change
///    - Clear cache when needed with clearMemoCache()
///
/// 3. Use SmartStateKeepAlive in lists:
///    - Preserves widget state when scrolling
///    - Better for forms and interactive items
///    - Reduces unnecessary rebuilds
///
/// 4. Use const constructors for configs:
///    static const _textConfig = SmartStateTextConfig(...);
///    Enables Flutter optimizations
///
/// 5. Enable debouncing for pagination:
///    loadMoreDebounceMs: 300 (prevents rapid-fire requests)
