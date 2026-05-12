import 'package:altahris_mobile/features/visit_plan/data/datasources/visit_plan_remote_datasource.dart';
import 'package:altahris_mobile/features/visit_plan/data/repositories/visit_plan_repository_impl.dart';
import 'package:altahris_mobile/features/visit_plan/domain/repositories/visit_plan_repository.dart';
import 'package:altahris_mobile/features/visit_plan/domain/usecases/create_visit_plan_usecase.dart';
import 'package:altahris_mobile/features/visit_plan/domain/usecases/get_visit_plans_usecase.dart';
import 'package:altahris_mobile/features/visit_plan/presentation/bloc/visit_plan_bloc.dart';
import 'package:get_it/get_it.dart';

void initVisitPlanInjector(GetIt sl)  {
  // BLoC
  sl.registerFactory(() => VisitPlanBloc(
        createVisitPlanUseCase: sl(),
        getVisitPlansUseCase: sl(),
      ));

  // UseCases
  sl.registerLazySingleton(() => CreateVisitPlanUseCase(sl()));
  sl.registerLazySingleton(() => GetVisitPlansUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<VisitPlanRepository>(
      () => VisitPlanRepositoryImpl(remoteDataSource: sl()));

  // DataSources
  sl.registerLazySingleton<VisitPlanRemoteDataSource>(
      () => VisitPlanRemoteDataSourceImpl(sl()));
}
