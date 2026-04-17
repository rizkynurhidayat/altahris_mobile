import 'package:equatable/equatable.dart';
import '../../domain/entities/attendance.dart';

abstract class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object?> get props => [];
}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceLoaded extends AttendanceState {
  final List<Attendance> attendanceHistory;

  const AttendanceLoaded(this.attendanceHistory);

  @override
  List<Object?> get props => [attendanceHistory];
}

class AttendanceFailure extends AttendanceState {
  final String message;

  const AttendanceFailure(this.message);

  @override
  List<Object?> get props => [message];
}
