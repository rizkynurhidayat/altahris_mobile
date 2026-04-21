import 'dart:convert';
import 'dart:io';

import 'package:altahris_mobile/core/error/failures.dart';
import 'package:altahris_mobile/features/attendance/data/models/attendance_model.dart';
import 'package:altahris_mobile/features/home/data/models/employee_model.dart';
import 'package:dio/dio.dart';

abstract class HomeRemoteDataSource {
  Future<void> clockIn({
    required String employeeId,
    required String imagePath,
    required double latitude,
    required double longitude,
  });
  Future<void> clockOut({
    required String employeeId,
    required String imagePath,
    required double latitude,
    required double longitude,
  });
  Future<List<AttendanceModel>> getAttendance(String idEmployee);
  Future<EmployeeModel> getEmployeeMe();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSourceImpl(this.dio);

  @override
  Future<void> clockIn({
    required String employeeId,
    required String imagePath,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final bytes = await File(imagePath).readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await dio.post(
        '/attendances/clock-in',
        data: {
          'employee_id': employeeId,
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
          'image': 'data:image/jpeg;base64,$base64Image',
        },
        options: Options(
          contentType: 'application/json',
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerFailure(response.data['message'] ?? 'Failed to clock in');
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
  Future<void> clockOut({
    required String employeeId,
    required String imagePath,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final bytes = await File(imagePath).readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await dio.put(
        '/attendances/clock-out',
        data: {
          'employee_id': employeeId,
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
          'image': 'data:image/jpeg;base64,$base64Image',
        },
        options: Options(
          contentType: 'application/json',
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerFailure(response.data['message'] ?? 'Failed to clock out');
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
  Future<List<AttendanceModel>> getAttendance(String idEmployee) async {
    try {
      final response = await dio.get(
        '/attendances',
        queryParameters: {"employee_id": idEmployee},
      );

      if (response.statusCode == 200) {
        final dynamic rawData = response.data['data'];

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

        return listToMap.map((e) => AttendanceModel.fromJson(e)).toList();
      } else {
        throw ServerFailure(
          response.data['message'] ?? 'Failed to fetch attendance data',
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

  @override
  Future<EmployeeModel> getEmployeeMe() async {
    try {
      final response = await dio.get('/employees/me');

      if (response.statusCode == 200) {
        final employeeData = response.data['data'];
        final emp = EmployeeModel.fromJson(employeeData);
        return emp;
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
