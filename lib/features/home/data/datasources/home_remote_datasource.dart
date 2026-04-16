import 'package:altahris_mobile/features/attendance/data/models/attendance_model.dart';
import 'package:dio/dio.dart';

abstract class HomeRemoteDataSource {
  Future<void> clockIn();
  Future<List<AttendanceModel>> getAttendance(String id);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;
  HomeRemoteDataSourceImpl(this.dio);

  @override
  Future<void> clockIn() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    // Simulate successful clock-in response
    // return;
  }

  @override
  Future<List<AttendanceModel>> getAttendance(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    return []; // Placeholder
  }
}