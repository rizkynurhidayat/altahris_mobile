import 'package:dio/dio.dart';
import 'package:altahris_mobile/core/di/injection_container.dart';
import 'package:altahris_mobile/features/auth/data/datasources/auth_local_data_source.dart';

class DioClient {
  final Dio dio;
  bool _isRefreshing = false;
  final List<Map<String, dynamic>> _failedRequests = [];

  DioClient() : dio = Dio(
    BaseOptions(
      baseUrl: 'https://altahris.com/api',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  ) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Skip adding token for login and refresh
        if (options.path.contains('/auth/login') || options.path.contains('/auth/refresh')) {
          return handler.next(options);
        }

        try {
          final localDataSource = sl<AuthLocalDataSource>();
          final user = await localDataSource.getCachedUser();
          if (user != null && user.token != null) {
            options.headers['Authorization'] = 'Bearer ${user.token}';
          }
        } catch (_) {}
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        final responseData = e.response?.data;
        String message = '';
        
        if (responseData is Map) {
          message = (responseData['message'] ?? '').toString().toLowerCase();
        } else if (responseData is String) {
          message = responseData.toLowerCase();
        } else {
          message = e.message?.toLowerCase() ?? '';
        }
        
        bool isTokenError = e.response?.statusCode == 401 || 
                           message.contains('invalid') || 
                           message.contains('expired') ||
                           message.contains('unauthenticated') ||
                           message.contains('token not found');

        if (isTokenError) {
          print('--- Token Error Detected: $message (Status: ${e.response?.statusCode}) ---');
          
          if (e.requestOptions.path.contains('/auth/refresh')) {
            print('--- Refresh token itself failed. Clearing cache. ---');
            await sl<AuthLocalDataSource>().clearCache();
            return handler.next(e);
          }

          // If a refresh is already in progress, queue the request
          if (_isRefreshing) {
            print('--- Refresh already in progress, queuing request: ${e.requestOptions.path} ---');
            _failedRequests.add({
              'options': e.requestOptions,
              'handler': handler,
            });
            return;
          }

          _isRefreshing = true;

          try {
            final localDataSource = sl<AuthLocalDataSource>();
            final user = await localDataSource.getCachedUser();

            if (user != null && user.refreshToken != null) {
              print('--- Attempting to Refresh Token ---');
              
              // Use a fresh Dio instance for refresh to avoid interceptor recursion
              final refreshDio = Dio(BaseOptions(baseUrl: 'https://altahris.com/api'));
              final refreshResponse = await refreshDio.post(
                '/auth/refresh',
                data: {'refresh_token': user.refreshToken},
              );

              if (refreshResponse.statusCode == 200) {
                final tokens = refreshResponse.data['data'];
                final newAccessToken = tokens['access_token'];
                final newRefreshToken = tokens['refresh_token'];

                print('--- Token Refreshed Successfully ---');

                final updatedUser = user.copyWith(
                  token: newAccessToken,
                  refreshToken: newRefreshToken,
                );
                await localDataSource.cacheUser(updatedUser);
                
                // Retry original request
                print('--- Retrying original request: ${e.requestOptions.path} ---');
                e.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
                final response = await dio.fetch(e.requestOptions);
                handler.resolve(response);

                // Retry all other queued requests
                for (var request in _failedRequests) {
                  final RequestOptions options = request['options'];
                  final ErrorInterceptorHandler requestHandler = request['handler'];
                  
                  print('--- Retrying queued request: ${options.path} ---');
                  options.headers['Authorization'] = 'Bearer $newAccessToken';
                  final retryResponse = await dio.fetch(options);
                  requestHandler.resolve(retryResponse);
                }
                _failedRequests.clear();
                return;
              }
            }
          } catch (refreshError) {
            print('--- Refresh Token Failed: $refreshError ---');
            
            // Reject all queued requests
            for (var request in _failedRequests) {
              final ErrorInterceptorHandler requestHandler = request['handler'];
              requestHandler.reject(e);
            }
            _failedRequests.clear();
            
            await sl<AuthLocalDataSource>().clearCache();
          } finally {
            _isRefreshing = false;
          }
        }
        return handler.next(e);
      },
    ));
  }
}
