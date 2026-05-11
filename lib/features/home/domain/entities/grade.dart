import 'package:equatable/equatable.dart';

class Grade extends Equatable {
  final String companyId;
  final String createdAt;
  final String description;
  final String id;
  final bool isActive;
  final String jobLevelId;
  final String jobLevelName;
  final int maxSalary;
  final int minSalary;
  final String name;
  final String updatedAt;

  const Grade({
    required this.companyId,
    required this.createdAt,
    required this.description,
    required this.id,
    required this.isActive,
    required this.jobLevelId,
    required this.jobLevelName,
    required this.maxSalary,
    required this.minSalary,
    required this.name,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        companyId,
        createdAt,
        description,
        id,
        isActive,
        jobLevelId,
        jobLevelName,
        maxSalary,
        minSalary,
        name,
        updatedAt,
      ];
}
