import 'package:equatable/equatable.dart';

class Attendance extends Equatable {
  final String clockIn;
  final String clockOut;
  final String createdAt;
  final String date;
  final String id;
  final String notes;
  final int overtimeHours;
  final String status;
  final String updatedAt;

  const Attendance({
    required this.clockIn,
    required this.clockOut,
    required this.createdAt,
    required this.date,
    required this.id,
    required this.notes,
    required this.overtimeHours,
    required this.status,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    clockIn,
    clockOut,
    createdAt,
    date,
    id,
    notes,
    overtimeHours,
    status,
    updatedAt,
  ];
}
