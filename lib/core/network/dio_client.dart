import 'package:dio/dio.dart';
import 'package:altahris_mobile/core/di/injection_container.dart';
import 'package:altahris_mobile/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:altahris_mobile/main.dart';
import 'package:altahris_mobile/features/home/presentation/pages/home_page.dart';
import 'package:altahris_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';

class DioClient {
  final Dio dio;
  int _tokenErrorCount = 0;

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
      onResponse: (response, handler) {
        // Reset count on successful response
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

        if (isTokenError) {
          _tokenErrorCount++;
          print('--- Token Error Detected (Count: $_tokenErrorCount): $message ---');
          
          if (_tokenErrorCount >= 2) {
            print('--- Token still invalid after 2 attempts. Redirecting to Login. ---');
            _tokenErrorCount = 0; // Reset counter
            await sl<AuthLocalDataSource>().clearCache();
            
            if (navigatorKey.currentState != null) {
              navigatorKey.currentState!.pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            }
          } else {
            print('--- First invalid token error. Waiting 3s and going Home. ---');
            Future.delayed(const Duration(seconds: 3), () async {
              final user = await sl<AuthLocalDataSource>().getCachedUser();
              if (user != null && navigatorKey.currentState != null) {
                navigatorKey.currentState!.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => HomePage(user: user)),
                  (route) => false,
                );
              }
            });
          }
        }
        return handler.next(e);
      },
    ));
  }
}
