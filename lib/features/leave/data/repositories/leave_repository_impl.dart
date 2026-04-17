import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/leave.dart';
import '../../domain/repositories/leave_repository.dart';
import '../datasources/leave_remote_datasource.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  final LeaveRemoteDataSource remoteDataSource;

  LeaveRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Leave>>> getLeaveHistory(String employeeId) async {
    try {
      final remoteData = await remoteDataSource.getLeaveHistory(employeeId);
      return Right(remoteData);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
