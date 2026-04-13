import 'package:equatable/equatable.dart';

class Attendance extends Equatable {
  final String id;
  final String? date;
  final String? clockIn;
  final String? clockOut;
  final String? status;
  final String? notes;
  final int? overtimeHours;
  final String? createdAt;
  final String? updatedAt;

  const Attendance({
    required this.id,
    this.date,
    this.clockIn,
    this.clockOut,
    this.status,
    this.notes,
    this.overtimeHours,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        date,
        clockIn,
        clockOut,
        status,
        notes,
        overtimeHours,
        createdAt,
        updatedAt,
      ];
}
