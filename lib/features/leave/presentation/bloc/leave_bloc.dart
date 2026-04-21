import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_leave_history_usecase.dart';
import '../../domain/usecases/create_leave_usecase.dart';
import 'leave_event.dart';
import 'leave_state.dart';

class LeaveBloc extends Bloc<LeaveEvent, LeaveState> {
  final GetLeaveHistoryUseCase getLeaveHistoryUseCase;
  final CreateLeaveUseCase createLeaveUseCase;

  LeaveBloc({
    required this.getLeaveHistoryUseCase,
    required this.createLeaveUseCase,
  }) : super(LeaveInitial()) {
    on<FetchLeaveHistory>(_onFetchLeaveHistory);
    on<CreateLeaveRequest>(_onCreateLeaveRequest);
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

  Future<void> _onCreateLeaveRequest(
    CreateLeaveRequest event,
    Emitter<LeaveState> emit,
  ) async {
    emit(LeaveLoading());
    final result = await createLeaveUseCase.execute(event.leaveData);
    result.fold(
      (failure) => emit(LeaveFailure(failure.message)),
      (_) => emit(LeaveRequestSuccess()),
    );
  }
}
