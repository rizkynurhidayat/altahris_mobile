import 'package:equatable/equatable.dart';
import '../../domain/entities/visit_plan_entity.dart';

abstract class VisitPlanState extends Equatable {
  const VisitPlanState();

  @override
  List<Object?> get props => [];
}

class VisitPlanInitial extends VisitPlanState {}

class VisitPlanLoading extends VisitPlanState {}

class VisitPlanSuccess extends VisitPlanState {
  final VisitPlanEntity visitPlan;

  const VisitPlanSuccess(this.visitPlan);

  @override
  List<Object?> get props => [visitPlan];
}

class VisitPlansLoaded extends VisitPlanState {
  final List<VisitPlanEntity> visitPlans;

  const VisitPlansLoaded(this.visitPlans);

  @override
  List<Object?> get props => [visitPlans];
}

class VisitPlanFailure extends VisitPlanState {
  final String message;

  const VisitPlanFailure(this.message);

  @override
  List<Object?> get props => [message];
}
