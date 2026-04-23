import '../../domain/entities/attendance.dart';

class AttendanceModel extends Attendance {
  const AttendanceModel({
    required super.id,
    required super.date,
    required super.clockIn,
    required super.clockOut,
    required super.status,
    required super.notes,
    required super.overtimeHours,
    required super.createdAt,
    required super.updatedAt,
    super.clockInLat,
    super.clockInLng,
    super.clockInDistanceM,
    super.clockInDistanceStatus,
    super.clockInPhoto,
    super.clockOutLat,
    super.clockOutLng,
    super.clockOutDistanceM,
    super.clockOutDistanceStatus,
    super.clockOutPhoto,
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
      clockInLat: json['clock_in_lat']?.toDouble(),
      clockInLng: json['clock_in_lng']?.toDouble(),
      clockInDistanceM: json['clock_in_distance_m']?.toDouble(),
      clockInDistanceStatus: json['clock_in_area_status']?? '',
      clockInPhoto: json['clock_in_photo'],
      clockOutLat: json['clock_out_lat']?.toDouble(),
      clockOutLng: json['clock_out_lng']?.toDouble(),
      clockOutDistanceM: json['clock_out_distance_m']?.toDouble(),
      clockOutDistanceStatus: json['clock_out_area_status']?? '',
      clockOutPhoto: json['clock_out_photo'],
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
      'clock_in_lat': clockInLat,
      'clock_in_lng': clockInLng,
      'clock_in_distance_m': clockInDistanceM,
      'clock_in_photo': clockInPhoto,
      'clock_out_lat': clockOutLat,
      'clock_out_lng': clockOutLng,
      'clock_out_distance_m': clockOutDistanceM,
      'clock_out_photo': clockOutPhoto,
    };
  }
}
