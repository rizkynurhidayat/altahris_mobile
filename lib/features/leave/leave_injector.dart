import 'package:get_it/get_it.dart';
import 'data/datasources/leave_remote_datasource.dart';
import 'data/repositories/leave_repository_impl.dart';
import 'domain/repositories/leave_repository.dart';
import 'domain/usecases/get_leave_history_usecase.dart';
import 'domain/usecases/create_leave_usecase.dart';
import 'presentation/bloc/leave_bloc.dart';

void initLeave(GetIt sl) {
  // Bloc
  sl.registerFactory(
    () => LeaveBloc(
      getLeaveHistoryUseCase: sl(),
      createLeaveUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetLeaveHistoryUseCase(sl()));
  sl.registerLazySingleton(() => CreateLeaveUseCase(sl()));

  // Repository
  sl.registerLazySingleton<LeaveRepository>(
    () => LeaveRepositoryImpl(
      remoteDataSource: sl(),
      homeLocalDataSource: sl(),
      homeRemoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<LeaveRemoteDataSource>(
    () => LeaveRemoteDataSourceImpl(sl()),
  );
}
