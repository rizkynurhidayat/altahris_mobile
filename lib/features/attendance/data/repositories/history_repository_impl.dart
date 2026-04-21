import 'package:altahris_mobile/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:altahris_mobile/features/home/data/datasources/home_remote_datasource.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/repositories/history_repository.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HomeRemoteDataSource remoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  HistoryRepositoryImpl({required this.remoteDataSource, required this.authLocalDataSource, });

  @override
  Future<Either<Failure, List<Attendance>>> getAttendanceHistory(String id) async {
    try {
      final user = await authLocalDataSource.getCachedUser();
      if (user == null || user.token == null) {
        return const Left(ServerFailure("Local Data Not found or Token is null"));
      }
      
      final employeeMe = await remoteDataSource.getEmployeeMe();
      

      final remoteHistory = await remoteDataSource.getAttendance(employeeMe.id,);
      return Right(remoteHistory);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
