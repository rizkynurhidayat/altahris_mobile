import 'package:altahris_mobile/core/error/failures.dart';
import 'package:altahris_mobile/features/attendance/domain/entities/attendance.dart';
import 'package:altahris_mobile/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:altahris_mobile/features/home/data/datasources/home_local_datasource.dart';
import 'package:altahris_mobile/features/home/data/datasources/home_remote_datasource.dart';
import 'package:altahris_mobile/features/home/domain/entities/Employee.dart';
import 'package:altahris_mobile/features/home/domain/repositories/home_repository.dart';
import 'package:dartz/dartz.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localData;
  final HomeLocalDataSources homeLocalDataSource;

  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.localData,
    required this.homeLocalDataSource,
  });

  @override
  Future<Either<Failure, List<Attendance>>> getAttendance() async {
    try {
      final employeeMe = await remoteDataSource.getEmployeeMe();
      final result = await remoteDataSource.getAttendance(employeeMe.id);
      return Right(result);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Employee>> getEmployeeMe() async {
    try {
      final result = await remoteDataSource.getEmployeeMe();
      return Right(result);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clockIn({
    required String imagePath,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final employeeMe = await remoteDataSource.getEmployeeMe();
      
      await remoteDataSource.clockIn(
        employeeId: employeeMe.id,
        imagePath: imagePath,
        latitude: latitude,
        longitude: longitude,
      );

      return const Right(null);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clockOut({
    required String imagePath,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final employeeMe = await remoteDataSource.getEmployeeMe();
      
      await remoteDataSource.clockOut(
        employeeId: employeeMe.id,
        imagePath: imagePath,
        latitude: latitude,
        longitude: longitude,
      );

      return const Right(null);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(e.toString()));
    }
  }
}
