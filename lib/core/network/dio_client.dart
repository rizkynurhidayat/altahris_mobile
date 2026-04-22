import 'package:dio/dio.dart';
import 'package:altahris_mobile/core/di/injection_container.dart';
import 'package:altahris_mobile/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:altahris_mobile/main.dart';
import 'package:altahris_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:altahris_mobile/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class DioClient {
  final Dio dio;
  int _tokenErrorCount = 0;
  bool _isRefreshing = false;

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
        if (options.path.contains('/auth/login')) {
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
      onResponse: (response, handler) {
        _tokenErrorCount = 0;
        return handler.next(response);
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

        if (isTokenError && !e.requestOptions.path.contains('/auth/login')) {
          _tokenErrorCount++;
          print('--- Token Error Detected (Count: $_tokenErrorCount): $message ---');
          
          if (_tokenErrorCount >= 2 || e.requestOptions.path.contains('/auth/refresh')) {
            print('--- Token still invalid after refresh attempt. Redirecting to Login. ---');
            _tokenErrorCount = 0;
            _isRefreshing = false;
            await sl<AuthLocalDataSource>().clearCache();
            
            if (navigatorKey.currentContext != null) {
              _showNotification(
                "Sesi Anda telah berakhir secara permanen. Silakan login kembali.",
                isError: true,
              );
              navigatorKey.currentState!.pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            }
            return handler.next(e);
          }

          if (_isRefreshing) {
            // Wait for refresh to complete then retry this request
            return _retryRequest(e.requestOptions, handler);
          }

          _isRefreshing = true;

          // Notify user 
          _showNotification("Sesi berakhir. Memperbarui akses Anda...");

          try {
            final localDataSource = sl<AuthLocalDataSource>();
            final user = await localDataSource.getCachedUser();

            if (user != null && user.token != null) {
              // Perform Refresh Token using a separate Dio instance to avoid interceptor recursion
              final refreshDio = Dio(BaseOptions(baseUrl: 'https://altahris.com/api'));
              final refreshResponse = await refreshDio.post(
                '/auth/refresh',
                options: Options(
                  headers: {
                    'Authorization': 'Bearer ${user.token}',
                    'Accept': 'application/json',
                  },
                ),
              );

              if (refreshResponse.statusCode == 200) {
                final tokens = refreshResponse.data['data'];
                final newAccessToken = tokens['access_token'];
                final newRefreshToken = tokens['refresh_token'] ?? user.refreshToken;

                print('--- Token Refreshed Successfully ---');

                final updatedUser = user.copyWith(
                  token: newAccessToken,
                  refreshToken: newRefreshToken,
                );
                await localDataSource.cacheUser(updatedUser);
                
                _isRefreshing = false;
                
                // Retry the original request
                return _retryRequest(e.requestOptions, handler);
              }
            }
          } catch (refreshError) {
            print('--- Background Refresh Failed: $refreshError ---');
            _isRefreshing = false;
            await sl<AuthLocalDataSource>().clearCache();
            if (navigatorKey.currentState != null) {
              navigatorKey.currentState!.pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            }
          }
        }
        return handler.next(e);
      },
    ));
  }

  void _showNotification(String message, {bool isError = false}) {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (!isError)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            else
              const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? AppColors.error : AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
        duration: Duration(seconds: isError ? 4 : 2),
      ),
    );
  }

  Future<void> _retryRequest(RequestOptions options, ErrorInterceptorHandler handler) async {
    try {
      final localDataSource = sl<AuthLocalDataSource>();
      final user = await localDataSource.getCachedUser();
      
      final retryOptions = Options(
        method: options.method,
        headers: options.headers,
      );
      
      if (user != null && user.token != null) {
        retryOptions.headers?['Authorization'] = 'Bearer ${user.token}';
      }

      final response = await dio.request(
        options.path,
        data: options.data,
        queryParameters: options.queryParameters,
        options: retryOptions,
      );
      
      return handler.resolve(response);
    } catch (e) {
      if (e is DioException) {
        return handler.next(e);
      }
      return handler.reject(
        DioException(requestOptions: options, error: e.toString()),
      );
    }
  }
}
