import 'package:flutter/material.dart';
import '../common/common.dart';

/// Error boundary widget that catches and handles widget errors gracefully
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(Object error, StackTrace? stackTrace)? errorBuilder;
  final void Function(Object error, StackTrace? stackTrace)? onError;
  final String? errorMessage;

  const ErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
    this.onError,
    this.errorMessage,
  });

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;
  StackTrace? _stackTrace;
  late final AppLogger _logger;

  @override
  void initState() {
    super.initState();
    _logger = AppLogger('ErrorBoundary');
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.errorBuilder?.call(_error!, _stackTrace) ??
          _buildDefaultErrorWidget();
    }

    // Set up global error handler
    ErrorWidget.builder = (FlutterErrorDetails details) {
      // Log the error
      _logger.error(
        'Widget error caught by ErrorBoundary',
        error: details.exception,
        stackTrace: details.stack,
      );

      // Call custom error handler if provided
      widget.onError?.call(details.exception, details.stack);

      // Update state to show error UI
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _error = details.exception;
            _stackTrace = details.stack;
          });
        }
      });

      return widget.errorBuilder?.call(details.exception, details.stack) ??
          _buildDefaultErrorWidget();
    };

    return widget.child;
  }

  Widget _buildDefaultErrorWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            widget.errorMessage ?? 'Something went wrong',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Please try again or contact support if the problem persists.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _error = null;
                _stackTrace = null;
              });
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}

/// Specialized error boundary for screens
class ScreenErrorBoundary extends StatelessWidget {
  final Widget child;
  final String screenName;

  const ScreenErrorBoundary({
    super.key,
    required this.child,
    required this.screenName,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      errorMessage: 'Unable to load $screenName',
      onError: (error, stackTrace) {
        // Additional screen-specific error handling
        // Could send to analytics or crash reporting
      },
      errorBuilder: (error, stackTrace) {
        return Scaffold(
          appBar: AppBar(
            title: Text(screenName),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 24),
                Text(
                  'Unable to load $screenName',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please try again or contact support if the problem persists.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Go Back'),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton(
                      onPressed: () {
                        // Restart the screen
                        Navigator.of(context).pushReplacementNamed(
                          ModalRoute.of(context)?.settings.name ?? '/',
                        );
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      child: child,
    );
  }
}

/// Error boundary for list items
class ListItemErrorBoundary extends StatelessWidget {
  final Widget child;
  final int index;

  const ListItemErrorBoundary({
    super.key,
    required this.child,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(
      errorMessage: 'Unable to load item',
      errorBuilder: (error, stackTrace) {
        return Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Unable to load this item',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Could trigger a retry for this specific item
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      },
      child: child,
    );
  }
}
