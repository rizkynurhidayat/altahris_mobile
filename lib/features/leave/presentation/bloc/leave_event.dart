import 'package:equatable/equatable.dart';

abstract class LeaveEvent extends Equatable {
  const LeaveEvent();

  @override
  List<Object?> get props => [];
}

class FetchLeaveHistory extends LeaveEvent {
  final String employeeId;

  const FetchLeaveHistory(this.employeeId);

  @override
  List<Object?> get props => [employeeId];
}
