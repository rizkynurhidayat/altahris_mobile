import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../home/domain/entities/Employee.dart';

class Leave extends Equatable {
  final String id;
  final String employeeId;
  final Employee employee;
  final String leaveType;
  final String startDate;
  final String endDate;
  final int totalDays;
  final String reason;
  final String status;
  final String? attachment;
  final String? rejectionReason;
  final String? approvedBy;
  final String? approvedAt;
  final User? approver;
  final String createdAt;
  final String updatedAt;

  const Leave({
    required this.id,
    required this.employeeId,
    required this.employee,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.reason,
    required this.status,
    this.attachment,
    this.rejectionReason,
    this.approvedBy,
    this.approvedAt,
    this.approver,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        employeeId,
        employee,
        leaveType,
        startDate,
        endDate,
        totalDays,
        reason,
        status,
        attachment,
        rejectionReason,
        approvedBy,
        approvedAt,
        approver,
        createdAt,
        updatedAt,
      ];
}
