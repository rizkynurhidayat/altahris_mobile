import 'package:altahris_mobile/features/visit/data/datasources/visit_remote_datasource.dart';
import 'package:altahris_mobile/features/visit/data/repositories/visit_repository_impl.dart';
import 'package:altahris_mobile/features/visit/domain/repositories/visit_repository.dart';
import 'package:altahris_mobile/features/visit/domain/usecases/start_visit_usecase.dart';
import 'package:altahris_mobile/features/visit/presentation/bloc/visit_bloc.dart';
import 'package:get_it/get_it.dart';

void initVisit(GetIt sl) {
  // BLoC
  sl.registerFactory(() => VisitBloc(
        startVisitUseCase: sl(),
      ));

  // Use Cases
  sl.registerLazySingleton(() => StartVisitUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<VisitRepository>(
    () => VisitRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<VisitRemoteDataSource>(
    () => VisitRemoteDataSourceImpl(sl()),
  );
}