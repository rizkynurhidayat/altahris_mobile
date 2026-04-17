import 'package:altahris_mobile/features/home/domain/entities/Employee.dart';
import 'package:altahris_mobile/features/home/domain/entities/Shift.dart';
import 'package:equatable/equatable.dart';

class Attendance extends Equatable {
  final String clockIn;
  final String clockOut;
  final String createdAt;
  final String date;
  final Employee employee;
  final String employeeId;
  final String id;
  final String notes;
  final int overtimeHours;
  final Shift shift;
  final String shiftId;
  final String status;
  final String updatedAt;

  const Attendance({
    required this.clockIn,
    required this.clockOut,
    required this.createdAt,
    required this.date,
    required this.employee,
    required this.employeeId,
    required this.id,
    required this.notes,
    required this.overtimeHours,
    required this.shift,
    required this.shiftId,
    required this.status,
    required this.updatedAt,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    clockIn,
    clockOut,
    createdAt,
    date,
    employee,
    employeeId,
    id,
    notes,
    overtimeHours,
    shift,
    shiftId,
    status,
    updatedAt,
  ];
}
