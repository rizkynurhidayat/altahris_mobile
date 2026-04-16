import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_attendance_history_usecase.dart';
import 'attendance_event.dart';
import 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final GetAttendanceHistoryUseCase getAttendanceHistoryUseCase;

  AttendanceBloc({required this.getAttendanceHistoryUseCase}) : super(AttendanceInitial()) {
    on<FetchAttendanceHistory>(_onFetchAttendanceHistory);
  }

  Future<void> _onFetchAttendanceHistory(
    FetchAttendanceHistory event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceLoading());
    final result = await getAttendanceHistoryUseCase.execute(id: '');
    result.fold(
      (failure) => emit(AttendanceFailure(failure.message)),
      (history) => emit(AttendanceLoaded(history)),
    );
  }
}
