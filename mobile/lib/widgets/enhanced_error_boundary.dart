import 'package:flutter/material.dart';
import '../common/common.dart';
import '../services/error_tracking_service.dart';
import '../config/service_locator.dart';
import 'error_boundary.dart';

/// Enhanced error boundary with additional features for different contexts
class EnhancedErrorBoundary extends StatelessWidget {
  final Widget child;
  final String? contextName;
  final Widget Function(Object error, StackTrace? stackTrace)? errorBuilder;
  final void Function(Object error, StackTrace? stackTrace)? onError;
  final bool enableRetry;
  final bool enableReporting;
  final Map<String, dynamic>? metadata;

  const EnhancedErrorBoundary({
    super.key,
    required this.child,
    this.contextName,
    this.errorBuilder,
    this.onError,
    this.enableRetry = true,
    this.enableReporting = true,
    this.metadata,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      errorMessage: contextName != null ? 'Error in $contextName' : null,
      onError: (error, stackTrace) {
        // Enhanced error logging with metadata
        final logger = AppLogger('EnhancedErrorBoundary');
        logger.error(
          'Enhanced error boundary caught error in ${contextName ?? 'unknown context'}',
          error: error,
          stackTrace: stackTrace,
          data: {
            'context': contextName,
            'enableRetry': enableRetry,
            'enableReporting': enableReporting,
            ...?metadata,
          },
        );

        // Call custom error handler
        onError?.call(error, stackTrace);
      },
      errorBuilder: errorBuilder ?? _buildEnhancedErrorWidget,
      child: child,
    );
  }

  Widget _buildEnhancedErrorWidget(Object error, StackTrace? stackTrace) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);

        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                contextName != null
                    ? 'Error in $contextName'
                    : 'Something went wrong',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'We apologize for the inconvenience. The error has been logged.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  if (enableRetry)
                    ElevatedButton.icon(
                      onPressed: () {
                        // Trigger a rebuild by navigating back and forth
                        Navigator.of(context).pushReplacementNamed(
                          ModalRoute.of(context)?.settings.name ?? '/',
                        );
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                    ),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Go Back'),
                  ),
                  if (enableReporting)
                    TextButton.icon(
                      onPressed: () =>
                          _showErrorDetails(context, error, stackTrace),
                      icon: const Icon(Icons.bug_report),
                      label: const Text('Report Issue'),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showErrorDetails(
      BuildContext context, Object error, StackTrace? stackTrace) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Context: ${contextName ?? 'Unknown'}'),
              const SizedBox(height: 8),
              Text('Error: $error'),
              if (stackTrace != null) ...[
                const SizedBox(height: 8),
                const Text('Stack Trace:'),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    stackTrace.toString(),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () => _sendErrorReport(context, error, stackTrace),
            child: const Text('Send Report'),
          ),
        ],
      ),
    );
  }

  /// Send error report to backend
  void _sendErrorReport(
      BuildContext context, Object error, StackTrace? stackTrace) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Sending error report...'),
            ],
          ),
        ),
      );

      // Get error tracking service
      final errorTrackingService =
          await ServiceLocator.getAsync<ErrorTrackingService>();

      // Send error report with context
      await errorTrackingService.recordError(
        error,
        stackTrace,
        reason: 'User-reported error from Enhanced Error Boundary',
        context: {
          'context_name': contextName ?? 'unknown',
          'error_type': error.runtimeType.toString(),
          'timestamp': DateTime.now().toIso8601String(),
          'user_initiated': true,
        },
      );

      // Close loading dialog
      if (context.mounted) Navigator.of(context).pop();

      // Close error dialog
      if (context.mounted) Navigator.of(context).pop();

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error report sent successfully. Thank you!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Close loading dialog if still open
      if (context.mounted) Navigator.of(context).pop();

      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send error report: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

/// Error boundary specifically for charts and data visualizations
class ChartErrorBoundary extends StatelessWidget {
  final Widget child;
  final String? chartType;

  const ChartErrorBoundary({
    super.key,
    required this.child,
    this.chartType,
  });

  @override
  Widget build(BuildContext context) {
    return EnhancedErrorBoundary(
      contextName: chartType != null ? '$chartType Chart' : 'Chart',
      metadata: {'chartType': chartType},
      errorBuilder: (error, stackTrace) => _buildChartErrorWidget(context),
      child: child,
    );
  }

  Widget _buildChartErrorWidget(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.error.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.show_chart,
            size: 48,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: 8),
          Text(
            'Chart Error',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Unable to display ${chartType ?? 'chart'}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

/// Error boundary for form fields and inputs
class FormFieldErrorBoundary extends StatelessWidget {
  final Widget child;
  final String? fieldName;

  const FormFieldErrorBoundary({
    super.key,
    required this.child,
    this.fieldName,
  });

  @override
  Widget build(BuildContext context) {
    return EnhancedErrorBoundary(
      contextName: fieldName != null ? '$fieldName Field' : 'Form Field',
      metadata: {'fieldName': fieldName},
      enableRetry: false, // Don't show retry for form fields
      errorBuilder: (error, stackTrace) => _buildFieldErrorWidget(context),
      child: child,
    );
  }

  Widget _buildFieldErrorWidget(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: theme.colorScheme.error.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            size: 20,
            color: theme.colorScheme.error,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Error in ${fieldName ?? 'field'}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Error boundary for navigation and routing
class NavigationErrorBoundary extends StatelessWidget {
  final Widget child;
  final String? routeName;

  const NavigationErrorBoundary({
    super.key,
    required this.child,
    this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return EnhancedErrorBoundary(
      contextName: routeName != null ? 'Route: $routeName' : 'Navigation',
      metadata: {'routeName': routeName},
      errorBuilder: (error, stackTrace) => _buildNavigationErrorWidget(context),
      child: child,
    );
  }

  Widget _buildNavigationErrorWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Error'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.navigation,
              size: 64,
              color: Colors.red,
            ),
            SizedBox(height: 16),
            Text(
              'Navigation Error',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Unable to navigate to the requested page',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
