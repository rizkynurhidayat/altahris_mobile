import 'package:get_it/get_it.dart';
import 'package:altahris_mobile/features/payslip/data/datasources/payroll_remote_datasource.dart';
import 'package:altahris_mobile/features/payslip/data/repositories/payroll_repository_impl.dart';
import 'package:altahris_mobile/features/payslip/domain/repositories/payroll_repository.dart';
import 'package:altahris_mobile/features/payslip/domain/usecases/getAllPayroll_usecase.dart';
import 'package:altahris_mobile/features/payslip/domain/usecases/getPayrollById_usecase.dart';

/// Dependency Injection for Payslip Feature
void initPayslip(GetIt sl) {
  // Use Cases
  sl.registerLazySingleton(() => GetAllPayrollUsecase(sl()));
  sl.registerLazySingleton(() => GetPayrollByIdUsecase(sl()));

  // Repositories
  sl.registerLazySingleton<PayrollRepository>(
    () => PayrollRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<PayrollRemoteDataSource>(
    () => PayrollRemoteDataSourceImpl(sl()),
  );
}
