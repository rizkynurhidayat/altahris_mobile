import 'package:altahris_mobile/features/home/data/datasources/home_local_datasource.dart';
import 'package:altahris_mobile/features/home/data/datasources/home_remote_datasource.dart';
import 'package:altahris_mobile/features/home/domain/entities/Employee.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/leave.dart';
import '../../domain/repositories/leave_repository.dart';
import '../datasources/leave_remote_datasource.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  final LeaveRemoteDataSource remoteDataSource;
  final HomeLocalDataSources homeLocalDataSource;
  final HomeRemoteDataSource homeRemoteDataSource;

  LeaveRepositoryImpl({
    required this.remoteDataSource,
    required this.homeLocalDataSource,
    required this.homeRemoteDataSource,
  });

  @override
  Future<Either<Failure, List<Leave>>> getLeaveHistory() async {
    try {
      Employee? employeeMe = await homeLocalDataSource.getCachedEmployee();
      if (employeeMe == null) {
        final remoteEmployee = await homeRemoteDataSource.getEmployeeMe();
        await homeLocalDataSource.cacheEmployee(remoteEmployee);
        employeeMe = remoteEmployee;
      }
      final remoteData = await remoteDataSource.getLeaveHistory(employeeMe.id);
      return Right(remoteData);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
