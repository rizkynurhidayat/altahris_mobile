import 'package:altahris_mobile/features/attendance/domain/entities/attendance.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<Attendance>>> getAttendance(String id);
  Future<Either<Failure, List<Attendance>>> getEmployee(String id);
}
