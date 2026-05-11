import 'package:equatable/equatable.dart';

abstract class VisitPlanEvent extends Equatable {
  const VisitPlanEvent();

  @override
  List<Object?> get props => [];
}

class CreateVisitPlanEvent extends VisitPlanEvent {
  final Map<String, dynamic> visitPlanData;

  const CreateVisitPlanEvent(this.visitPlanData);

  @override
  List<Object?> get props => [visitPlanData];
}

class FetchVisitPlansEvent extends VisitPlanEvent {
  final String employeeId;

  const FetchVisitPlansEvent(this.employeeId);

  @override
  List<Object?> get props => [employeeId];
}
