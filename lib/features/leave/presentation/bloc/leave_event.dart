import 'package:equatable/equatable.dart';

abstract class LeaveEvent extends Equatable {
  const LeaveEvent();

  @override
  List<Object?> get props => [];
}

class FetchLeaveHistory extends LeaveEvent {
  const FetchLeaveHistory();

  @override
  List<Object?> get props => [];
}
