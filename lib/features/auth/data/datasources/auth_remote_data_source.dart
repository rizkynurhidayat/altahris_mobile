import 'package:altahris_mobile/core/error/failures.dart';
import 'package:dio/dio.dart';
import '../models/user_model.dart';
import 'auth_local_data_source.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> getUserInfo(String token);
  Future<Map<String, dynamic>> logout(String token);
  Future<String> refreshToken(String token, {String? refreshTokenCookie});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  final AuthLocalDataSource localDataSource;

  AuthRemoteDataSourceImpl(this.dio, this.localDataSource);

  void _extractAndSaveCookie(Response response) {
    try {
      final cookies = response.headers['set-cookie'];
      if (cookies != null && cookies.isNotEmpty) {
        for (var cookie in cookies) {
          if (cookie.contains('refresh_token=')) {
            final token = cookie.split('refresh_token=')[1].split(';')[0];
            localDataSource.cacheRefreshToken(token);
            break;
          }
        }
      }
    } catch (_) {}
  }

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        _extractAndSaveCookie(response);
        final loginData = response.data['data'];
        final token = loginData['access_token'];

        final userData = await getUserInfo(token);

        if (userData.role != null && userData.role! != "employee") {
          throw ServerFailure('Login failed, please use employee account!!!');
        }

        // Return UserModel with token
        return UserModel(
          id: userData.id,
          email: userData.email,
          name: userData.name,
          token: token,
          role: userData.role,
          phone: userData.phone,
          address: userData.address,
          isActive: userData.isActive,
          createdAt: userData.createdAt,
          updatedAt: userData.updatedAt,
        );
      } else {
        throw ServerFailure(
          response.data['message'] ?? 'Login failed',
          code: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw ConnectionFailure('Connection timed out');
      }

      final message =
          e.response?.data['message'] ?? e.message ?? 'Server error';
      throw ServerFailure(message, code: e.response?.statusCode ?? 0);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> logout(String token) async {
    try {
      final response = await dio.post(
        '/auth/logout',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw ServerFailure(
          response.data['message'] ?? 'Logout failed',
          code: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const ConnectionFailure('Connection timed out');
      }

      final message =
          e.response?.data['message'] ?? e.message ?? 'Server error';
      throw ServerFailure(message, code: e.response?.statusCode ?? 0);
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<UserModel> getUserInfo(String token) async {
    try {
      final response = await dio.get(
        '/users/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final userData = response.data['data'];
        return UserModel.fromJson(userData);
      } else {
        throw ServerFailure(
          response.data['message'] ?? 'Failed to fetch user data',
          code: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const ConnectionFailure('Connection timed out');
      }

      final message =
          e.response?.data['message'] ?? e.message ?? 'Server error';
      throw ServerFailure(message, code: e.response?.statusCode ?? 0);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<String> refreshToken(String token, {String? refreshTokenCookie}) async {
    try {
      final headers = {
        'Authorization': 'Bearer $token',
        'Accept': '*/*',
      };

      if (refreshTokenCookie != null) {
        headers['Cookie'] = 'refresh_token=$refreshTokenCookie';
      }

      final response = await dio.post(
        '/auth/refresh',
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        _extractAndSaveCookie(response);
        final refreshTokenData = response.data['data'];
        final newToken = refreshTokenData['access_token'] ?? refreshTokenData['acces_token'];

        if (newToken == null) {
          throw ServerFailure('New token not found in response');
        }

        return newToken;
      } else {
        throw ServerFailure(
          response.data['message'] ?? 'Refresh token failed',
          code: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const ConnectionFailure('Connection timed out');
      }

      final message =
          e.response?.data['message'] ?? e.message ?? 'Server error';
      throw ServerFailure(message, code: e.response?.statusCode ?? 0);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
