import 'package:get_it/get_it.dart';
import 'data/datasources/notification_remote_datasource.dart';
import 'data/repositories/notification_repository_impl.dart';
import 'domain/repositories/notification_repository.dart';
import 'domain/usecases/get_notifications_usecase.dart';
import 'presentation/bloc/notification_bloc.dart';

void initNotification(GetIt sl) {
  // Bloc
  sl.registerFactory(
    () => NotificationBloc(getNotificationsUseCase: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));

  // Repository
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(sl()),
  );
}
