import 'package:dio/dio.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> getUserById(String token, String id);
  Future<void> logout(String token);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<UserModel> login(String email, String password) async {
    // MOCK: Langsung return data dummy agar bisa login tanpa API
    await Future.delayed(
      const Duration(milliseconds: 100),
    ); // Simulasi network delay

    return UserModel(
      id: '1',
      email: email,
      name: 'User Dummy',
      token: 'dummy_token_altahris_123',
    );

    /* 
    // Implementasi API sesungguhnya (dimatikan sementara)
    try {
      final response = await dio.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final loginResponse = response.data['data'];
        final token = loginResponse['access_token'];
      

        return UserModel.fromJson(userData);
      } else {
        throw ServerFailure(response.data['message'] ?? 'Login failed');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || 
          e.type == DioExceptionType.receiveTimeout) {
        throw const ConnectionFailure('Connection timed out');
      }
      
      final message = e.response?.data['message'] ?? e.message ?? 'Server error';
      throw ServerFailure(message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
    */
  }

  @override
  Future<void> logout(String token) async {
    // TODO: implement logout
    /* 
    // Implementasi API sesungguhnya (dimatikan sementara)
    try {
      final response = await dio.post(
        '/auth/logout', options: Options(headers: {
          'Authorization': 'Bearer $token'
        })
      );

      if (response.statusCode == 200) {
        final succes = response.data['success'] ?? false;
      } else {
        throw ServerFailure(response.data['message'] ?? 'Logout failed');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || 
          e.type == DioExceptionType.receiveTimeout) {
        throw const ConnectionFailure('Connection timed out');
      }
      
      final message = e.response?.data['message'] ?? e.message ?? 'Server error';
      throw ServerFailure(message);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
    */
  }

  @override
  Future<UserModel> getUserById(String token, String id) async {
    // TODO: implement getUserById
    /*
    try {
      final response = await dio.post(
        '/user/$id',
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
  */
    return UserModel(id: "id", email: "email", name: "name");
  }
}
