# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.2] - 2025-10-05

### Added

#### New Configuration Classes

- **SmartStateOverlayConfig**: Comprehensive overlay state configuration

  - Selective overlay states (choose which states show as overlays)
  - Dismissible overlays with `isDismissible` and `barrierDismissible` options
  - Per-state styling via `OverlayStateConfig` for loading, error, success, empty, and offline
  - Barrier customization (color, opacity)
  - Individual state configurations with smart defaults
  - `getConfigForState()` helper method
  - `isOverlayEnabledForState()` utility method

- **OverlayStateConfig**: Individual overlay state appearance configuration

  - Background color and border radius customization
  - Padding, margin, and elevation control
  - Icon and text color customization
  - Icon and text size control
  - Maximum width and minimum height options
  - Show/hide icon and message toggles
  - Custom widget support for complete control
  - `copyWith()` method for easy customization

- **SmartStateSnackbarConfig**: Complete snackbar customization

  - Position control (top or bottom via `SnackbarPosition` enum)
  - Behavior options (fixed or floating)
  - Duration and dismiss direction control
  - Show close icon option with color customization
  - Per-state styling via `SnackbarStateConfig`
  - Event callbacks (`onTap`, `onVisible`)
  - Margin, padding, and width customization
  - `getConfigForState()` helper method

- **SnackbarStateConfig**: Individual snackbar state appearance
  - Background and text color customization
  - Icon selection and color control
  - Icon and font size customization
  - Font weight and border radius options
  - Elevation and shadow color control
  - Show/hide icon toggle
  - Custom content widget support
  - Action button integration
  - `copyWith()` method for easy customization

#### New Enums

- `SnackbarPosition`: Control snackbar position (top, bottom)
- `SnackbarType`: Type safety for snackbar states (error, success, loading)

#### New Parameters

- `overlayConfig`: Comprehensive overlay configuration object
- `onOverlayDismiss`: Callback when overlay is dismissed
- `snackbarConfig`: Comprehensive snackbar configuration object

### Changed

#### Documentation

- **Removed** installation section from README (streamlined documentation)
- **Added** comprehensive table of contents with clickable navigation
- **Added** "Configuration Classes" section with detailed examples
- **Added** "Complete Configuration Reference" section
- **Added** "What's New in This Version" section
- **Added** "Pro Tips" section with practical guidance
- **Updated** use case examples to demonstrate new features
- **Improved** code examples with real-world scenarios

#### Examples

- **Added** `advanced_examples.dart` with 4 comprehensive examples:
  1. Dismissible Error Overlay Example
  2. Top Snackbar with Action Example
  3. Selective Overlay States Example
  4. Custom Styled Overlay Example
- All examples are production-ready and fully functional

### Improved

- **Developer Experience**: Configuration objects provide better IDE autocomplete and type safety
- **API Organization**: Related options grouped into logical configuration classes
- **Customization**: More granular control over overlay and snackbar behavior
- **Consistency**: Similar pattern across all configuration objects (inspired by Flutter's ThemeData)
- **Documentation**: Better organized with practical, copy-paste examples

### Features Enabled

#### Dismissible Overlays

```dart
overlayConfig: SmartStateOverlayConfig(
  isDismissible: true,
  barrierDismissible: true,
  onOverlayDismiss: () => handleDismiss(),
)
```

#### Top Snackbars

```dart
snackbarConfig: SmartStateSnackbarConfig(
  position: SnackbarPosition.top,
  errorConfig: SnackbarStateConfig(
    action: SnackBarAction(label: 'Retry', onPressed: retry),
  ),
)
```

#### Selective Overlays

```dart
overlayConfig: SmartStateOverlayConfig(
  enabledStates: [SmartState.error],  // Only show overlay for errors
)
```

#### Per-State Styling

```dart
overlayConfig: SmartStateOverlayConfig(
  errorConfig: OverlayStateConfig(
    backgroundColor: Colors.red.shade50,
    iconColor: Colors.red,
  ),
  successConfig: OverlayStateConfig(
    backgroundColor: Colors.green.shade50,
    iconColor: Colors.green,
  ),
)
```

### Technical Details

- **Breaking Changes**: None - fully backward compatible
- **New Files**:
  - `lib/src/configs/smart_state_overlay_config.dart`
  - `lib/src/configs/smart_state_snackbar_config.dart`
  - `example/lib/advanced_examples.dart`
  - `ENHANCEMENTS.md`
- **Updated Files**:
  - `lib/smart_state_handler.dart` (added exports)
  - `lib/src/smart_state_handler.dart` (added new parameters)
  - `README.md` (comprehensive updates)
- **Code Quality**: All new code follows Dart style guidelines and includes documentation

### Migration Guide

Existing code continues to work without changes. To adopt new features:

**Old way (still works):**

```dart
SmartStateHandler(
  enableOverlayStates: true,
  overlayAlignment: Alignment.center,
)
```

**New recommended way:**

```dart
SmartStateHandler(
  enableOverlayStates: true,
  overlayConfig: SmartStateOverlayConfig(
    isDismissible: true,
    errorConfig: OverlayStateConfig(iconColor: Colors.red),
  ),
)
```

## [1.0.1] - 2025-10-04

### Added

- Initial release of SmartStateHandler
- Support for 7 UI states: initial, loading, error, empty, offline, success, loadingMore
- Extension methods for convenient state checking (`.isLoading`, `.isError`, etc.)
- Smooth animations between state transitions with 9 animation types:
  - fade, slide, slideLeft, slideRight, scale, rotate, bounce, elastic, none
- Overlay mode for forms and non-intrusive state changes
- Custom animation configurations for both content and overlay transitions
- Pull-to-refresh functionality
- Automatic pagination support with debouncing
- Custom icon support for all states
- Text configuration object for easy customization
- Widget configuration object for complete UI control
- Debug mode with comprehensive logging
- Custom builders for all states
- Type-safe generic data handling
- Comprehensive unit tests with 43+ test cases
- Complete example application demonstrating all features

### Features

#### State Management

- Single `SmartState` enum instead of multiple boolean flags
- Type-safe generic support
- Extension methods for readable state checking
- Debug logging for development

#### UI Features

- Initial state support for forms and user-triggered operations
- Overlay mode with separate animation configurations
- Multiple animation types with customizable curves and durations
- Widget memoization for performance optimization
- Custom icons for loading, error, empty, and offline states
- Contextual loading messages
- Pull-to-refresh integration
- Auto-scroll pagination with configurable threshold
- Debounced pagination to prevent double-triggers

#### Customization

- `SmartStateAnimationConfig` for animation customization
- `SmartStateTextConfig` for text content customization
- `SmartStateWidgetConfig` for complete widget replacement
- Custom builders for all states
- Separate overlay builders for overlay mode
- Container styling options (background color, padding, margin)
- Custom transition builders

#### Developer Experience

- Clean, readable API
- Extensive documentation with examples
- Comprehensive test coverage
- Example app with both list and form demos
- Proper error handling and fallbacks

### Documentation

- Comprehensive README with installation instructions
- Quick start guide
- Multiple usage examples
- Integration guides for GetX, Provider, BLoC
- Animation showcase
- Best practices section
- Migration guide
