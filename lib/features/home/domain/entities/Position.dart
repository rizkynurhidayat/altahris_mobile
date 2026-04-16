import 'package:altahris_mobile/features/home/domain/entities/Company.dart';
import 'package:altahris_mobile/features/home/domain/entities/Departement.dart';
import 'package:equatable/equatable.dart';

class Position extends Equatable {
  final int baseSalary;
  final Company company;
  final String companyId;
  final String createdAt;
  final Department department;
  final String departmentId;
  final String id;
  final bool isActive;
  final String name;
  final String updatedAt;

  const Position({
    required this.baseSalary,
    required this.company,
    required this.companyId,
    required this.createdAt,
    required this.department,
    required this.departmentId,
    required this.id,
    required this.isActive,
    required this.name,
    required this.updatedAt,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    baseSalary,
    company,
    companyId,
    createdAt,
    department,
    departmentId,
    id,
    isActive,
    name,
    updatedAt,
  ];
}

/*
Position.fromJson(Map<String, dynamic> json) {
    baseSalary = json['base_salary'];
    company =
        json['company'] != null ? new Company.fromJson(json['company']) : null;
    companyId = json['company_id'];
    createdAt = json['created_at'];
    department = json['department'] != null
        ? new Department.fromJson(json['department'])
        : null;
    departmentId = json['department_id'];
    id = json['id'];
    isActive = json['is_active'];
    name = json['name'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['base_salary'] = this.baseSalary;
    if (this.company != null) {
      data['company'] = this.company!.toJson();
    }
    data['company_id'] = this.companyId;
    data['created_at'] = this.createdAt;
    if (this.department != null) {
      data['department'] = this.department!.toJson();
    }
    data['department_id'] = this.departmentId;
    data['id'] = this.id;
    data['is_active'] = this.isActive;
    data['name'] = this.name;
    data['updated_at'] = this.updatedAt;
    return data;
  }
*/
