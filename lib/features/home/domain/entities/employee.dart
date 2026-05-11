import 'package:altahris_mobile/features/auth/domain/entities/user.dart';
import 'package:altahris_mobile/features/home/domain/entities/company.dart';
import 'package:altahris_mobile/features/home/domain/entities/department.dart';
import 'package:altahris_mobile/features/home/domain/entities/position.dart';
import 'package:altahris_mobile/features/home/domain/entities/shift.dart';
import 'package:altahris_mobile/features/home/domain/entities/grade.dart';
import 'package:altahris_mobile/features/home/domain/entities/job_level.dart';
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
  final String contractEndDate;
  final String contractStartDate;
  final String createdAt;
  final Department department;
  final String departmentId;
  final String employeeNumber;
  final String employeeStatus;
  final String gender;
  final Grade grade;
  final String gradeId;
  final String id;
  final JobLevel jobLevel;
  final String jobLevelId;
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
    required this.contractEndDate,
    required this.contractStartDate,
    required this.createdAt,
    required this.department,
    required this.departmentId,
    required this.employeeNumber,
    required this.employeeStatus,
    required this.gender,
    required this.grade,
    required this.gradeId,
    required this.id,
    required this.jobLevel,
    required this.jobLevelId,
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
        contractEndDate,
        contractStartDate,
        createdAt,
        department,
        departmentId,
        employeeNumber,
        employeeStatus,
        gender,
        grade,
        gradeId,
        id,
        jobLevel,
        jobLevelId,
        joinDate,
        lastEducation,
        maritalStatus,
        nik,
        npwp,
        position,
        positionId,
        religion,
        resignDate,
        shift,
        shiftId,
        updatedAt,
        user,
        userId,
      ];
}
