/// Result wrapper for handling success and failure states
sealed class Result<T> {
  const Result();

  /// Create a successful result
  const factory Result.success(T data) = Success<T>;

  /// Create a failure result
  const factory Result.failure(Exception exception) = Failure<T>;

  /// Check if result is successful
  bool get isSuccess => this is Success<T>;

  /// Check if result is failure
  bool get isFailure => this is Failure<T>;

  /// Get data if successful, null otherwise
  T? get data => switch (this) {
        Success<T> success => success.data,
        Failure<T> _ => null,
      };

  /// Get exception if failure, null otherwise
  Exception? get exception => switch (this) {
        Success<T> _ => null,
        Failure<T> failure => failure.exception,
      };

  /// Transform successful result with a function
  Result<R> map<R>(R Function(T) transform) {
    return switch (this) {
      Success<T> success => Result.success(transform(success.data)),
      Failure<T> failure => Result.failure(failure.exception),
    };
  }

  /// Transform result with functions for both success and failure
  R fold<R>(
    R Function(T) onSuccess,
    R Function(Exception) onFailure,
  ) {
    return switch (this) {
      Success<T> success => onSuccess(success.data),
      Failure<T> failure => onFailure(failure.exception),
    };
  }

  /// Execute function if successful
  Result<T> onSuccess(void Function(T) action) {
    if (this is Success<T>) {
      action((this as Success<T>).data);
    }
    return this;
  }

  /// Execute function if failure
  Result<T> onFailure(void Function(Exception) action) {
    if (this is Failure<T>) {
      action((this as Failure<T>).exception);
    }
    return this;
  }

  /// Get data or throw exception
  T getOrThrow() {
    return switch (this) {
      Success<T> success => success.data,
      Failure<T> failure => throw failure.exception,
    };
  }

  /// Get data or return default value
  T getOrElse(T defaultValue) {
    return switch (this) {
      Success<T> success => success.data,
      Failure<T> _ => defaultValue,
    };
  }

  /// Get data or compute default value
  T getOrElseGet(T Function() defaultValueProvider) {
    return switch (this) {
      Success<T> success => success.data,
      Failure<T> _ => defaultValueProvider(),
    };
  }
}

/// Successful result containing data
final class Success<T> extends Result<T> {
  @override
  final T data;

  const Success(this.data);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Success<T> && other.data == data;
  }

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'Success($data)';
}

/// Failed result containing exception
final class Failure<T> extends Result<T> {
  @override
  final Exception exception;

  const Failure(this.exception);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Failure<T> && other.exception == exception;
  }

  @override
  int get hashCode => exception.hashCode;

  @override
  String toString() => 'Failure($exception)';
}

/// Extension methods for Future<Result<T>>
extension FutureResultExtensions<T> on Future<Result<T>> {
  /// Transform future result
  Future<Result<R>> mapAsync<R>(Future<R> Function(T) transform) async {
    final result = await this;
    return switch (result) {
      Success<T> success => Result.success(await transform(success.data)),
      Failure<T> failure => Result.failure(failure.exception),
    };
  }

  /// Execute function on successful future result
  Future<Result<T>> onSuccessAsync(Future<void> Function(T) action) async {
    final result = await this;
    if (result is Success<T>) {
      await action(result.data);
    }
    return result;
  }

  /// Execute function on failed future result
  Future<Result<T>> onFailureAsync(
      Future<void> Function(Exception) action) async {
    final result = await this;
    if (result is Failure<T>) {
      await action(result.exception);
    }
    return result;
  }

  /// Chain multiple async operations
  Future<Result<R>> flatMapAsync<R>(
      Future<Result<R>> Function(T) transform) async {
    final result = await this;
    return switch (result) {
      Success<T> success => await transform(success.data),
      Failure<T> failure => Result.failure(failure.exception),
    };
  }
}
