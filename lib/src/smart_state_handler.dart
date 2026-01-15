import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:smart_state_handler/smart_state_handler.dart';

/// A comprehensive state management widget that handles all common UI states
/// with enhanced developer experience and flexible customization options.
///
/// This StatelessWidget provides a clean, predictable way to handle multiple
/// UI states with animations, memoization, and efficient rebuilds.
///
/// Features:
/// - Multiple state handling (initial, loading, error, empty, success, offline)
/// - Smooth animations between state transitions
/// - Memoized widgets to prevent unnecessary rebuilds
/// - Pagination support with auto-scroll and debounced loading
/// - Skeleton loading with shimmer support
/// - Overlay mode for forms and non-intrusive state changes
/// - Customizable icons, text, and widgets
/// - Debug mode with comprehensive logging
/// - Pull-to-refresh functionality
/// - Error handling with snackbar integration
///
/// Example:
/// ```dart
/// SmartStateHandler<List<Product>>(
///   currentState: controller.state,
///   successData: controller.products,
///   onRetryPressed: controller.retry,
///   onPullToRefresh: controller.refresh,
///   onLoadMoreData: controller.loadMore,
///   successDataBuilder: (context, products) => ProductGrid(products),
/// )
/// ```
class SmartStateHandler<T> extends StatelessWidget {
  const SmartStateHandler({
    super.key,
    required this.currentState,
    this.successData,
    this.errorObject,
    this.successDataBuilder,
    this.onRetryPressed,
    this.onPullToRefresh,
    this.onLoadMoreData,

    // Custom Widget Builders - Build your own UI for each state
    this.initialStateBuilder,
    this.loadingStateBuilder,
    this.errorStateBuilder,
    this.emptyStateBuilder,
    this.offlineStateBuilder,
    this.skeletonLoadingBuilder,

    // Overlay State Configuration for Forms
    this.enableOverlayStates = false,
    this.baseContentBuilder,
    this.overlayLoadingBuilder,
    this.overlayErrorBuilder,
    this.overlaySuccessBuilder,
    this.overlayAlignment = Alignment.center,
    this.overlayBackgroundColor,

    // Pagination Configuration
    this.hasMoreDataToLoad = true,
    this.paginationErrorObject,
    this.paginationErrorStateBuilder,
    this.loadMoreIndicatorBuilder,
    this.noMoreDataIndicatorBuilder,
    this.autoScrollThreshold = 100.0,
    this.loadMoreDebounceMs = 300,

    // UI Behavior Configuration
    this.enablePullToRefresh = true,
    this.enableSkeletonLoading = false,
    this.showErrorAsSnackbar = false,
    this.enableDebugLogs = false,
    this.enableAnimations = true,

    // Animation Configuration
    this.animationConfig = const SmartStateAnimationConfig(),
    this.customTransitionBuilder,

    // Overlay Configuration (NEW!)
    this.overlayConfig = const SmartStateOverlayConfig(),
    this.onOverlayDismiss,

    // Snackbar Configuration (NEW!)
    this.snackbarConfig = const SmartStateSnackbarConfig(),

    // Icon Configuration
    this.errorIcon = Icons.error_outline,
    this.emptyIcon = Icons.inbox_outlined,
    this.offlineIcon = Icons.wifi_off_outlined,
    this.loadingIcon,

    // Text and Widget Configuration
    this.textConfig = const SmartStateTextConfig(),
    this.widgetConfig = const SmartStateWidgetConfig(),
    this.customLoadingMessage,

    // Styling Configuration
    this.loadingIndicatorColor,
    this.errorDisplayColor,
    this.containerBackgroundColor,
    this.contentPadding,
    this.contentMargin,
  });

  /// The current state that determines which UI to show
  final SmartState currentState;

  /// Data to display when currentState is success
  final T? successData;

  /// Error information when currentState is error
  final dynamic errorObject;

  /// Builder function that creates UI when data is successfully loaded
  final Widget Function(BuildContext context, T data)? successDataBuilder;

  /// Callback executed when user presses retry button
  final VoidCallback? onRetryPressed;

  /// Callback executed when user pulls down to refresh
  final Future<void> Function()? onPullToRefresh;

  /// Callback executed when user scrolls near bottom for pagination
  final Future<void> Function()? onLoadMoreData;

