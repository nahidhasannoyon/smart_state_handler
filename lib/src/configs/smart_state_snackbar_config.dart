import 'package:flutter/material.dart';

/// Configuration class for snackbar customization
///
/// Provides comprehensive control over snackbar behavior, positioning,
/// styling, and interaction for error and success messages.
///
/// Example:
/// ```dart
/// SmartStateSnackbarConfig(
///   position: SnackbarPosition.top,
///   behavior: SnackBarBehavior.floating,
///   duration: Duration(seconds: 4),
///   showCloseIcon: true,
///   errorConfig: SnackbarStateConfig(
///     backgroundColor: Colors.red,
///     textColor: Colors.white,
///   ),
/// )
/// ```
class SmartStateSnackbarConfig {
  const SmartStateSnackbarConfig({
    this.position = SnackbarPosition.bottom,
    this.behavior = SnackBarBehavior.fixed,
    this.duration = const Duration(seconds: 3),
    this.showCloseIcon = false,
    this.closeIconColor,
    this.margin,
    this.padding,
    this.width,
    this.dismissDirection = DismissDirection.down,
    this.errorConfig = const SnackbarStateConfig(
      backgroundColor: Color(0xFFD32F2F),
      textColor: Colors.white,
      icon: Icons.error_outline,
    ),
    this.successConfig = const SnackbarStateConfig(
      backgroundColor: Color(0xFF388E3C),
      textColor: Colors.white,
      icon: Icons.check_circle_outline,
    ),
    this.loadingConfig = const SnackbarStateConfig(
      backgroundColor: Color(0xFF1976D2),
      textColor: Colors.white,
      icon: Icons.info_outline,
    ),
    this.onTap,
    this.onVisible,
  });

  /// Position of the snackbar on screen
  final SnackbarPosition position;

  /// Behavior of the snackbar (fixed or floating)
  final SnackBarBehavior behavior;

  /// How long the snackbar should be visible
  final Duration duration;

  /// Whether to show a close/dismiss icon
  final bool showCloseIcon;

  /// Color of the close icon
  final Color? closeIconColor;

  /// Margin around the snackbar
  final EdgeInsets? margin;

  /// Padding inside the snackbar
  final EdgeInsets? padding;

  /// Width of the snackbar (for floating snackbars)
  final double? width;

  /// Direction to swipe to dismiss
  final DismissDirection dismissDirection;

  /// Configuration for error state snackbar
  final SnackbarStateConfig errorConfig;

  /// Configuration for success state snackbar
  final SnackbarStateConfig successConfig;

  /// Configuration for loading state snackbar
  final SnackbarStateConfig loadingConfig;

  /// Callback when snackbar is tapped
  final VoidCallback? onTap;

  /// Callback when snackbar becomes visible
  final VoidCallback? onVisible;

  /// Get configuration for specific state
  SnackbarStateConfig getConfigForState(SnackbarType type) {
    switch (type) {
      case SnackbarType.error:
        return errorConfig;
      case SnackbarType.success:
        return successConfig;
      case SnackbarType.loading:
        return loadingConfig;
    }
  }
}

/// Configuration for individual snackbar state appearance
class SnackbarStateConfig {
  const SnackbarStateConfig({
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.iconColor,
    this.iconSize = 24.0,
    this.fontSize = 14.0,
    this.fontWeight,
    this.borderRadius,
    this.elevation = 6.0,
    this.shadowColor,
    this.showIcon = true,
    this.customContent,
    this.action,
  });

  /// Background color of the snackbar
  final Color? backgroundColor;

  /// Text color of the message
  final Color? textColor;

  /// Icon to display in the snackbar
  final IconData? icon;

  /// Color of the icon
  final Color? iconColor;

  /// Size of the icon
  final double iconSize;

  /// Font size of the message text
  final double fontSize;

  /// Font weight of the message text
  final FontWeight? fontWeight;

  /// Border radius of the snackbar
  final BorderRadius? borderRadius;

  /// Elevation (shadow depth) of the snackbar
  final double elevation;

  /// Shadow color for the snackbar
  final Color? shadowColor;

  /// Whether to show the icon
  final bool showIcon;

  /// Custom widget to replace default snackbar content
  final Widget? customContent;

  /// Action button/widget for the snackbar
  final SnackBarAction? action;

  /// Copy with method for easy customization
  SnackbarStateConfig copyWith({
    Color? backgroundColor,
    Color? textColor,
    IconData? icon,
    Color? iconColor,
    double? iconSize,
    double? fontSize,
    FontWeight? fontWeight,
    BorderRadius? borderRadius,
    double? elevation,
    Color? shadowColor,
    bool? showIcon,
    Widget? customContent,
    SnackBarAction? action,
  }) {
    return SnackbarStateConfig(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      iconSize: iconSize ?? this.iconSize,
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
      borderRadius: borderRadius ?? this.borderRadius,
      elevation: elevation ?? this.elevation,
      shadowColor: shadowColor ?? this.shadowColor,
      showIcon: showIcon ?? this.showIcon,
      customContent: customContent ?? this.customContent,
      action: action ?? this.action,
    );
  }
}

/// Snackbar position on screen
enum SnackbarPosition {
  top,
  bottom,
}

/// Snackbar type for different states
enum SnackbarType {
  error,
  success,
  loading,
}
