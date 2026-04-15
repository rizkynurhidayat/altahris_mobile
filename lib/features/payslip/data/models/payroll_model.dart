import '../../domain/entities/payroll.dart';

class PayrollModel extends Payroll {
  PayrollModel({
    required super.createdAt,
    required super.id,
    required super.notes,
    required super.paidAt,
    required super.periodMonth,
    required super.periodYear,
    required super.status,
    required super.updatedAt,
  });

  factory PayrollModel.fromJson(Map<String, dynamic> json) {
    // Note: Adjust mapping based on actual API response structure
    return PayrollModel(
      id: json['id']?.toString() ?? '',
      notes: json['notes']?.toString() ?? '',
      paidAt: json['paid_at']?.toString() ?? '',
      periodMonth: json['period_month'] ?? 0,
      periodYear: json['period_year'] ?? 0,
      status: json['status']?.toString() ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  
}
