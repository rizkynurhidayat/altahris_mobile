import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;

  NotificationBloc({required this.getNotificationsUseCase})
      : super(NotificationInitial()) {
    on<GetNotifications>((event, emit) async {
      emit(NotificationLoading());
      final result = await getNotificationsUseCase(limit: event.limit);
      result.fold(
        (failure) => emit(NotificationError(failure.message)),
        (notifications) => emit(NotificationLoaded(notifications)),
      );
    });
  }
}
