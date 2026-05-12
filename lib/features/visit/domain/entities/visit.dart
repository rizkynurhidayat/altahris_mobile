import 'package:equatable/equatable.dart';

class Visit extends Equatable {
  final String? id;
  final String location;
  final String description;
  final double lat;
  final double lng;
  final String? status;
  final String? createdAt;
  final String? updatedAt;

  const Visit({
    this.id,
    required this.location,
    required this.description,
    required this.lat,
    required this.lng,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props =>
      [id, location, description, lat, lng, status, createdAt, updatedAt];
}