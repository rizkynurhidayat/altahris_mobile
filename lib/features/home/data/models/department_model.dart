import '../../domain/entities/Departement.dart';
import 'company_model.dart';

class DepartmentModel extends Department {
  const DepartmentModel({
    required super.company,
    required super.companyId,
    required super.createdAt,
    required super.description,
    required super.id,
    required super.isActive,
    required super.name,
    required super.updatedAt,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      company: CompanyModel.fromJson(json['company'] ?? {}),
      companyId: json['company_id'] ?? '',
      createdAt: json['created_at'] ?? '',
      description: json['description'] ?? '',
      id: json['id'] ?? '',
      isActive: json['is_active'] ?? false,
      name: json['name'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company': (company as CompanyModel).toJson(),
      'company_id': companyId,
      'created_at': createdAt,
      'description': description,
      'id': id,
      'is_active': isActive,
      'name': name,
      'updated_at': updatedAt,
    };
  }
}
