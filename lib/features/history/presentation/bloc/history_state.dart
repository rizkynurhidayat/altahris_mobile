import 'package:equatable/equatable.dart';
import '../../domain/entities/attendance.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<Attendance> attendanceHistory;

  const HistoryLoaded(this.attendanceHistory);

  @override
  List<Object?> get props => [attendanceHistory];
}

class HistoryFailure extends HistoryState {
  final String message;

  const HistoryFailure(this.message);

  @override
  List<Object?> get props => [message];
}
