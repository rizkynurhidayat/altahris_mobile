import '../../domain/entities/job_level.dart';

class JobLevelModel extends JobLevel {
  const JobLevelModel({
    required super.companyId,
    required super.createdAt,
    required super.description,
    required super.id,
    required super.isActive,
    required super.levelOrder,
    required super.name,
    required super.updatedAt,
  });

  factory JobLevelModel.fromJson(Map<String, dynamic> json) {
    return JobLevelModel(
      companyId: json['company_id'] ?? '',
      createdAt: json['created_at'] ?? '',
      description: json['description'] ?? '',
      id: json['id'] ?? '',
      isActive: json['is_active'] ?? false,
      levelOrder: json['level_order'] ?? 0,
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
      'level_order': levelOrder,
      'name': name,
      'updated_at': updatedAt,
    };
  }
}
