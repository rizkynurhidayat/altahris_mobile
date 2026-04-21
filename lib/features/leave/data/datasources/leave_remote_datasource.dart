import 'package:altahris_mobile/core/error/failures.dart';
import 'package:dio/dio.dart';
import '../models/leave_model.dart';

abstract class LeaveRemoteDataSource {
  Future<List<LeaveModel>> getLeaveHistory(String employeeId);
  Future<LeaveModel> createLeave(Map<String, dynamic> leaveData);
}

class LeaveRemoteDataSourceImpl implements LeaveRemoteDataSource {
  final Dio dio;

  LeaveRemoteDataSourceImpl(this.dio);

  @override
  Future<List<LeaveModel>> getLeaveHistory(String employeeId) async {
    try {
      final response = await dio.get(
        '/leaves',
        queryParameters: {'employee_id': employeeId},
      );

      if (response.statusCode == 200) {
        final List data = response.data['data'];
        return data.map((json) => LeaveModel.fromJson(json)).toList();
      } else {
        throw ServerFailure(
          response.data['message'] ?? 'Failed to load leave history',
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
  Future<LeaveModel> createLeave(Map<String, dynamic> leaveData) async {
    try {
      final response = await dio.post(
        '/leaves',
        data: leaveData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LeaveModel.fromJson(response.data['data']);
      } else {
        throw ServerFailure(
          response.data['message'] ?? 'Failed to create leave request',
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
