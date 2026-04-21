import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/leave.dart';
import '../repositories/leave_repository.dart';

class CreateLeaveUseCase {
  final LeaveRepository repository;

  CreateLeaveUseCase(this.repository);

  Future<Either<Failure, Leave>> execute(Map<String, dynamic> leaveData) async {
    return await repository.createLeave(leaveData);
  }
}
