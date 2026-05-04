import 'package:dio/dio.dart';
import 'package:altahris_mobile/core/di/injection_container.dart';
import 'package:altahris_mobile/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:altahris_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:altahris_mobile/main.dart';
import 'package:altahris_mobile/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class DioClient {
  final Dio dio;

  DioClient()
    : dio = Dio(
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
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (options.path.contains('/auth/login') ||
              options.path.contains('/auth/refresh')) {
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
          if (e.response?.statusCode == 401 &&
              !e.requestOptions.path.contains('/auth/login') &&
              !e.requestOptions.path.contains('/auth/refresh')) {
            await _handleRefreshToken();
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<void> _handleRefreshToken() async {
    try {
      final localDataSource = sl<AuthLocalDataSource>();
      final remoteDataSource = sl<AuthRemoteDataSource>();
      final user = await localDataSource.getCachedUser();

      if (user == null || user.token == null) {
        _showNotification(
          "No user data, please login first.",
          isError: true,
        );
        return;
      }

      // 1. Show "Invalid token" notification
      _showNotification(
        "Invalid token. Preparing to refresh...",
        isError: true,
      );

      // Wait a bit to let the user see the first notification
      await Future.delayed(const Duration(seconds: 1));

      // 2. Show "Refreshing token" notification
      _showNotification("Refreshing token...");

      // 3. Get refresh token (try cached first, fallback to static for testing)
      String? refreshTokenCookie = await localDataSource.getRefreshToken();

      // Fallback to static token provided by user for the current testing phase
      if (refreshTokenCookie == null) {
        refreshTokenCookie =
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI5Mzc0ZmIzNy05YzJhLTQ1Y2QtYmM4Yy04NGUwYmYzYTM1ODUiLCJleHAiOjE3Nzg0NjQxMDksImlhdCI6MTc3Nzg1OTMwOX0.LoO0qcRXu3KvAp20Tu3-bwK5ExNsoUGxBV85e9tRYOY";
      }

      // 4. Request /auth/refresh
      final newToken = await remoteDataSource.refreshToken(
        user.token!,
        refreshTokenCookie: refreshTokenCookie,
      );

      // 5. Update token in model and local storage
      final updatedUser = user.copyWith(token: newToken);
      await localDataSource.cacheUser(updatedUser);

      // 6. Success notification and instruction
      _showNotification(
        "Token refreshed successfully. Please pull down to reload the page.",
      );
    } catch (e) {
      debugPrint('Error during token refresh: $e');
      _showNotification(
        "error refreshing token. Please log in again.",
        isError: true,
      );
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
}
