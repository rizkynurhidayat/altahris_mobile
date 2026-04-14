import 'package:equatable/equatable.dart';

class ClockInOut extends Equatable {
  final String id;
  final String? date;
  final String? clockIn;
  final String? clockOut;

  const ClockInOut({
    required this.id,
    this.date,
    this.clockIn,
    this.clockOut,
  });

  @override
  List<Object?> get props => [
        id,
        date,
        clockIn,
        clockOut,
      ];
}