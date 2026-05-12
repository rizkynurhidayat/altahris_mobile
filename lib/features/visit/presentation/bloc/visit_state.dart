import 'package:equatable/equatable.dart';
import '../../domain/entities/visit.dart';

abstract class VisitState extends Equatable {
  const VisitState();

  @override
  List<Object?> get props => [];
}

class VisitInitial extends VisitState {}

class VisitLoading extends VisitState {}

class VisitSuccess extends VisitState {
  final Visit visit;

  const VisitSuccess(this.visit);

  @override
  List<Object?> get props => [visit];
}

class VisitFailure extends VisitState {
  final String message;

  const VisitFailure(this.message);

  @override
  List<Object?> get props => [message];
}