import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_leave_history_usecase.dart';
import 'leave_event.dart';
import 'leave_state.dart';

class LeaveBloc extends Bloc<LeaveEvent, LeaveState> {
  final GetLeaveHistoryUseCase getLeaveHistoryUseCase;

  LeaveBloc({required this.getLeaveHistoryUseCase}) : super(LeaveInitial()) {
    on<FetchLeaveHistory>(_onFetchLeaveHistory);
  }

  Future<void> _onFetchLeaveHistory(
    FetchLeaveHistory event,
    Emitter<LeaveState> emit,
  ) async {
    emit(LeaveLoading());
    final result = await getLeaveHistoryUseCase.execute();
    result.fold(
      (failure) => emit(LeaveFailure(failure.message)),
      (leaves) => emit(LeaveLoaded(leaves)),
    );
  }
}
