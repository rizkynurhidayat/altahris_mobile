import 'package:get_it/get_it.dart';
import 'package:altahris_mobile/features/payslip/data/datasources/payroll_remote_datasource.dart';
import 'package:altahris_mobile/features/payslip/data/repositories/payroll_repository_impl.dart';
import 'package:altahris_mobile/features/payslip/domain/repositories/payroll_repository.dart';
import 'package:altahris_mobile/features/payslip/domain/usecases/get_all_payroll_usecase.dart';
import 'package:altahris_mobile/features/payslip/presentation/bloc/payslip_bloc.dart';

/// Dependency Injection for Payslip Feature
void initPayslip(GetIt sl) {
  // BLoCs
  sl.registerFactory(() => PayslipBloc(getPayrollsMeUsecase: sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetPayrollsMeUsecase(sl()));

  // Repositories
  sl.registerLazySingleton<PayrollRepository>(
    () => PayrollRepositoryImpl(
      remoteDataSource: sl(),
      authLocalDataSource: sl()
    ),
  );

  // Data Sources
  sl.registerLazySingleton<PayrollRemoteDataSource>(
    () => PayrollRemoteDataSourceImpl(sl()),
  );
}
