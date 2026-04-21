import 'package:altahris_mobile/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:altahris_mobile/features/home/data/datasources/home_local_datasource.dart';
import 'package:altahris_mobile/features/home/data/datasources/home_remote_datasource.dart';
import 'package:altahris_mobile/features/home/domain/entities/Employee.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/attendance.dart';
import '../../domain/repositories/history_repository.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HomeRemoteDataSource remoteDataSource;
  final AuthLocalDataSource authLocalDataSource;
  final HomeLocalDataSources homeLocalDataSource;

  HistoryRepositoryImpl({
    required this.remoteDataSource,
    required this.authLocalDataSource,
    required this.homeLocalDataSource,
  });

  @override
  Future<Either<Failure, List<Attendance>>> getAttendanceHistory() async {
    try {
      final user = await authLocalDataSource.getCachedUser();
      if (user == null || user.token == null) {
        return const Left(ServerFailure("Local Data Not found or Token is null"));
      }
      
      Employee? employeeMe = await homeLocalDataSource.getCachedEmployee();
      if (employeeMe == null) {
        final remoteEmployee = await remoteDataSource.getEmployeeMe();
        await homeLocalDataSource.cacheEmployee(remoteEmployee);
        employeeMe = remoteEmployee;
      }

      final remoteHistory = await remoteDataSource.getAttendance(employeeMe.id);
      return Right(remoteHistory);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
