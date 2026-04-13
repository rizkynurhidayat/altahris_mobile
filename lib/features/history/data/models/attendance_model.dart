import '../../domain/entities/attendance.dart';

class AttendanceModel extends Attendance {
  const AttendanceModel({
    required super.id,
    super.date,
    super.clockIn,
    super.clockOut,
    super.status,
    super.notes,
    super.overtimeHours,
    super.createdAt,
    super.updatedAt,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] ?? '',
      date: json['date'],
      clockIn: json['clock_in'],
      clockOut: json['clock_out'],
      status: json['status'],
      notes: json['notes'],
      overtimeHours: json['overtime_hours'] is int ? json['overtime_hours'] : 0,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
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
    };
  }
}
