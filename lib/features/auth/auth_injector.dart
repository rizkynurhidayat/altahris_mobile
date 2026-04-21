import 'package:get_it/get_it.dart';
import 'package:altahris_mobile/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:altahris_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:altahris_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:altahris_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:altahris_mobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:altahris_mobile/features/auth/presentation/bloc/auth_bloc.dart';

/// Dependency Injection for Auth Feature
///
/// This file registers all the dependencies required for the Auth feature,
/// including Bloc, UseCases, Repositories, and DataSources.
void initAuth(GetIt sl) {
  // BLoC
  sl.registerFactory(() => AuthBloc(
        loginUseCase: sl(),
        repository: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      homeLocalDataSource: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );
}
