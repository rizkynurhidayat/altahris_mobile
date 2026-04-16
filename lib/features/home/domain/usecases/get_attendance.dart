import 'package:altahris_mobile/features/attendance/domain/entities/attendance.dart';
import 'package:altahris_mobile/features/home/domain/repositories/home_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

class GetAttendanceUseCase {
  final HomeRepository repository;

  GetAttendanceUseCase(this.repository);

  Future<Either<Failure, List<Attendance>>> execute({required String id}) async {
    return await repository.getAttendance(id);
  }
}
