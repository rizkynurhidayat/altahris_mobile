import 'package:altahris_mobile/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:altahris_mobile/features/payslip/data/datasources/payroll_remote_datasource.dart';
import 'package:altahris_mobile/features/payslip/domain/entities/payroll.dart';
import 'package:altahris_mobile/features/payslip/domain/repositories/payroll_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

class PayrollRepositoryImpl implements PayrollRepository {
  final PayrollRemoteDataSource remoteDataSource;
  final AuthLocalDataSource authLocalDataSource;
  // final AuthLocalDataSource localDataSource;

  PayrollRepositoryImpl({
    required this.remoteDataSource,
    required this.authLocalDataSource,
    // required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Payroll>>> getPayrollsMe() async {
    // TODO: implement getPayrollsMe
    try {
      final user = await authLocalDataSource.getCachedUser();
      if (user == null || user.token == null) {
        return const Left(
          ServerFailure("Local Data Not found or Token is null"),
        );
      }

      final payrolls = await remoteDataSource.getPayrollMe(user.token!);
      return Right(payrolls);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
