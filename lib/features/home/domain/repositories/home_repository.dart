import 'package:altahris_mobile/features/attendance/domain/entities/attendance.dart';
import 'package:altahris_mobile/features/home/domain/entities/Employee.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<Attendance>>> getAttendance();
  Future<Either<Failure, Employee>> getEmployeeMe();
  Future<Either<Failure, void>> clockIn({
    required String imagePath,
    required double latitude,
    required double longitude,
  });
  Future<Either<Failure, void>> clockOut({
    required String imagePath,
    required double latitude,
    required double longitude,
  });
}
