import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_state_handler/smart_state_handler.dart';

void main() {
  group('SmartStateTextConfig', () {
    test('has default values', () {
      const config = SmartStateTextConfig();

      expect(config.retryButtonText, 'Retry');
      expect(config.noDataFoundText, 'No data available');
      expect(config.noMoreDataText, 'No more data');
      expect(config.offlineConnectionText, 'No internet connection');
      expect(config.loadMoreFailedText, 'Failed to load more');
      expect(config.loadMoreRetryText, 'Try again');
      expect(config.noBuilderProvidedText, 'No builder provided');
      expect(config.defaultErrorText, 'An error occurred');
      expect(config.genericErrorText, 'Something went wrong');
      expect(config.initialStateText, 'Ready to start');
      expect(config.loadingText, 'Loading...');
    });

    test('can be customized', () {
      const config = SmartStateTextConfig(
        retryButtonText: 'Retry Again',
        loadingText: 'Please wait...',
        noDataFoundText: 'No items found',
      );

      expect(config.retryButtonText, 'Retry Again');
      expect(config.loadingText, 'Please wait...');
      expect(config.noDataFoundText, 'No items found');
    });
  });

  group('SmartStateWidgetConfig', () {
    test('has null default values', () {
      const config = SmartStateWidgetConfig();

      expect(config.retryButtonWidget, isNull);
      expect(config.noDataFoundWidget, isNull);
      expect(config.noMoreDataWidget, isNull);
      expect(config.offlineConnectionWidget, isNull);
      expect(config.loadMoreFailedWidget, isNull);
      expect(config.loadMoreRetryWidget, isNull);
      expect(config.noBuilderProvidedWidget, isNull);
      expect(config.initialStateWidget, isNull);
    });

    test('can be customized with widgets', () {
      const retryWidget = Text('Custom Retry');
      const emptyWidget = Text('Custom Empty');

      const config = SmartStateWidgetConfig(
        retryButtonWidget: retryWidget,
        noDataFoundWidget: emptyWidget,
      );

      expect(config.retryButtonWidget, retryWidget);
      expect(config.noDataFoundWidget, emptyWidget);
    });
  });

  group('SmartStateAnimationConfig', () {
    test('has default values', () {
      const config = SmartStateAnimationConfig();

      expect(config.duration, const Duration(milliseconds: 300));
      expect(config.curve, Curves.easeInOut);
      expect(config.type, SmartStateTransitionType.fade);
      expect(config.overlayDuration, const Duration(milliseconds: 250));
      expect(config.overlayCurve, Curves.easeOut);
      expect(config.overlayType, SmartStateTransitionType.scale);
    });

    test('can be customized', () {
      const config = SmartStateAnimationConfig(
        duration: Duration(milliseconds: 500),
        curve: Curves.bounceIn,
        type: SmartStateTransitionType.slide,
        overlayDuration: Duration(milliseconds: 400),
        overlayCurve: Curves.elasticOut,
        overlayType: SmartStateTransitionType.bounce,
      );

      expect(config.duration, const Duration(milliseconds: 500));
      expect(config.curve, Curves.bounceIn);
      expect(config.type, SmartStateTransitionType.slide);
      expect(config.overlayDuration, const Duration(milliseconds: 400));
      expect(config.overlayCurve, Curves.elasticOut);
      expect(config.overlayType, SmartStateTransitionType.bounce);
    });
  });

  group('SmartStateTransitionType', () {
    test('has all expected values', () {
      expect(SmartStateTransitionType.values, [
        SmartStateTransitionType.fade,
        SmartStateTransitionType.slide,
        SmartStateTransitionType.slideLeft,
        SmartStateTransitionType.slideRight,
        SmartStateTransitionType.scale,
        SmartStateTransitionType.rotate,
        SmartStateTransitionType.bounce,
        SmartStateTransitionType.elastic,
        SmartStateTransitionType.none,
      ]);
    });
  });
}
