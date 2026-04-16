import 'package:altahris_mobile/features/home/domain/entities/Company.dart';
import 'package:equatable/equatable.dart';

class Shift extends Equatable {
  final Company company;
  final String companyId;
  final String createdAt;
  final String endTime;
  final String id;
  final bool isActive;
  final String name;
  final String startTime;
  final String updatedAt;

 const Shift({
    required this.company,
    required this.companyId,
    required this.createdAt,
    required this.endTime,
    required this.id,
    required this.isActive,
    required this.name,
    required this.startTime,
    required this.updatedAt,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    company,
    companyId,
    createdAt,
    endTime,
    id,
    isActive,
    name,
    startTime,
    updatedAt,
  ];
}

/*
Shift.fromJson(Map<String, dynamic> json) {
    company =
        json['company'] != null ? new Company.fromJson(json['company']) : null;
    companyId = json['company_id'];
    createdAt = json['created_at'];
    endTime = json['end_time'];
    id = json['id'];
    isActive = json['is_active'];
    name = json['name'];
    startTime = json['start_time'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.company != null) {
      data['company'] = this.company!.toJson();
    }
    data['company_id'] = this.companyId;
    data['created_at'] = this.createdAt;
    data['end_time'] = this.endTime;
    data['id'] = this.id;
    data['is_active'] = this.isActive;
    data['name'] = this.name;
    data['start_time'] = this.startTime;
    data['updated_at'] = this.updatedAt;
    return data;
  }
*/
