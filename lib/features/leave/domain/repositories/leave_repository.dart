import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/leave.dart';

abstract class LeaveRepository {
  Future<Either<Failure, List<Leave>>> getLeaveHistory();
  Future<Either<Failure, Leave>> createLeave(Map<String, dynamic> leaveData);
}
