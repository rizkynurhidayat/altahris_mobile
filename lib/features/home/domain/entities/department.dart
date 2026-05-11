import 'package:altahris_mobile/features/home/domain/entities/company.dart';
import 'package:equatable/equatable.dart';

class Department extends Equatable {
  final Company company;
  final String companyId;
  final String createdAt;
  final String description;
  final String id;
  final bool isActive;
  final String name;
  final String updatedAt;

  const Department({
    required this.company,
    required this.companyId,
    required this.createdAt,
    required this.description,
    required this.id,
    required this.isActive,
    required this.name,
    required this.updatedAt,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    company,
    companyId,
    createdAt,
    description,
    id,
    isActive,
    name,
    updatedAt,
  ];
}


/*
 Department.fromJson(Map<String, dynamic> json) {
    company = json['company'] != null
        ? new Company.fromJson(json['company'])
        : null;
    companyId = json['company_id'];
    createdAt = json['created_at'];
    description = json['description'];
    id = json['id'];
    isActive = json['is_active'];
    name = json['name'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.company != null) {
      data['company'] = this.company!.toJson();
    }
    data['company_id'] = this.companyId;
    data['created_at'] = this.createdAt;
    data['description'] = this.description;
    data['id'] = this.id;
    data['is_active'] = this.isActive;
    data['name'] = this.name;
    data['updated_at'] = this.updatedAt;
    return data;
  }
*/