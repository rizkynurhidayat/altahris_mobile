import 'package:altahris_mobile/features/home/data/datasources/home_local_datasource.dart';
import 'package:dio/dio.dart';
import 'package:altahris_mobile/core/di/injection_container.dart';
import 'package:altahris_mobile/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:altahris_mobile/main.dart';
import 'package:altahris_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:altahris_mobile/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class DioClient {
  final Dio dio;

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
    dio.interceptors.add(QueuedInterceptorsWrapper(
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
          // If we are already on the refresh endpoint and it fails, we must logout
          if (e.requestOptions.path.contains('/auth/refresh')) {
            print('--- Refresh Token Failed. Redirecting to Login. ---');
            await _handleLogout();
            return handler.next(e);
          }

          try {
            final localDataSource = sl<AuthLocalDataSource>();
            final user = await localDataSource.getCachedUser();

            if (user != null) {
              final currentToken = user.token;
              final requestToken = e.requestOptions.headers['Authorization']
                  ?.toString()
                  .replaceFirst('Bearer ', '');

              // Deduplication: If the token has already been refreshed by another request
              if (currentToken != null && currentToken != requestToken) {
                print('--- Token already refreshed by another request. Retrying... ---');
                return _retryRequest(e.requestOptions, handler);
              }

              // Notify user 
              _showNotification("Sesi berakhir. Memperbarui akses Anda...");

              print('--- Attempting to Refresh Token ---');
              
              // Perform Refresh Token using a separate Dio instance to avoid interceptor recursion
              final refreshDio = Dio(BaseOptions(
                baseUrl: 'https://altahris.com/api',
                connectTimeout: const Duration(seconds: 15),
                receiveTimeout: const Duration(seconds: 15),
              ));
              
              final refreshResponse = await refreshDio.post(
                '/auth/refresh',
                options: Options(
                  headers: {
                    'Authorization': 'Bearer ${user.refreshToken}',
                    'Accept': 'application/json',
                  },
                ),
              );

              if (refreshResponse.statusCode == 200) {
                final responseMap = refreshResponse.data;
                // Handling different potential response structures
                final dynamic data = responseMap['data'];
                String? newAccessToken;
                String? newRefreshToken;

                if (data is Map) {
                  newAccessToken = data['access_token'] ?? data['token'];
                  newRefreshToken = data['refresh_token'];
                }

                if (newAccessToken != null) {
                  print('--- Token Refreshed Successfully ---');
                  final updatedUser = user.copyWith(
                    token: newAccessToken,
                    refreshToken: newRefreshToken ?? user.refreshToken,
                  );
                  await localDataSource.cacheUser(updatedUser);
                  
                  // Retry the original request
                  return _retryRequest(e.requestOptions, handler);
                }
              }
            }
          } catch (refreshError) {
            print('--- Background Refresh Failed: $refreshError ---');
            await _handleLogout();
            return handler.next(e);
          }
        }
        return handler.next(e);
      },
    ));
  }

  Future<void> _handleLogout() async {
    try {
      await sl<AuthLocalDataSource>().clearCache();
      await sl<HomeLocalDataSources>().clearCache();
      
      if (navigatorKey.currentContext != null) {
        _showNotification(
          "Sesi Anda telah berakhir. Silakan login kembali.",
          isError: true,
        );
        navigatorKey.currentState!.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      }
    } catch (e) {
      print('Error during logout: $e');
    }
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
