import 'package:altahris_mobile/features/home/data/datasources/home_local_datasource.dart';
import 'package:altahris_mobile/features/home/domain/usecases/clock_in.dart';
import 'package:altahris_mobile/features/home/domain/usecases/clock_out.dart';
import 'package:altahris_mobile/features/home/domain/usecases/get_employee.dart';
import 'package:altahris_mobile/features/home/domain/usecases/get_attendance.dart';
import 'package:altahris_mobile/features/home/presentation/bloc/home_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:altahris_mobile/features/home/data/datasources/home_remote_datasource.dart';
import 'package:altahris_mobile/features/home/data/repositories/home_repository_impl.dart';
import 'package:altahris_mobile/features/home/domain/repositories/home_repository.dart';

/// Dependency Injection for Home Feature
void initHome(GetIt sl) {
  // Bloc
  sl.registerFactory(
    () => HomeBloc(
      getAttendanceUseCase: sl(),
      getEmployeeMeUseCase: sl(),
      clockInUseCase: sl(),
      clockOutUseCase: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetAttendanceUseCase(sl()));
  sl.registerLazySingleton(() => GetEmployeeMeUseCase(sl()));
  sl.registerLazySingleton(() => ClockInUseCase(sl()));
  sl.registerLazySingleton(() => ClockOutUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      remoteDataSource: sl(),
      localData: sl(),
      homeLocalDataSource: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<HomeLocalDataSources>(
    () => HomeLocalDataSourcesImpl(sl()),
  );
}
