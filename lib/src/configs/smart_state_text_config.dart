/// Configuration class for customizing text content
class SmartStateTextConfig {
  const SmartStateTextConfig({
    this.retryButtonText = 'Retry',
    this.noDataFoundText = 'No data available',
    this.noMoreDataText = 'No more data',
    this.offlineConnectionText = 'No internet connection',
    this.loadMoreFailedText = 'Failed to load more',
    this.loadMoreRetryText = 'Try again',
    this.noBuilderProvidedText = 'No builder provided',
    this.defaultErrorText = 'An error occurred',
    this.genericErrorText = 'Something went wrong',
    this.initialStateText = 'Ready to start',
    this.loadingText = 'Loading...',
  });

  final String retryButtonText;
  final String noDataFoundText;
  final String noMoreDataText;
  final String offlineConnectionText;
  final String loadMoreFailedText;
  final String loadMoreRetryText;
  final String noBuilderProvidedText;
  final String defaultErrorText;
  final String genericErrorText;
  final String initialStateText;
  final String loadingText;
}