  // Custom Widget Builders for Complete UI Control

  /// Custom builder for initial state UI
  final WidgetBuilder? initialStateBuilder;

  /// Custom builder for loading state UI
  final WidgetBuilder? loadingStateBuilder;

  /// Custom builder for error state UI
  final Widget Function(BuildContext context, dynamic errorObject)?
      errorStateBuilder;

  /// Custom builder for empty state UI
  final WidgetBuilder? emptyStateBuilder;

  /// Custom builder for offline state UI
  final WidgetBuilder? offlineStateBuilder;

  /// Custom builder for skeleton loading UI
  final WidgetBuilder? skeletonLoadingBuilder;

  // Overlay State Configuration

  /// Enable overlay mode where states appear above base content
  final bool enableOverlayStates;

  /// Builder for base content in overlay mode
  final WidgetBuilder? baseContentBuilder;

  /// Custom builder for overlay loading state
  final WidgetBuilder? overlayLoadingBuilder;

  /// Custom builder for overlay error state
  final Widget Function(BuildContext context, dynamic errorObject)?
      overlayErrorBuilder;

  /// Custom builder for overlay success state
  final WidgetBuilder? overlaySuccessBuilder;

  /// Alignment of overlay content
  final Alignment overlayAlignment;

  /// Background color for overlay
  final Color? overlayBackgroundColor;

  // Pagination Configuration

  /// Whether there's more data to load for pagination
  final bool hasMoreDataToLoad;

  /// Error object for pagination errors
  final dynamic paginationErrorObject;

  /// Custom builder for pagination error state
  final Widget Function(BuildContext context, dynamic errorObject)?
      paginationErrorStateBuilder;

  /// Custom builder for load more indicator
  final WidgetBuilder? loadMoreIndicatorBuilder;

  /// Custom builder for no more data indicator
  final WidgetBuilder? noMoreDataIndicatorBuilder;

  /// Threshold in pixels from bottom to trigger auto-scroll load more
  final double autoScrollThreshold;

  /// Debounce time in milliseconds for load more calls
  final int loadMoreDebounceMs;

  // UI Behavior Configuration

  /// Enable pull-to-refresh functionality
  final bool enablePullToRefresh;

  /// Enable skeleton loading instead of regular loading
  final bool enableSkeletonLoading;

  /// Show errors as snackbar instead of replacing content
  final bool showErrorAsSnackbar;

  /// Enable debug logging
  final bool enableDebugLogs;

  /// Enable animations between state transitions
  final bool enableAnimations;

  // Animation Configuration

  /// Animation configuration for state transitions
  final SmartStateAnimationConfig animationConfig;

  /// Custom transition builder for state changes
  final Widget Function(
    BuildContext context,
    Widget child,
    Animation<double> animation,
  )? customTransitionBuilder;

  /// Comprehensive overlay state configuration
  /// Controls which states show as overlays, dismissibility, and styling
  final SmartStateOverlayConfig overlayConfig;

  /// Callback when overlay is dismissed (works with isDismissible)
  final VoidCallback? onOverlayDismiss;

  /// Comprehensive snackbar configuration
  /// Controls position (top/bottom), styling, and behavior
  final SmartStateSnackbarConfig snackbarConfig;

  // Icon Configuration

  /// Icon for error states
  final IconData errorIcon;

  /// Icon for empty states
  final IconData emptyIcon;

  /// Icon for offline states
  final IconData offlineIcon;

  /// Optional icon for loading states
  final IconData? loadingIcon;

  // Text and Widget Configuration

  /// Configuration for all text content
  final SmartStateTextConfig textConfig;

  /// Configuration for all widget content
  final SmartStateWidgetConfig widgetConfig;

  /// Custom loading message to show contextual info
  final String? customLoadingMessage;

  // Styling Configuration

  /// Color for loading indicators
  final Color? loadingIndicatorColor;

  /// Color for error displays
  final Color? errorDisplayColor;

  /// Background color for the container
  final Color? containerBackgroundColor;

  /// Padding for content
  final EdgeInsets? contentPadding;

  /// Margin for content
  final EdgeInsets? contentMargin;

