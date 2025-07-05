import 'package:flutter/foundation.dart';
import '../network/api_client.dart';
import '../network/network_exceptions.dart';
import '../logging/app_logger.dart';
import 'base_result.dart';

/// Base repository class with common functionality
abstract class BaseRepository {
  @protected
  final ApiClient apiClient;
  @protected
  final AppLogger logger;

  BaseRepository({
    required ApiClient apiClient,
    required AppLogger logger,
  })  : apiClient = apiClient,
        logger = logger;

  /// Make a GET request
  Future<Result<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      logger.debug('Making GET request to $endpoint');

      final response = await apiClient.get(
        endpoint,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final data = fromJson != null ? fromJson(response.data) : response.data;
        return Result.success(data as T);
      } else {
        return Result.failure(
          NetworkException(
            'GET request failed',
            type: NetworkExceptionType.server,
            statusCode: response.statusCode,
          ),
        );
      }
    } on NetworkException catch (e) {
      logger.error('Network error in GET $endpoint', error: e);
      return Result.failure(e);
    } catch (e) {
      logger.error('Unexpected error in GET $endpoint', error: e);
      return Result.failure(
        NetworkException(
          'Unexpected error occurred',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  /// Make a POST request
  Future<Result<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      logger.debug('Making POST request to $endpoint');

      final response = await apiClient.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData =
            fromJson != null ? fromJson(response.data) : response.data;
        return Result.success(responseData as T);
      } else {
        return Result.failure(
          NetworkException(
            'POST request failed',
            type: NetworkExceptionType.server,
            statusCode: response.statusCode,
          ),
        );
      }
    } on NetworkException catch (e) {
      logger.error('Network error in POST $endpoint', error: e);
      return Result.failure(e);
    } catch (e) {
      logger.error('Unexpected error in POST $endpoint', error: e);
      return Result.failure(
        NetworkException(
          'Unexpected error occurred',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  /// Make a PUT request
  Future<Result<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      logger.debug('Making PUT request to $endpoint');

      final response = await apiClient.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final responseData =
            fromJson != null ? fromJson(response.data) : response.data;
        return Result.success(responseData as T);
      } else {
        return Result.failure(
          NetworkException(
            'PUT request failed',
            type: NetworkExceptionType.server,
            statusCode: response.statusCode,
          ),
        );
      }
    } on NetworkException catch (e) {
      logger.error('Network error in PUT $endpoint', error: e);
      return Result.failure(e);
    } catch (e) {
      logger.error('Unexpected error in PUT $endpoint', error: e);
      return Result.failure(
        NetworkException(
          'Unexpected error occurred',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  /// Make a PATCH request
  Future<Result<T>> patch<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      logger.debug('Making PATCH request to $endpoint');

      final response = await apiClient.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final responseData =
            fromJson != null ? fromJson(response.data) : response.data;
        return Result.success(responseData as T);
      } else {
        return Result.failure(
          NetworkException(
            'PATCH request failed',
            type: NetworkExceptionType.server,
            statusCode: response.statusCode,
          ),
        );
      }
    } on NetworkException catch (e) {
      logger.error('Network error in PATCH $endpoint', error: e);
      return Result.failure(e);
    } catch (e) {
      logger.error('Unexpected error in PATCH $endpoint', error: e);
      return Result.failure(
        NetworkException(
          'Unexpected error occurred',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  /// Make a DELETE request
  Future<Result<void>> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      logger.debug('Making DELETE request to $endpoint');

      final response = await apiClient.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return Result.success(null);
      } else {
        return Result.failure(
          NetworkException(
            'DELETE request failed',
            type: NetworkExceptionType.server,
            statusCode: response.statusCode,
          ),
        );
      }
    } on NetworkException catch (e) {
      logger.error('Network error in DELETE $endpoint', error: e);
      return Result.failure(e);
    } catch (e) {
      logger.error('Unexpected error in DELETE $endpoint', error: e);
      return Result.failure(
        NetworkException(
          'Unexpected error occurred',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  /// Make a paginated GET request
  Future<Result<PaginatedResult<T>>> getPaginated<T>(
    String endpoint, {
    int page = 1,
    int limit = 20,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      logger.debug('Making paginated GET request to $endpoint');

      final params = {
        'page': page.toString(),
        'limit': limit.toString(),
        ...?queryParameters,
      };

      final response = await apiClient.get(
        endpoint,
        queryParameters: params,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final items = (data['items'] as List<dynamic>)
            .map((item) => fromJson != null ? fromJson(item) : item as T)
            .toList();

        final paginatedResult = PaginatedResult<T>(
          items: items,
          page: data['page'] ?? page,
          limit: data['limit'] ?? limit,
          total: data['total'] ?? 0,
          totalPages: data['totalPages'] ?? 0,
          hasNext: data['hasNext'] ?? false,
          hasPrevious: data['hasPrevious'] ?? false,
        );

        return Result.success(paginatedResult);
      } else {
        return Result.failure(
          NetworkException(
            'Paginated GET request failed',
            type: NetworkExceptionType.server,
            statusCode: response.statusCode,
          ),
        );
      }
    } on NetworkException catch (e) {
      logger.error('Network error in paginated GET $endpoint', error: e);
      return Result.failure(e);
    } catch (e) {
      logger.error('Unexpected error in paginated GET $endpoint', error: e);
      return Result.failure(
        NetworkException(
          'Unexpected error occurred',
          type: NetworkExceptionType.unknown,
        ),
      );
    }
  }

  /// Handle API errors consistently
  Result<T> handleError<T>(dynamic error) {
    if (error is NetworkException) {
      return Result.failure(error);
    }

    logger.error('Unexpected error', error: error);
    return Result.failure(
      NetworkException(
        'Unexpected error occurred',
        type: NetworkExceptionType.unknown,
      ),
    );
  }
}

/// Paginated result wrapper
class PaginatedResult<T> {
  final List<T> items;
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  const PaginatedResult({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  /// Create from JSON
  factory PaginatedResult.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return PaginatedResult(
      items: (json['items'] as List<dynamic>)
          .map((item) => fromJsonT(item))
          .toList(),
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 20,
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      hasNext: json['hasNext'] ?? false,
      hasPrevious: json['hasPrevious'] ?? false,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'items': items.map((item) => toJsonT(item)).toList(),
      'page': page,
      'limit': limit,
      'total': total,
      'totalPages': totalPages,
      'hasNext': hasNext,
      'hasPrevious': hasPrevious,
    };
  }
}
