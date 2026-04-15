import 'package:altahris_mobile/features/payslip/data/datasources/payroll_remote_datasource.dart';
import 'package:altahris_mobile/features/payslip/domain/entities/payroll.dart';
import 'package:altahris_mobile/features/payslip/domain/repositories/payroll_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

class PayrollRepositoryImpl implements PayrollRepository {
  final PayrollRemoteDataSource remoteDataSource;
  // final AuthLocalDataSource localDataSource;

  PayrollRepositoryImpl({
    required this.remoteDataSource,
    // required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Payroll>>> getAllPayrolls({
    required String id,
    required String token,
    required int month,
    required int year,
  }) async {
    try {
      final payrolls = await remoteDataSource.getAllPayroll(
        id,
        token,
        month,
        year,
      );
      // Cache user on successful login
      // await localDataSource.cacheUser(user as UserModel);
      return Right(payrolls);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Payroll>> getPayrollByID({
    required String idPayroll,
    required String token,
  }) async {
    // TODO: implement getPayrollByID

    try {
      final payroll = await remoteDataSource.getPayrollById(idPayroll, token);
      // Cache user on successful login
      // await localDataSource.cacheUser(user as UserModel);
      return Right(payroll);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
