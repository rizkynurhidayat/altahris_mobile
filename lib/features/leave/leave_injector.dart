import 'package:altahris_mobile/features/home/data/datasources/home_local_datasource.dart';
import 'package:altahris_mobile/features/home/data/datasources/home_remote_datasource.dart';
import 'package:get_it/get_it.dart';
import 'data/datasources/leave_remote_datasource.dart';
import 'data/repositories/leave_repository_impl.dart';
import 'domain/repositories/leave_repository.dart';
import 'domain/usecases/get_leave_history_usecase.dart';
import 'presentation/bloc/leave_bloc.dart';

void initLeave(GetIt sl) {
  // Bloc
  sl.registerFactory(() => LeaveBloc(getLeaveHistoryUseCase: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetLeaveHistoryUseCase(sl()));

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
