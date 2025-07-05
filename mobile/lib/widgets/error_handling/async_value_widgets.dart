import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/network/network_exceptions.dart';

/// Standardized error handling widgets for consistent AsyncValue display patterns
/// These widgets provide reusable UI components for loading, error, and data states

/// Generic error widget that can be used across the app
class ErrorDisplayWidget extends StatelessWidget {
  final Object error;
  final StackTrace? stackTrace;
  final VoidCallback? onRetry;
  final String? customMessage;
  final bool showDetails;

  const ErrorDisplayWidget({
    super.key,
    required this.error,
    this.stackTrace,
    this.onRetry,
    this.customMessage,
    this.showDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    final errorMessage = _getErrorMessage();
    final errorIcon = _getErrorIcon();
    final errorColor = _getErrorColor(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              errorIcon,
              size: 64,
              color: errorColor,
            ),
            const SizedBox(height: 16),
            Text(
              customMessage ?? errorMessage,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: errorColor,
                  ),
              textAlign: TextAlign.center,
            ),
            if (showDetails && error.toString().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: errorColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getErrorMessage() {
    if (error is NetworkException) {
      final networkError = error as NetworkException;
      switch (networkError.type) {
        case NetworkExceptionType.noConnection:
          return 'No internet connection. Please check your network and try again.';
        case NetworkExceptionType.timeout:
          return 'Request timed out. Please try again.';
        case NetworkExceptionType.unauthorized:
          return 'You are not authorized to access this resource.';
        case NetworkExceptionType.forbidden:
          return 'Access to this resource is forbidden.';
        case NetworkExceptionType.notFound:
          return 'The requested resource was not found.';
        case NetworkExceptionType.server:
          return 'Server error occurred. Please try again later.';
        case NetworkExceptionType.unknown:
        default:
          return networkError.message.isNotEmpty
              ? networkError.message
              : 'An unexpected error occurred.';
      }
    }

    return 'An unexpected error occurred. Please try again.';
  }

  IconData _getErrorIcon() {
    if (error is NetworkException) {
      final networkError = error as NetworkException;
      switch (networkError.type) {
        case NetworkExceptionType.noConnection:
          return Icons.wifi_off;
        case NetworkExceptionType.timeout:
          return Icons.access_time;
        case NetworkExceptionType.unauthorized:
        case NetworkExceptionType.forbidden:
          return Icons.lock;
        case NetworkExceptionType.notFound:
          return Icons.search_off;
        case NetworkExceptionType.server:
          return Icons.error;
        case NetworkExceptionType.unknown:
        default:
          return Icons.error_outline;
      }
    }

    return Icons.error_outline;
  }

  Color _getErrorColor(BuildContext context) {
    if (error is NetworkException) {
      final networkError = error as NetworkException;
      switch (networkError.type) {
        case NetworkExceptionType.noConnection:
          return Colors.orange;
        case NetworkExceptionType.timeout:
          return Colors.amber;
        case NetworkExceptionType.unauthorized:
        case NetworkExceptionType.forbidden:
          return Colors.red;
        case NetworkExceptionType.notFound:
          return Colors.grey;
        case NetworkExceptionType.server:
          return Colors.red;
        case NetworkExceptionType.unknown:
        default:
          return Theme.of(context).colorScheme.error;
      }
    }

    return Theme.of(context).colorScheme.error;
  }
}

/// Loading widget with customizable message and indicator
class LoadingDisplayWidget extends StatelessWidget {
  final String? message;
  final bool showMessage;
  final Color? color;

  const LoadingDisplayWidget({
    super.key,
    this.message,
    this.showMessage = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: color ?? Theme.of(context).primaryColor,
          ),
          if (showMessage) ...[
            const SizedBox(height: 16),
            Text(
              message ?? 'Loading...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Empty state widget for when data is successfully loaded but empty
class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyStateWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.inbox,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[500],
                    ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Wrapper widget that handles AsyncValue states with consistent UI
class AsyncValueWidget<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final Widget Function(Object error, StackTrace stackTrace)? error;
  final Widget? loading;
  final String? loadingMessage;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.error,
    this.loading,
    this.loadingMessage,
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: data,
      loading: () => loading ?? LoadingDisplayWidget(message: loadingMessage),
      error: (err, stack) =>
          error?.call(err, stack) ??
          ErrorDisplayWidget(
            error: err,
            stackTrace: stack,
            customMessage: errorMessage,
            onRetry: onRetry,
          ),
    );
  }
}

/// Extension on AsyncValue to provide common UI patterns
extension AsyncValueUI on AsyncValue {
  /// Returns true if this AsyncValue is in a loading state
  bool get isLoading => this is AsyncLoading;

  /// Returns true if this AsyncValue has an error
  bool get hasError => this is AsyncError;

  /// Returns the error if present, null otherwise
  Object? get errorOrNull => hasError ? (this as AsyncError).error : null;

  /// Returns a widget that displays loading, error, or data states
  Widget when<T>({
    required Widget Function(T data) data,
    Widget? loading,
    Widget Function(Object error, StackTrace stackTrace)? error,
    String? loadingMessage,
    String? errorMessage,
    VoidCallback? onRetry,
  }) {
    if (this is AsyncData<T>) {
      return data((this as AsyncData<T>).value);
    } else if (this is AsyncLoading) {
      return loading ?? LoadingDisplayWidget(message: loadingMessage);
    } else if (this is AsyncError) {
      final asyncError = this as AsyncError;
      return error?.call(asyncError.error, asyncError.stackTrace) ??
          ErrorDisplayWidget(
            error: asyncError.error,
            stackTrace: asyncError.stackTrace,
            customMessage: errorMessage,
            onRetry: onRetry,
          );
    }

    return const SizedBox.shrink();
  }
}

/// Helper function to create a standardized error snackbar
void showErrorSnackBar(BuildContext context, Object error,
    {VoidCallback? onRetry}) {
  String message = 'An error occurred';

  if (error is NetworkException) {
    message =
        error.message.isNotEmpty ? error.message : 'Network error occurred';
  } else {
    message = error.toString();
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Theme.of(context).colorScheme.error,
      action: onRetry != null
          ? SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: onRetry,
            )
          : null,
    ),
  );
}

/// Helper function to create a standardized success snackbar
void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
    ),
  );
}
