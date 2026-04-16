import 'package:altahris_mobile/features/auth/domain/entities/user.dart';
import 'package:altahris_mobile/features/home/domain/entities/Company.dart';
import 'package:altahris_mobile/features/home/domain/entities/Departement.dart';
import 'package:altahris_mobile/features/home/domain/entities/Position.dart';
import 'package:altahris_mobile/features/home/domain/entities/Shift.dart';
import 'package:equatable/equatable.dart';

class Employee extends Equatable {
  final String bankAccount;
  final String bankName;
  final String birthDate;
  final String birthPlace;
  final String bloodType;
  final String bpjsKesNo;
  final String bpjsTkNo;
  final Company company;
  final String companyId;
  final String createdAt;
  final Department department;
  final String departmentId;
  final String employeeNumber;
  final String employeeStatus;
  final String gender;
  final String id;
  final String joinDate;
  final String lastEducation;
  final String maritalStatus;
  final String nik;
  final String npwp;
  final Position position;
  final String positionId;
  final String religion;
  final String resignDate;
  final Shift shift;
  final String shiftId;
  final String updatedAt;
  final User user;
  final String userId;

 const Employee({
    required this.bankAccount,
    required this.bankName,
    required this.birthDate,
    required this.birthPlace,
    required this.bloodType,
    required this.bpjsKesNo,
    required this.bpjsTkNo,
    required this.company,
    required this.companyId,
    required this.createdAt,
    required this.department,
    required this.departmentId,
    required this.employeeNumber,
    required this.employeeStatus,
    required this.gender,
    required this.id,
    required this.joinDate,
    required this.lastEducation,
    required this.maritalStatus,
    required this.nik,
    required this.npwp,
    required this.position,
    required this.positionId,
    required this.religion,
    required this.resignDate,
    required this.shift,
    required this.shiftId,
    required this.updatedAt,
    required this.user,
    required this.userId,
  });
  
  @override
  // TODO: implement props
  List<Object?> get props => [
    bankAccount,
    bankName,
    birthDate,
    birthPlace,
    bloodType,
    bpjsKesNo,
    bpjsTkNo,
    company,
    companyId,
    createdAt,
    department,
    departmentId,
    employeeNumber,
    employeeStatus,
  ];
}


/*
  Employee.fromJson(Map<String, dynamic> json) {
    bankAccount = json['bank_account'];
    bankName = json['bank_name'];
    birthDate = json['birth_date'];
    birthPlace = json['birth_place'];
    bloodType = json['blood_type'];
    bpjsKesNo = json['bpjs_kes_no'];
    bpjsTkNo = json['bpjs_tk_no'];
    company =
        json['company'] != null ? new Company.fromJson(json['company']) : null;
    companyId = json['company_id'];
    createdAt = json['created_at'];
    department = json['department'] != null
        ? new Department.fromJson(json['department'])
        : null;
    departmentId = json['department_id'];
    employeeNumber = json['employee_number'];
    employeeStatus = json['employee_status'];
    gender = json['gender'];
    id = json['id'];
    joinDate = json['join_date'];
    lastEducation = json['last_education'];
    maritalStatus = json['marital_status'];
    nik = json['nik'];
    npwp = json['npwp'];
    position = json['position'] != null
        ? new Position.fromJson(json['position'])
        : null;
    positionId = json['position_id'];
    religion = json['religion'];
    resignDate = json['resign_date'];
    shift = json['shift'] != null ? new Shift.fromJson(json['shift']) : null;
    shiftId = json['shift_id'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bank_account'] = this.bankAccount;
    data['bank_name'] = this.bankName;
    data['birth_date'] = this.birthDate;
    data['birth_place'] = this.birthPlace;
    data['blood_type'] = this.bloodType;
    data['bpjs_kes_no'] = this.bpjsKesNo;
    data['bpjs_tk_no'] = this.bpjsTkNo;
    if (this.company != null) {
      data['company'] = this.company!.toJson();
    }
    data['company_id'] = this.companyId;
    data['created_at'] = this.createdAt;
    if (this.department != null) {
      data['department'] = this.department!.toJson();
    }
    data['department_id'] = this.departmentId;
    data['employee_number'] = this.employeeNumber;
    data['employee_status'] = this.employeeStatus;
    data['gender'] = this.gender;
    data['id'] = this.id;
    data['join_date'] = this.joinDate;
    data['last_education'] = this.lastEducation;
    data['marital_status'] = this.maritalStatus;
    data['nik'] = this.nik;
    data['npwp'] = this.npwp;
    if (this.position != null) {
      data['position'] = this.position!.toJson();
    }
    data['position_id'] = this.positionId;
    data['religion'] = this.religion;
    data['resign_date'] = this.resignDate;
    if (this.shift != null) {
      data['shift'] = this.shift!.toJson();
    }
    data['shift_id'] = this.shiftId;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['user_id'] = this.userId;
    return data;
  }
*/








