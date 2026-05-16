import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class FetchAttendance extends HomeEvent {}

class FetchHomeData extends HomeEvent {
  final bool isRefresh;

  const FetchHomeData({this.isRefresh = false});

  @override
  List<Object?> get props => [isRefresh];
}

class PerformClockIn extends HomeEvent {
  final String imagePath;
  final double latitude;
  final double longitude;
  final String notes;

  const PerformClockIn({
    required this.imagePath,
    required this.latitude,
    required this.longitude,
    this.notes = '',
  });

  @override
  List<Object?> get props => [imagePath, latitude, longitude, notes];
}

class PerformClockOut extends HomeEvent {
  final String imagePath;
  final double latitude;
  final double longitude;
  final String notes;

  const PerformClockOut({
    required this.imagePath,
    required this.latitude,
    required this.longitude,
    this.notes = '',
  });

  @override
  List<Object?> get props => [imagePath, latitude, longitude, notes];
}
