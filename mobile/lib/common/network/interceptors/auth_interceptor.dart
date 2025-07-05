import 'package:dio/dio.dart';
import '../../storage/secure_storage_service.dart';

/// Authentication interceptor for automatic token management
class AuthInterceptor extends Interceptor {
  final SecureStorageService _secureStorage;

  AuthInterceptor({required SecureStorageService secureStorage})
      : _secureStorage = secureStorage;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Skip authentication for auth endpoints
    if (_shouldSkipAuth(options.path)) {
      handler.next(options);
      return;
    }

    try {
      // Get access token from secure storage
      final accessToken = await _secureStorage.getAccessToken();

      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      }

      handler.next(options);
    } catch (e) {
      // If token retrieval fails, proceed without token
      handler.next(options);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized errors
    if (err.response?.statusCode == 401) {
      try {
        final refreshToken = await _secureStorage.getRefreshToken();

        if (refreshToken != null) {
          // Attempt to refresh the token
          final newTokens = await _refreshToken(refreshToken);

          if (newTokens != null) {
            // Save new tokens
            await _secureStorage.saveAccessToken(newTokens['access_token']);
            if (newTokens['refresh_token'] != null) {
              await _secureStorage.saveRefreshToken(newTokens['refresh_token']);
            }

            // Retry the original request with new token
            final retryOptions = err.requestOptions;
            retryOptions.headers['Authorization'] =
                'Bearer ${newTokens['access_token']}';

            try {
              final dio = Dio();
              final response = await dio.fetch(retryOptions);
              handler.resolve(response);
              return;
            } catch (retryError) {
              // If retry fails, clear tokens and proceed with original error
              await _secureStorage.clearAuthData();
            }
          } else {
            // If refresh fails, clear tokens
            await _secureStorage.clearAuthData();
          }
        }
      } catch (refreshError) {
        // If refresh attempt fails, clear tokens
        await _secureStorage.clearAuthData();
      }
    }

    handler.next(err);
  }

  /// Check if authentication should be skipped for this endpoint
  bool _shouldSkipAuth(String path) {
    const skipAuthPaths = [
      '/auth/login',
      '/auth/register',
      '/auth/refresh',
      '/auth/forgot-password',
      '/auth/reset-password',
      '/auth/verify-email',
      '/auth/social-login',
    ];

    return skipAuthPaths.any((skipPath) => path.contains(skipPath));
  }

  /// Refresh the access token
  Future<Map<String, dynamic>?> _refreshToken(String refreshToken) async {
    try {
      final dio = Dio();

      final response = await dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data as Map<String, dynamic>;
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
