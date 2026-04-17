import 'package:altahris_mobile/features/home/data/models/employee_model.dart';
import 'package:altahris_mobile/features/home/data/models/shift_model.dart';
import '../../domain/entities/attendance.dart';

class AttendanceModel extends Attendance {
   AttendanceModel({
    required super.id,
    required super.date,
    required super.clockIn,
    required super.clockOut,
    required super.status,
    required super.notes,
    required super.overtimeHours,
    required super.createdAt,
    required super.updatedAt,
    required super.employee,
    required super.employeeId,
    required super.shift,
    required super.shiftId,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] ?? '',
      date: json['date'] ?? '',
      clockIn: json['clock_in'] ?? '',
      clockOut: json['clock_out'] ?? '',
      status: json['status'] ?? '',
      notes: json['notes'] ?? '',
      overtimeHours: json['overtime_hours'] is int ? json['overtime_hours'] : 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      employee: EmployeeModel.fromJson(json['employee'] ?? {}),
      employeeId: json['employee_id'] ?? '',
      shift: ShiftModel.fromJson(json['shift'] ?? {}),
      shiftId: json['shift_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'clock_in': clockIn,
      'clock_out': clockOut,
      'status': status,
      'notes': notes,
      'overtime_hours': overtimeHours,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'employee': (employee as EmployeeModel).toJson(),
      'employee_id': employeeId,
      'shift': (shift as ShiftModel).toJson(),
      'shift_id': shiftId,
    };
  }
}
