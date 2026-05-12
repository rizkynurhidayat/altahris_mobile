import '../../domain/entities/visit.dart';

class VisitModel extends Visit {
  const VisitModel({
    super.id,
    required super.location,
    required super.description,
    required super.lat,
    required super.lng,
    super.status,
    super.createdAt,
    super.updatedAt,
  });

  factory VisitModel.fromJson(Map<String, dynamic> json) {
    return VisitModel(
      id: json['id'],
      location: json['location'] ?? '',
      description: json['description'] ?? '',
      lat: (json['lat'] is num) ? json['lat'].toDouble() : 0.0,
      lng: (json['lng'] is num) ? json['lng'].toDouble() : 0.0,
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'location': location,
      'description': description,
      'lat': lat,
      'lng': lng,
      if (status != null) 'status': status,
    };
  }
}