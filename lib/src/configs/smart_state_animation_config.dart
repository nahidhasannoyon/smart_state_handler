import 'package:flutter/material.dart';
import 'package:smart_state_handler/smart_state_handler.dart';

/// Animation configuration for state transitions
class SmartStateAnimationConfig {
  const SmartStateAnimationConfig({
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.type = SmartStateTransitionType.fade,
    this.overlayDuration = const Duration(milliseconds: 250),
    this.overlayCurve = Curves.easeOut,
    this.overlayType = SmartStateTransitionType.scale,
  });

  final Duration duration;
  final Curve curve;
  final SmartStateTransitionType type;

  /// Duration for overlay state animations
  final Duration overlayDuration;

  /// Curve for overlay state animations
  final Curve overlayCurve;

  /// Transition type for overlay states
  final SmartStateTransitionType overlayType;
}