  @override
  Widget build(BuildContext context) {
    // Schedule snackbar after build completes
    if (showErrorAsSnackbar && currentState.isError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          _scheduleSnackbar(context, SnackbarType.error);
        }
      });
    } else if (snackbarConfig.showSuccessSnackbar && currentState.isSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          _scheduleSnackbar(context, SnackbarType.success);
        }
      });
    }

    return _buildMainContent(context);
  }

  void _scheduleSnackbar(BuildContext context, SnackbarType type) {
    final trackingService = SmartStateTrackingService();
    final uniqueKey = trackingService.generateKey();
    final shouldShow =
        trackingService.shouldShowSnackbar(uniqueKey, currentState);

    if (shouldShow) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;

        final config = snackbarConfig;
        final stateConfig = config.getConfigForState(type);
        final message = type == SnackbarType.error
            ? (errorObject?.toString() ?? textConfig.defaultErrorText)
            : 'Success!';

        final snackBar = SnackBar(
          content: GestureDetector(
            onTap: config.onTap,
            child: Row(
              children: [
                if (stateConfig.showIcon && stateConfig.icon != null) ...[
                  Icon(
                    stateConfig.icon,
                    color: stateConfig.iconColor ?? stateConfig.textColor,
                    size: stateConfig.iconSize,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: stateConfig.textColor,
                      fontSize: stateConfig.fontSize,
                      fontWeight: stateConfig.fontWeight,
                    ),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: stateConfig.backgroundColor,
          behavior: config.behavior,
          duration: config.duration,
          margin: config.position == SnackbarPosition.top
              ? (config.margin ??
                  const EdgeInsets.only(top: 16, left: 16, right: 16))
              : config.margin,
          padding: config.padding,
          shape: stateConfig.borderRadius != null
              ? RoundedRectangleBorder(borderRadius: stateConfig.borderRadius!)
              : null,
          elevation: stateConfig.elevation,
          dismissDirection: config.dismissDirection,
          showCloseIcon: config.showCloseIcon,
          closeIconColor: config.closeIconColor,
          action: stateConfig.action,
          onVisible: config.onVisible,
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }

  Widget _buildMainContent(BuildContext context) {
    Widget content;

    switch (currentState) {
      case SmartState.initial:
        content = _buildInitialState(context);
        break;
      case SmartState.loading:
        content = _buildLoadingState(context);
        break;
      case SmartState.error:
        content = _buildErrorState(context);
        break;
      case SmartState.empty:
        content = _buildEmptyState(context);
        break;
      case SmartState.offline:
        content = _buildOfflineState(context);
        break;
      case SmartState.success:
      case SmartState.loadingMore:
        content = _buildSuccessState(context);
        break;
    }

    // Apply animations using AnimatedSwitcher for implicit animations
    if (enableAnimations) {
      // Use a consistent key for success and loadingMore states to preserve scroll position
      final widgetKey = (currentState.isSuccess || currentState.isLoadingMore)
          ? const ValueKey('success_content')
          : ValueKey(currentState);

      content = AnimatedSwitcher(
        duration: animationConfig.duration,
        switchInCurve: animationConfig.curve,
        transitionBuilder: customTransitionBuilder != null
            ? (child, animation) =>
                customTransitionBuilder!(context, child, animation)
            : _getDefaultTransitionBuilder(),
        child: Container(key: widgetKey, child: content),
      );
    }

    return _buildFinalWidget(context, content);
  }

  AnimatedSwitcherTransitionBuilder _getDefaultTransitionBuilder() {
    switch (animationConfig.type) {
      case SmartStateTransitionType.fade:
        return AnimatedSwitcher.defaultTransitionBuilder;
      case SmartStateTransitionType.slide:
        return (child, animation) => SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.1),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
      case SmartStateTransitionType.slideLeft:
        return (child, animation) => SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
      case SmartStateTransitionType.slideRight:
        return (child, animation) => SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1.0, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
      case SmartStateTransitionType.scale:
        return (child, animation) =>
            ScaleTransition(scale: animation, child: child);
      case SmartStateTransitionType.rotate:
        return (child, animation) => RotationTransition(
              turns: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
              child: child,
            );
      case SmartStateTransitionType.bounce:
        return (child, animation) => ScaleTransition(
              scale: Tween<double>(begin: 0.3, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.bounceOut),
              ),
              child: child,
            );
      case SmartStateTransitionType.elastic:
        return (child, animation) => ScaleTransition(
              scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.elasticOut),
              ),
              child: child,
            );
      case SmartStateTransitionType.none:
        return (child, animation) => child;
    }
  }

  Widget _buildFinalWidget(BuildContext context, Widget content) {
    Widget child = content;

    // Handle overlay mode
    if (enableOverlayStates) {
      child = _buildOverlayMode(context, child);
    }

    // Wrap with pull-to-refresh if enabled
    if (enablePullToRefresh && onPullToRefresh != null) {
      child = RefreshIndicator(onRefresh: onPullToRefresh!, child: child);
    }

    // Apply container styling
    if (containerBackgroundColor != null ||
        contentPadding != null ||
        contentMargin != null) {
      child = Container(
        color: containerBackgroundColor,
        padding: contentPadding,
        margin: contentMargin,
        child: child,
      );
    }

    return child;
  }

  Widget _buildOverlayMode(BuildContext context, Widget mainContent) {
    Widget baseContent;

    if (currentState.isInitial && baseContentBuilder != null) {
      baseContent = baseContentBuilder!(context);
    } else if (currentState.isInitial && initialStateBuilder != null) {
      baseContent = initialStateBuilder!(context);
    } else if (baseContentBuilder != null) {
      baseContent = baseContentBuilder!(context);
    } else {
      baseContent = mainContent;
    }

    List<Widget> stackChildren = [baseContent];

    // Add overlay widget if needed
    if (_shouldShowOverlay()) {
      Widget? overlay = _buildOverlayWidget(context);
      if (overlay != null) {
        // Apply overlay animation using AnimatedSwitcher
        if (enableAnimations) {
          overlay = AnimatedSwitcher(
            duration: animationConfig.overlayDuration,
            switchInCurve: animationConfig.overlayCurve,
            transitionBuilder: _getOverlayTransitionBuilder(),
            child: Container(
              key: ValueKey('overlay-$currentState'),
              child: overlay,
            ),
          );
        }
        stackChildren.add(overlay);
      }
    }

    return Stack(children: stackChildren);
  }

  bool _shouldShowOverlay() {
    return currentState.isLoading ||
        currentState.isError ||
        currentState.isSuccess;
  }

  AnimatedSwitcherTransitionBuilder _getOverlayTransitionBuilder() {
    switch (animationConfig.overlayType) {
      case SmartStateTransitionType.fade:
        return AnimatedSwitcher.defaultTransitionBuilder;
      case SmartStateTransitionType.slide:
        return (child, animation) => SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.2),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
      case SmartStateTransitionType.slideLeft:
        return (child, animation) => SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
      case SmartStateTransitionType.slideRight:
        return (child, animation) => SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1.0, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
      case SmartStateTransitionType.scale:
        return (child, animation) =>
            ScaleTransition(scale: animation, child: child);
      case SmartStateTransitionType.rotate:
        return (child, animation) => RotationTransition(
              turns: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
              child: child,
            );
      case SmartStateTransitionType.bounce:
        return (child, animation) => ScaleTransition(
              scale: Tween<double>(begin: 0.3, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.bounceOut),
              ),
              child: child,
            );
      case SmartStateTransitionType.elastic:
        return (child, animation) => ScaleTransition(
              scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.elasticOut),
              ),
              child: child,
            );
      case SmartStateTransitionType.none:
        return (child, animation) => child;
    }
  }

  Widget? _buildOverlayWidget(BuildContext context) {
    Widget? overlay;

    switch (currentState) {
      case SmartState.loading:
        overlay = overlayLoadingBuilder?.call(context) ??
            _buildDefaultOverlayLoading(context);
        break;
      case SmartState.error:
        overlay = overlayErrorBuilder?.call(context, errorObject) ??
            _buildDefaultOverlayError(context);
        break;
      case SmartState.success:
        overlay = overlaySuccessBuilder?.call(context) ??
            _buildDefaultOverlaySuccess(context);
        break;
      default:
        return null;
    }

    // Apply overlay config styling
    final overlayStateConfig = overlayConfig.getConfigForState(currentState);
    if (overlayStateConfig.backgroundColor != null ||
        overlayStateConfig.borderRadius != null ||
        overlayStateConfig.padding != null ||
        overlayStateConfig.margin != null ||
        overlayStateConfig.elevation > 0) {
      overlay = Container(
        constraints: BoxConstraints(
          maxWidth: overlayStateConfig.maxWidth,
          minHeight: overlayStateConfig.minHeight ?? 0,
        ),
        margin: overlayStateConfig.margin,
        padding: overlayStateConfig.padding,
        decoration: BoxDecoration(
          color: overlayStateConfig.backgroundColor,
          borderRadius: overlayStateConfig.borderRadius,
          boxShadow: overlayStateConfig.elevation > 0
              ? [
                  BoxShadow(
                    color: overlayStateConfig.shadowColor ??
                        Colors.black.withValues(alpha: 0.2),
                    blurRadius: overlayStateConfig.elevation * 2,
                    offset: Offset(0, overlayStateConfig.elevation),
                  ),
                ]
              : null,
        ),
        child: overlay,
      );
    }

    Widget barrierContent = Container(
      color: overlayBackgroundColor ??
          overlayConfig.barrierColor ??
          Colors.black.withValues(alpha: 0.3),
      child: Align(alignment: overlayAlignment, child: overlay),
    );

    // Make overlay dismissible if configured
    if (overlayConfig.isDismissible || overlayConfig.barrierDismissible) {
      return GestureDetector(
        onTap: overlayConfig.barrierDismissible
            ? () {
                onOverlayDismiss?.call();
              }
            : null,
        child: Stack(
          children: [
            barrierContent,
            if (overlayConfig.isDismissible)
              Positioned(
                top: 0,
                right: 0,
                child: SafeArea(
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    color: Colors.white,
                    onPressed: () {
                      onOverlayDismiss?.call();
                    },
                  ),
                ),
              ),
          ],
        ),
      );
    }

    return barrierContent;
  }

  Widget _buildDefaultOverlayLoading(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircularProgressIndicator(
          color: overlayConfig.loadingConfig.iconColor,
        ),
        const SizedBox(height: 16),
        Text(
          customLoadingMessage ?? textConfig.loadingText,
          style: TextStyle(
            color: overlayConfig.loadingConfig.textColor,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultOverlayError(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          errorIcon,
          color: overlayConfig.errorConfig.iconColor ?? Colors.red,
          size: overlayConfig.errorConfig.iconSize,
        ),
        const SizedBox(height: 16),
        Text(
          errorObject?.toString() ?? textConfig.defaultErrorText,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: overlayConfig.errorConfig.textColor,
            fontSize: 16,
          ),
        ),
        if (onRetryPressed != null) ...[
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetryPressed,
            child: Text(textConfig.retryButtonText),
          ),
        ],
      ],
    );
  }

  Widget _buildDefaultOverlaySuccess(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.check_circle,
          color: overlayConfig.successConfig.iconColor ?? Colors.green,
          size: overlayConfig.successConfig.iconSize,
        ),
        const SizedBox(height: 16),
        Text(
          'Success!',
          style: TextStyle(
            color: overlayConfig.successConfig.textColor,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  void _debugLog(String message) {
    if (enableDebugLogs) {
      debugPrint('SmartStateHandler: $message');
    }
  }

  Widget _buildLoadingState(BuildContext context) {
    if (loadingStateBuilder != null) {
      return loadingStateBuilder!(context);
    }

    if (enableSkeletonLoading && skeletonLoadingBuilder != null) {
      return skeletonLoadingBuilder!(context);
    }

    // Built-in shimmer support
    if (enableSkeletonLoading) {
      if (widgetConfig.skeletonShimmerWidget != null) {
        return Semantics(
          label: 'Loading skeleton content',
          liveRegion: true,
          child: widgetConfig.skeletonShimmerWidget!,
        );
      } else {
        // Use default skeleton list
        return Semantics(
          label: 'Loading skeleton content',
          liveRegion: true,
          child: SmartStateSkeleton.list(
              itemCount: widgetConfig.skeletonItemCount),
        );
      }
    }

    final loadingText = customLoadingMessage ?? textConfig.loadingText;

    return Semantics(
      label: 'Loading data, please wait',
      liveRegion: true,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (loadingIcon != null) ...[
              Icon(loadingIcon, size: 48, color: loadingIndicatorColor),
              const SizedBox(height: 16),
            ] else ...[
              CircularProgressIndicator(color: loadingIndicatorColor),
              const SizedBox(height: 16),
            ],
            Text(
              loadingText,
              style: TextStyle(color: loadingIndicatorColor, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    if (errorStateBuilder != null) {
      return errorStateBuilder!(context, errorObject);
    }

    final errorText = _sanitizeErrorMessage(errorObject);

    return Semantics(
      label: 'Error occurred: $errorText',
      liveRegion: true,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Semantics(
              label: 'Error icon',
              child: Icon(errorIcon,
                  size: 64, color: errorDisplayColor ?? Colors.red),
            ),
            const SizedBox(height: 16),
            Text(
              errorText,
              textAlign: TextAlign.center,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: errorDisplayColor ?? Colors.red,
                fontSize: 16,
              ),
            ),
            if (onRetryPressed != null) ...[
              const SizedBox(height: 24),
              Semantics(
                button: true,
                label: 'Retry button, tap to retry loading',
                child: widgetConfig.retryButtonWidget ??
                    ElevatedButton(
                      onPressed: onRetryPressed,
                      child: Text(textConfig.retryButtonText),
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    if (emptyStateBuilder != null) {
      return emptyStateBuilder!(context);
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(emptyIcon, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          widgetConfig.noDataFoundWidget ??
              Text(
                textConfig.noDataFoundText,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
        ],
      ),
    );
  }

  Widget _buildOfflineState(BuildContext context) {
    if (offlineStateBuilder != null) {
      return offlineStateBuilder!(context);
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(offlineIcon, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          widgetConfig.offlineConnectionWidget ??
              Text(
                textConfig.offlineConnectionText,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
          if (onRetryPressed != null) ...[
            const SizedBox(height: 24),
            widgetConfig.retryButtonWidget ??
                ElevatedButton(
                  onPressed: onRetryPressed,
                  child: Text(textConfig.retryButtonText),
                ),
          ],
        ],
      ),
    );
  }

  Widget _buildInitialState(BuildContext context) {
    if (initialStateBuilder != null) {
      return initialStateBuilder!(context);
    }

    return Center(
      child: widgetConfig.initialStateWidget ??
          Text(
            textConfig.initialStateText,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
    );
  }

  Widget _buildSuccessState(BuildContext context) {
    final data = successData;
    if (data == null) {
      return _buildEmptyState(context);
    }

    if (successDataBuilder == null) {
      return Center(
        child: Text(
          textConfig.noBuilderProvidedText,
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }

    Widget content = successDataBuilder!(context, data);

    // Add pagination support if needed
    if (onLoadMoreData != null &&
        (currentState.isSuccess || currentState.isLoadingMore)) {
      content = _wrapWithPagination(content);
    }

    return content;
  }

  Widget _wrapWithPagination(Widget content) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo is ScrollEndNotification) {
          final pixels = scrollInfo.metrics.pixels;
          final maxScroll = scrollInfo.metrics.maxScrollExtent;

          // Check if we should trigger load more
          if (maxScroll - pixels <= autoScrollThreshold &&
              hasMoreDataToLoad &&
              !currentState.isLoadingMore) {
            // Use tracking service for proper debouncing
            final trackingService = SmartStateTrackingService();
            final uniqueKey = trackingService.generateKey();
            if (trackingService.shouldTriggerLoadMore(
                uniqueKey, loadMoreDebounceMs)) {
              _debugLog('Triggering load more data');
              SchedulerBinding.instance.addPostFrameCallback((_) {
                onLoadMoreData?.call();
              });
            } else {
              _debugLog('Load more debounced');
            }
          }
        }
        return false;
      },
      child: content,
    );
  }

  /// Sanitize error messages to prevent XSS and limit length
  String _sanitizeErrorMessage(dynamic errorObject) {
    if (errorObject == null) {
      return textConfig.defaultErrorText;
    }

    final errorStr = errorObject.toString();

    // Truncate very long errors
    if (errorStr.length > 500) {
      return '${errorStr.substring(0, 497)}...';
    }

    // Remove any HTML tags (basic sanitization)
    return errorStr.replaceAll(RegExp(r'<[^>]*>'), '');
  }
}
