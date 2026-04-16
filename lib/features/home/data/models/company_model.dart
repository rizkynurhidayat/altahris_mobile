import '../../domain/entities/Company.dart';

class CompanyModel extends Company {
  const CompanyModel({
    required super.address,
    required super.createdAt,
    required super.email,
    required super.id,
    required super.isActive,
    required super.logo,
    required super.name,
    required super.npwp,
    required super.phone,
    required super.updatedAt,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      address: json['address'] ?? '',
      createdAt: json['created_at'] ?? '',
      email: json['email'] ?? '',
      id: json['id'] ?? '',
      isActive: json['is_active'] ?? false,
      logo: json['logo'] ?? '',
      name: json['name'] ?? '',
      npwp: json['npwp'] ?? '',
      phone: json['phone'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'created_at': createdAt,
      'email': email,
      'id': id,
      'is_active': isActive,
      'logo': logo,
      'name': name,
      'npwp': npwp,
      'phone': phone,
      'updated_at': updatedAt,
    };
  }
}
