import 'package:altahris_mobile/core/error/failures.dart';
import 'package:dio/dio.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> getUserInfo(String token);
  Future<Map<String,dynamic>> logout(String token);
  Future<Map<String, dynamic>> refreshToken(String refreshToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final loginData = response.data['data'];
        final token = loginData['access_token'];
        final refreshToken = loginData['refresh_token'];

        final userData = await getUserInfo(token);

        if(userData.role != null && userData.role! != "employee" ){
            throw ServerFailure('Login failed, please use employee account!!!');
        }
        
        // Return UserModel with tokens
        return UserModel(
          id: userData.id,
          email: userData.email,
          name: userData.name,
          token: token,
          refreshToken: refreshToken,
          role: userData.role,
          phone: userData.phone,
          address: userData.address,
          isActive: userData.isActive,
          createdAt: userData.createdAt,
          updatedAt: userData.updatedAt,
        );
      } else {
        throw ServerFailure(response.data['message'] ?? 'Login failed');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const ConnectionFailure('Connection timed out');
      }

      final message =
          e.response?.data['message'] ?? e.message ?? 'Server error';
      throw ServerFailure(message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    try {
      final response = await dio.post(
        '/auth/refresh',
        options: Options(
          headers: {
            "Authorization": "Bearer $refreshToken"
          }
        ),
      );

      if (response.statusCode == 200) {
        return response.data['data'];
      } else {
        throw ServerFailure(response.data['message'] ?? 'Refresh token failed');
      }
    } on DioException catch (e) {
      final message = e.response?.data['message'] ?? e.message ?? 'Refresh token error';
      throw ServerFailure(message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> logout(String token) async {
    try {
      final response = await dio.post(
        '/auth/logout',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw ServerFailure(response.data['message'] ?? 'Logout failed');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const ConnectionFailure('Connection timed out');
      }

      final message =
          e.response?.data['message'] ?? e.message ?? 'Server error';
      throw ServerFailure(message);
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
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const ConnectionFailure('Connection timed out');
      }

      final message =
          e.response?.data['message'] ?? e.message ?? 'Server error';
      throw ServerFailure(message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
