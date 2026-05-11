import 'package:equatable/equatable.dart';

class Company extends Equatable {
  final String address;
  final String createdAt;
  final String email;
  final String id;
  final bool isActive;
  final String logo;
  final String name;
  final String npwp;
  final String phone;
  final String updatedAt;

  const Company({
    required this.address,
    required this.createdAt,
    required this.email,
    required this.id,
    required this.isActive,
    required this.logo,
    required this.name,
    required this.npwp,
    required this.phone,
    required this.updatedAt,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    address,
    createdAt,
    email,
    id,
    isActive,
    logo,
    name,
    npwp,
    phone,
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
