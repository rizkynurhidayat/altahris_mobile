import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? address;
  final String? role;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;
  final String? token;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.address,
    this.createdAt,
    this.isActive,
    this.phone,
    this.role,
    this.updatedAt,
    this.token,
  });

  @override
  List<Object?> get props => [id, email, name, token, phone, address, role, isActive, createdAt, updatedAt];
}
