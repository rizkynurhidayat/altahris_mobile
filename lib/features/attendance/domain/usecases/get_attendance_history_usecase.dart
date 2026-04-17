import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/attendance.dart';
import '../repositories/history_repository.dart';

class GetAttendanceHistoryUseCase {
  final HistoryRepository repository;

  GetAttendanceHistoryUseCase(this.repository);

  Future<Either<Failure, List<Attendance>>> execute({required String id}) async {
    return await repository.getAttendanceHistory(id);
  }
}
