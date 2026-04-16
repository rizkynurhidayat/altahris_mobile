import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/attendance.dart';

abstract class HistoryRepository {
  Future<Either<Failure, List<Attendance>>> getAttendanceHistory(String id);
}
