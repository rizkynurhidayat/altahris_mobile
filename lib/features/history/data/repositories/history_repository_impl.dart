import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/repositories/history_repository.dart';
import '../datasources/history_remote_data_source.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryRemoteDataSource remoteDataSource;

  HistoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Attendance>>> getAttendanceHistory() async {
    try {
      final remoteHistory = await remoteDataSource.getAttendanceHistory();
      return Right(remoteHistory);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
