import 'package:get_it/get_it.dart';
import 'package:altahris_mobile/features/attendance/data/repositories/history_repository_impl.dart';
import 'package:altahris_mobile/features/attendance/domain/repositories/history_repository.dart';
import 'package:altahris_mobile/features/attendance/domain/usecases/get_attendance_history_usecase.dart';
import 'package:altahris_mobile/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:altahris_mobile/features/home/data/datasources/home_local_datasource.dart';

/// Dependency Injection for History Feature
void initHistory(GetIt sl) {
  // BLoC
  sl.registerFactory(() => AttendanceBloc(
        getAttendanceHistoryUseCase: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton(() => GetAttendanceHistoryUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<HistoryRepository>(
    () => HistoryRepositoryImpl(
      remoteDataSource: sl(),
      authLocalDataSource: sl(),
      homeLocalDataSource: sl(),
    ),
  );

  // Data Sources
  // sl.registerLazySingleton<HomeRemoteDataSource>(
  //   () => HomeRemoteDataSourceImpl(sl()),
  // );
  // sl.registerLazySingleton<HomeLocalDataSources>(
  //   () => HomeLocalDataSourcesImpl(sl()),
  // );
  // sl.registerLazySingleton<AuthLocalDataSource>(
  //   () => AuthLocalDataSourceImpl(sl()),
  // );
}
