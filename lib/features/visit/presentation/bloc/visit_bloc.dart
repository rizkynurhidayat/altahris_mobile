import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/start_visit_usecase.dart';
import 'visit_event.dart';
import 'visit_state.dart';

class VisitBloc extends Bloc<VisitEvent, VisitState> {
  final StartVisitUseCase startVisitUseCase;

  VisitBloc({required this.startVisitUseCase}) : super(VisitInitial()) {
    on<StartVisitEvent>(_onStartVisit);
  }

  Future<void> _onStartVisit(
    StartVisitEvent event,
    Emitter<VisitState> emit,
  ) async {
    emit(VisitLoading());
    final result = await startVisitUseCase.execute(event.toMap);
    result.fold(
      (failure) => emit(VisitFailure(failure.message)),
      (visit) => emit(VisitSuccess(visit)),
    );
  }
}