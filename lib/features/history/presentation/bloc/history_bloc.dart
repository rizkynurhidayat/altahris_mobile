import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_attendance_history_usecase.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetAttendanceHistoryUseCase getAttendanceHistoryUseCase;

  HistoryBloc({required this.getAttendanceHistoryUseCase}) : super(HistoryInitial()) {
    on<FetchAttendanceHistory>(_onFetchAttendanceHistory);
  }

  Future<void> _onFetchAttendanceHistory(
    FetchAttendanceHistory event,
    Emitter<HistoryState> emit,
  ) async {
    emit(HistoryLoading());
    final result = await getAttendanceHistoryUseCase.execute(id: '');
    result.fold(
      (failure) => emit(HistoryFailure(failure.message)),
      (history) => emit(HistoryLoaded(history)),
    );
  }
}
