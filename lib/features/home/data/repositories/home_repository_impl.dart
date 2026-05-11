import 'package:altahris_mobile/core/error/failures.dart';
import 'package:altahris_mobile/features/attendance/domain/entities/attendance.dart';
import 'package:altahris_mobile/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:altahris_mobile/features/home/data/datasources/home_local_datasource.dart';
import 'package:altahris_mobile/features/home/data/datasources/home_remote_datasource.dart';
import 'package:altahris_mobile/features/home/domain/entities/employee.dart';
import 'package:altahris_mobile/features/home/domain/repositories/home_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';

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
      Employee? employeeMe = await homeLocalDataSource.getCachedEmployee();
      if (employeeMe == null) {
        final remoteEmployee = await remoteDataSource.getEmployeeMe();
        await homeLocalDataSource.cacheEmployee(remoteEmployee);
        employeeMe = remoteEmployee;
      }
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
      final cachedEmployee = await homeLocalDataSource.getCachedEmployee();
      if (cachedEmployee != null) {
        return Right(cachedEmployee);
      }
      final result = await remoteDataSource.getEmployeeMe();
      await homeLocalDataSource.cacheEmployee(result);
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
    required String notes,
  }) async {
    try {
      Employee? employeeMe = await homeLocalDataSource.getCachedEmployee();
      if (employeeMe == null) {
        final remoteEmployee = await remoteDataSource.getEmployeeMe();
        await homeLocalDataSource.cacheEmployee(remoteEmployee);
        employeeMe = remoteEmployee;
      }

      await remoteDataSource.clockIn(
        employeeId: employeeMe.id,
        imagePath: imagePath,
        latitude: latitude,
        longitude: longitude,
        notes: notes,
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
    required String notes,
  }) async {
    try {
      Employee? employeeMe = await homeLocalDataSource.getCachedEmployee();
      if (employeeMe == null) {
        final remoteEmployee = await remoteDataSource.getEmployeeMe();
        await homeLocalDataSource.cacheEmployee(remoteEmployee);
        employeeMe = remoteEmployee;
      }

      // Find today's attendance record
      final attendances = await remoteDataSource.getAttendance(employeeMe.id);
      final now = DateTime.now();
      final todayStr = DateFormat('yyyy-MM-dd').format(now);

      final todayAttendance = attendances.firstWhere(
        (a) => a.date == todayStr || a.clockIn.contains(todayStr),
        orElse: () =>
            throw const ServerFailure("Today's attendance record not found"),
      );

      await remoteDataSource.clockOut(
        attendanceId: todayAttendance.id,
        employeeId: employeeMe.id,
        imagePath: imagePath,
        latitude: latitude,
        longitude: longitude,
        notes: notes,
      );

      return const Right(null);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(e.toString()));
    }
  }
}
