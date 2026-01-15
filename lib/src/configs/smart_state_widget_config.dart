import 'package:flutter/material.dart';

/// Configuration class for customizing widget content
@immutable
class SmartStateWidgetConfig {
  const SmartStateWidgetConfig({
    this.retryButtonWidget,
    this.noDataFoundWidget,
    this.noMoreDataWidget,
    this.offlineConnectionWidget,
    this.loadMoreFailedWidget,
    this.loadMoreRetryWidget,
    this.noBuilderProvidedWidget,
    this.initialStateWidget,
  });

  final Widget? retryButtonWidget;
  final Widget? noDataFoundWidget;
  final Widget? noMoreDataWidget;
  final Widget? offlineConnectionWidget;
  final Widget? loadMoreFailedWidget;
  final Widget? loadMoreRetryWidget;
  final Widget? noBuilderProvidedWidget;
  final Widget? initialStateWidget;
}
