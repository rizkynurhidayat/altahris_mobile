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
  final double? clockInLat;
  final double? clockInLng;
  final double? clockInDistanceM;
  final String? clockInDistanceStatus;
  final String? clockInPhoto;
  final double? clockOutLat;
  final double? clockOutLng;
  final double? clockOutDistanceM;
  final String? clockOutDistanceStatus;
  final String? clockOutPhoto;

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
    this.clockInLat,
    this.clockInLng,
    this.clockInDistanceM,
    this.clockInDistanceStatus,
    this.clockInPhoto,
    this.clockOutLat,
    this.clockOutLng,
    this.clockOutDistanceM,
    this.clockOutDistanceStatus,
    this.clockOutPhoto,
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
    clockInLat,
    clockInLng,
    clockInDistanceM,
    clockInDistanceStatus,
    clockInPhoto,
    clockOutLat,
    clockOutLng,
    clockOutDistanceM,
    clockOutDistanceStatus,
    clockOutPhoto,
  ];
}
