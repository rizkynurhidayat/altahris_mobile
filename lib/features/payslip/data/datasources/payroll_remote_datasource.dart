import 'dart:convert';

import 'package:altahris_mobile/features/payslip/data/models/payroll_model.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';

abstract class PayrollRemoteDataSource {
  Future<List<PayrollModel>> getPayrollMe(String token);
}

class PayrollRemoteDataSourceImpl implements PayrollRemoteDataSource {
  final Dio dio;

  PayrollRemoteDataSourceImpl(this.dio);

  @override
  Future<List<PayrollModel>> getPayrollMe(String token) async {
    try {
      final response = await dio.get(
        '/payrolls/me',
        options: Options(headers: {'Authorization': 'Beareer $token'}),
      );

      if (response.statusCode == 200) {
      final dynamic rawData = response.data['data'];

        print("TESTING");
        print(rawData['data']);

        List<dynamic> listToMap = [];

        if (rawData is List) {
          listToMap = rawData;
        } else if (rawData is String) {
          final decoded = json.decode(rawData);
          if (decoded is List) {
            listToMap = decoded;
          } else if (decoded is Map && decoded['data'] is List) {
            listToMap = decoded['data'];
          }
        } else if (rawData is Map && rawData['data'] is List) {
          listToMap = rawData['data'];
        }

        // return listToMap.map((e) => AttendanceModel.fromJson(e)).toList();

        return listToMap.map((e) => PayrollModel.fromJson(e)).toList();
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
}

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

