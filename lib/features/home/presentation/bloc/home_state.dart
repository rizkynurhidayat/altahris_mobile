import 'package:altahris_mobile/features/attendance/domain/entities/attendance.dart';
import 'package:altahris_mobile/features/home/domain/entities/Employee.dart';
import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Attendance> attendance;
  final Employee employee;

  const HomeLoaded(this.attendance, this.employee);

  @override
  List<Object?> get props => [attendance, employee];
}

class HomeFailure extends HomeState {
  final String message;

  const HomeFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ClockInLoading extends HomeState {}

class ClockInSuccess extends HomeState {}

class ClockInFailure extends HomeState {
  final String message;

  const ClockInFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class ClockOutLoading extends HomeState {}

class ClockOutSuccess extends HomeState {}

class ClockOutFailure extends HomeState {
  final String message;

  const ClockOutFailure(this.message);

  @override
  List<Object?> get props => [message];
}
