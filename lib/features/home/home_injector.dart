import 'package:altahris_mobile/features/home/domain/usecases/get_attendance.dart';
import 'package:altahris_mobile/features/home/presentation/bloc/home_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:altahris_mobile/features/home/data/datasources/home_remote_datasource.dart';
import 'package:altahris_mobile/features/home/data/repositories/home_repository_impl.dart';
import 'package:altahris_mobile/features/home/domain/repositories/home_repository.dart';

/// Dependency Injection for Home Feature
void initHome(GetIt sl) {
  // Bloc
  sl.registerFactory(() => HomeBloc(getAttendanceUseCase: sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetAttendanceUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(sl()),
  );
}
