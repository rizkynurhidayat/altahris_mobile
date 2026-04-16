import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/leave.dart';
import '../repositories/leave_repository.dart';

class GetLeaveHistoryUseCase {
  final LeaveRepository repository;

  GetLeaveHistoryUseCase(this.repository);

  Future<Either<Failure, List<Leave>>> execute(String employeeId) async {
    return await repository.getLeaveHistory(employeeId);
  }
}
