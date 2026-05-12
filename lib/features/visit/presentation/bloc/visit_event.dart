import 'package:equatable/equatable.dart';

abstract class VisitEvent extends Equatable {
  const VisitEvent();

  @override
  List<Object?> get props => [];
}

class StartVisitEvent extends VisitEvent {
  final String location;
  final String description;
  final double lat;
  final double lng;

  const StartVisitEvent({
    required this.location,
    required this.description,
    required this.lat,
    required this.lng,
  });

  @override
  List<Object?> get props => [location, description, lat, lng];

  Map<String, dynamic> get toMap => {
        'location': location,
        'description': description,
        'lat': lat,
        'lng': lng,
      };
}