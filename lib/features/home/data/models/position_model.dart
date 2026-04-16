import '../../domain/entities/Position.dart';
import 'company_model.dart';
import 'department_model.dart';

class PositionModel extends Position {
  const PositionModel({
    required super.baseSalary,
    required super.company,
    required super.companyId,
    required super.createdAt,
    required super.department,
    required super.departmentId,
    required super.id,
    required super.isActive,
    required super.name,
    required super.updatedAt,
  });

  factory PositionModel.fromJson(Map<String, dynamic> json) {
    return PositionModel(
      baseSalary: json['base_salary'] ?? 0,
      company: CompanyModel.fromJson(json['company'] ?? {}),
      companyId: json['company_id'] ?? '',
      createdAt: json['created_at'] ?? '',
      department: DepartmentModel.fromJson(json['department'] ?? {}),
      departmentId: json['department_id'] ?? '',
      id: json['id'] ?? '',
      isActive: json['is_active'] ?? false,
      name: json['name'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'base_salary': baseSalary,
      'company': (company as CompanyModel).toJson(),
      'company_id': companyId,
      'created_at': createdAt,
      'department': (department as DepartmentModel).toJson(),
      'department_id': departmentId,
      'id': id,
      'is_active': isActive,
      'name': name,
      'updated_at': updatedAt,
    };
  }
}
