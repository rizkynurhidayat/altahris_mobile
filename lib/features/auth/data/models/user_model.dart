import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    super.token,
    super.refreshToken,
    super.phone,
    super.address,
    super.role,
    super.isActive,
    super.createdAt,
    super.updatedAt,
  });

  @override
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? address,
    String? role,
    bool? isActive,
    String? createdAt,
    String? updatedAt,
    String? token,
    String? refreshToken,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Helper function to handle potential integer/string values for boolean
    bool? parseBool(dynamic value) {
      if (value == null) return null;
      if (value is bool) return value;
      if (value is int) return value == 1;
      if (value is String) {
        final lowered = value.toLowerCase();
        return lowered == 'true' || lowered == '1';
      }
      return null;
    }

    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      token: json['token'] ?? json['access_token'],
      refreshToken: json['refresh_token'],
      address: json['address'],
      createdAt: json['created_at'],
      isActive: parseBool(json['is_active']),
      phone: json['phone'],
      role: json['role'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'token': token,
      'refresh_token': refreshToken,
      'phone': phone,
      'address': address,
      'role': role,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  
}
