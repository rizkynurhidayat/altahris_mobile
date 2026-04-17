import '../../../auth/data/models/user_model.dart';
import '../../../home/data/models/employee_model.dart';
import '../../domain/entities/leave.dart';

class LeaveModel extends Leave {
  const LeaveModel({
    required super.id,
    required super.employeeId,
    required super.employee,
    required super.leaveType,
    required super.startDate,
    required super.endDate,
    required super.totalDays,
    required super.reason,
    required super.status,
    super.attachment,
    super.rejectionReason,
    super.approvedBy,
    super.approvedAt,
    super.approver,
    required super.createdAt,
    required super.updatedAt,
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      id: json['id'] ?? '',
      employeeId: json['employee_id'] ?? '',
      employee: EmployeeModel.fromJson(json['employee'] ?? {}),
      leaveType: json['leave_type'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      totalDays: json['total_days'] is int ? json['total_days'] : 0,
      reason: json['reason'] ?? '',
      status: json['status'] ?? '',
      attachment: json['attachment'],
      rejectionReason: json['rejection_reason'],
      approvedBy: json['approved_by'],
      approvedAt: json['approved_at'],
      approver: json['approver'] != null ? UserModel.fromJson(json['approver']) : null,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'employee': (employee as EmployeeModel).toJson(),
      'leave_type': leaveType,
      'start_date': startDate,
      'end_date': endDate,
      'total_days': totalDays,
      'reason': reason,
      'status': status,
      'attachment': attachment,
      'rejection_reason': rejectionReason,
      'approved_by': approvedBy,
      'approved_at': approvedAt,
      'approver': (approver as UserModel?)?.toJson(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
