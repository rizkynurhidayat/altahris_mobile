import '../../domain/entities/Shift.dart';
import 'company_model.dart';

class ShiftModel extends Shift {
  const ShiftModel({
    required super.company,
    required super.companyId,
    required super.createdAt,
    required super.endTime,
    required super.id,
    required super.isActive,
    required super.name,
    required super.startTime,
    required super.updatedAt,
  });

  factory ShiftModel.fromJson(Map<String, dynamic> json) {
    return ShiftModel(
      company: CompanyModel.fromJson(json['company'] ?? {}),
      companyId: json['company_id'] ?? '',
      createdAt: json['created_at'] ?? '',
      endTime: json['end_time'] ?? '',
      id: json['id'] ?? '',
      isActive: json['is_active'] ?? false,
      name: json['name'] ?? '',
      startTime: json['start_time'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company': (company as CompanyModel).toJson(),
      'company_id': companyId,
      'created_at': createdAt,
      'end_time': endTime,
      'id': id,
      'is_active': isActive,
      'name': name,
      'start_time': startTime,
      'updated_at': updatedAt,
    };
  }
}
