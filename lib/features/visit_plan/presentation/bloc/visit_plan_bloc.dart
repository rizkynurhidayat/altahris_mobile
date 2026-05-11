import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_visit_plan_usecase.dart';
import '../../domain/usecases/get_visit_plans_usecase.dart';
import 'visit_plan_event.dart';
import 'visit_plan_state.dart';

class VisitPlanBloc extends Bloc<VisitPlanEvent, VisitPlanState> {
  final CreateVisitPlanUseCase createVisitPlanUseCase;
  final GetVisitPlansUseCase getVisitPlansUseCase;

  VisitPlanBloc({
    required this.createVisitPlanUseCase,
    required this.getVisitPlansUseCase,
  }) : super(VisitPlanInitial()) {
    on<CreateVisitPlanEvent>(_onCreateVisitPlan);
    on<FetchVisitPlansEvent>(_onFetchVisitPlans);
  }

  Future<void> _onCreateVisitPlan(
    CreateVisitPlanEvent event,
    Emitter<VisitPlanState> emit,
  ) async {
    emit(VisitPlanLoading());
    final result = await createVisitPlanUseCase.execute(event.visitPlanData);
    result.fold(
      (failure) => emit(VisitPlanFailure(failure.message)),
      (visitPlan) => emit(VisitPlanSuccess(visitPlan)),
    );
  }

  Future<void> _onFetchVisitPlans(
    FetchVisitPlansEvent event,
    Emitter<VisitPlanState> emit,
  ) async {
    emit(VisitPlanLoading());
    final result = await getVisitPlansUseCase.execute(event.employeeId);
    result.fold(
      (failure) => emit(VisitPlanFailure(failure.message)),
      (visitPlans) => emit(VisitPlansLoaded(visitPlans)),
    );
  }
}
