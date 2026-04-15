import 'dart:convert';

import 'package:altahris_mobile/features/payslip/data/models/payroll_model.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';

abstract class PayrollRemoteDataSource {
  Future<List<PayrollModel>> getAllPayroll(
    String id,
    String token,
    int month,
    int year,
  );
  Future<PayrollModel> getPayrollById(String idPayroll, String token);
}

class PayrollRemoteDataSourceImpl implements PayrollRemoteDataSource {
  final Dio dio;

  PayrollRemoteDataSourceImpl(this.dio);

  @override
  Future<List<PayrollModel>> getAllPayroll(
    String id,
    String token,
    int month,
    int year,
  ) async {
    try {
      final response = await dio.get(
        '/payrolls',
        options: Options(headers: {'Authorization': 'Beareer $token'}),
        data: {'employee_id': id, 'month': month, 'year': year},
      );

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> payrollsResponse = jsonDecode(
          response.data['data'],
        );
        return payrollsResponse.map((e) => PayrollModel.fromJson(e)).toList();
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
  Future<PayrollModel> getPayrollById(String idPayroll, String token) async {
    try {
      final response = await dio.get(
        '/payrolls/$idPayroll',
        options: Options(headers: {'Authorization': 'Beareer $token'}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> payrollsResponse = jsonDecode(
          response.data['data'],
        );
        return PayrollModel.fromJson(payrollsResponse);
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
