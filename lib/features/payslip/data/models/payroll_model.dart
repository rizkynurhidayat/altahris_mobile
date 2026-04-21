import '../../domain/entities/payroll.dart';

class PayrollModel extends Payroll {
  const PayrollModel({
    required super.id,
    required super.employeeId,
    required super.periodMonth,
    required super.periodYear,
    required super.basicSalary,
    required super.grossSalary,
    required super.netSalary,
    required super.totalAllowances,
    required super.totalDeductions,
    required super.bpjsKesDeduction,
    required super.bpjsTkDeduction,
    required super.overtimePay,
    required super.otherDeductions,
    required super.pph21,
    required super.thr,
    required super.presentDays,
    required super.workingDays,
    required super.status,
    required super.notes,
    super.paidAt,
    required super.createdAt,
    required super.updatedAt,
  });

  factory PayrollModel.fromJson(Map<String, dynamic> json) {
    return PayrollModel(
      id: json['id']?.toString() ?? '',
      employeeId: json['employee_id']?.toString() ?? '',
      periodMonth: json['period_month'] ?? 0,
      periodYear: json['period_year'] ?? 0,
      basicSalary: (json['basic_salary'] ?? 0).toDouble(),
      grossSalary: (json['gross_salary'] ?? 0).toDouble(),
      netSalary: (json['net_salary'] ?? 0).toDouble(),
      totalAllowances: (json['total_allowances'] ?? 0).toDouble(),
      totalDeductions: (json['total_deductions'] ?? 0).toDouble(),
      bpjsKesDeduction: (json['bpjs_kes_deduction'] ?? 0).toDouble(),
      bpjsTkDeduction: (json['bpjs_tk_deduction'] ?? 0).toDouble(),
      overtimePay: (json['overtime_pay'] ?? 0).toDouble(),
      otherDeductions: (json['other_deductions'] ?? 0).toDouble(),
      pph21: (json['pph21'] ?? 0).toDouble(),
      thr: (json['thr'] ?? 0).toDouble(),
      presentDays: json['present_days'] ?? 0,
      workingDays: json['working_days'] ?? 0,
      status: json['status']?.toString() ?? '',
      notes: json['notes']?.toString() ?? '',
      paidAt: json['paid_at']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'period_month': periodMonth,
      'period_year': periodYear,
      'basic_salary': basicSalary,
      'gross_salary': grossSalary,
      'net_salary': netSalary,
      'total_allowances': totalAllowances,
      'total_deductions': totalDeductions,
      'bpjs_kes_deduction': bpjsKesDeduction,
      'bpjs_tk_deduction': bpjsTkDeduction,
      'overtime_pay': overtimePay,
      'other_deductions': otherDeductions,
      'pph21': pph21,
      'thr': thr,
      'present_days': presentDays,
      'working_days': workingDays,
      'status': status,
      'notes': notes,
      'paid_at': paidAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
