import '../../domain/entities/Grade.dart';

class GradeModel extends Grade {
  const GradeModel({
    required super.companyId,
    required super.createdAt,
    required super.description,
    required super.id,
    required super.isActive,
    required super.jobLevelId,
    required super.jobLevelName,
    required super.maxSalary,
    required super.minSalary,
    required super.name,
    required super.updatedAt,
  });

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    return GradeModel(
      companyId: json['company_id'] ?? '',
      createdAt: json['created_at'] ?? '',
      description: json['description'] ?? '',
      id: json['id'] ?? '',
      isActive: json['is_active'] ?? false,
      jobLevelId: json['job_level_id'] ?? '',
      jobLevelName: json['job_level_name'] ?? '',
      maxSalary: json['max_salary'] ?? 0,
      minSalary: json['min_salary'] ?? 0,
      name: json['name'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company_id': companyId,
      'created_at': createdAt,
      'description': description,
      'id': id,
      'is_active': isActive,
      'job_level_id': jobLevelId,
      'job_level_name': jobLevelName,
      'max_salary': maxSalary,
      'min_salary': minSalary,
      'name': name,
      'updated_at': updatedAt,
    };
  }
}
