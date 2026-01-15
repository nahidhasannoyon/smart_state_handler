import 'package:flutter/material.dart';
import 'package:smart_state_handler/smart_state_handler.dart';

/// Configuration class for overlay state customization
///
/// Provides comprehensive control over overlay behavior and appearance
/// for loading, error, success, and other states when displayed as overlays.
///
/// Example:
/// ```dart
/// SmartStateOverlayConfig(
///   enabledStates: [SmartState.loading, SmartState.error],
///   isDismissible: true,
///   barrierColor: Colors.black54,
///   loadingConfig: OverlayStateConfig(
///     backgroundColor: Colors.white,
///     borderRadius: BorderRadius.circular(12),
///   ),
/// )
/// ```
@immutable
class SmartStateOverlayConfig {
  const SmartStateOverlayConfig({
    this.enabledStates = const [
      SmartState.loading,
      SmartState.error,
      SmartState.success
    ],
    this.isDismissible = false,
    this.barrierDismissible = false,
    this.barrierColor,
    this.alignment = Alignment.center,
    this.loadingConfig = const OverlayStateConfig(),
    this.errorConfig = const OverlayStateConfig(
      backgroundColor: Colors.white,
      iconColor: Colors.red,
      textColor: Colors.black87,
    ),
    this.successConfig = const OverlayStateConfig(
      backgroundColor: Colors.white,
      iconColor: Colors.green,
      textColor: Colors.black87,
    ),
    this.emptyConfig = const OverlayStateConfig(),
    this.offlineConfig = const OverlayStateConfig(
      backgroundColor: Colors.white,
      iconColor: Colors.orange,
      textColor: Colors.black87,
    ),
  });

  /// Which states should be shown as overlays
  /// Default: [SmartState.loading, SmartState.error, SmartState.success]
  final List<SmartState> enabledStates;

  /// Whether the overlay can be dismissed by tapping outside
  /// Note: This works in combination with onDismiss callback
  final bool isDismissible;

  /// Whether tapping the barrier dismisses the overlay (for dialog-style overlays)
  final bool barrierDismissible;

  /// Color of the barrier/backdrop behind the overlay
  /// Default: Colors.black.withOpacity(0.5)
  final Color? barrierColor;

  /// Alignment of overlay content on screen
  final Alignment alignment;

  /// Configuration for loading overlay
  final OverlayStateConfig loadingConfig;

  /// Configuration for error overlay
  final OverlayStateConfig errorConfig;

  /// Configuration for success overlay
  final OverlayStateConfig successConfig;

  /// Configuration for empty overlay
  final OverlayStateConfig emptyConfig;

  /// Configuration for offline overlay
  final OverlayStateConfig offlineConfig;

  /// Helper method to check if a state should be shown as overlay
  bool isOverlayEnabledForState(SmartState state) {
    return enabledStates.contains(state);
  }

  /// Get configuration for specific state
  OverlayStateConfig getConfigForState(SmartState state) {
    switch (state) {
      case SmartState.loading:
      case SmartState.loadingMore:
        return loadingConfig;
      case SmartState.error:
        return errorConfig;
      case SmartState.success:
        return successConfig;
      case SmartState.empty:
        return emptyConfig;
      case SmartState.offline:
        return offlineConfig;
      case SmartState.initial:
        return const OverlayStateConfig();
    }
  }
}

/// Configuration for individual overlay state appearance
@immutable
class OverlayStateConfig {
  const OverlayStateConfig({
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.margin,
    this.elevation = 4.0,
    this.shadowColor,
    this.iconColor,
    this.textColor,
    this.iconSize = 48.0,
    this.maxWidth = 320.0,
    this.minHeight,
    this.showIcon = true,
    this.showMessage = true,
    this.customWidget,
  });

  /// Background color of the overlay container
  final Color? backgroundColor;

  /// Border radius of the overlay container
  final BorderRadius? borderRadius;

  /// Padding inside the overlay container
  final EdgeInsets? padding;

  /// Margin around the overlay container
  final EdgeInsets? margin;

  /// Elevation (shadow depth) of the overlay
  final double elevation;

  /// Shadow color for the overlay
  final Color? shadowColor;

  /// Color for the state icon
  final Color? iconColor;

  /// Color for the state text/message
  final Color? textColor;

  /// Size of the state icon
  final double iconSize;

  /// Maximum width of the overlay
  final double maxWidth;

  /// Minimum height of the overlay
  final double? minHeight;

  /// Whether to show the icon
  final bool showIcon;

  /// Whether to show the message text
  final bool showMessage;

  /// Custom widget to replace default overlay content
  final Widget? customWidget;

  /// Copy with method for easy customization
  OverlayStateConfig copyWith({
    Color? backgroundColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? elevation,
    Color? shadowColor,
    Color? iconColor,
    Color? textColor,
    double? iconSize,
    double? maxWidth,
    double? minHeight,
    bool? showIcon,
    bool? showMessage,
    Widget? customWidget,
  }) {
    return OverlayStateConfig(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      elevation: elevation ?? this.elevation,
      shadowColor: shadowColor ?? this.shadowColor,
      iconColor: iconColor ?? this.iconColor,
      textColor: textColor ?? this.textColor,
      iconSize: iconSize ?? this.iconSize,
      maxWidth: maxWidth ?? this.maxWidth,
      minHeight: minHeight ?? this.minHeight,
      showIcon: showIcon ?? this.showIcon,
      showMessage: showMessage ?? this.showMessage,
      customWidget: customWidget ?? this.customWidget,
    );
  }
}
