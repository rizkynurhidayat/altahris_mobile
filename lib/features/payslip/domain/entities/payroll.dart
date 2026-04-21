import 'package:equatable/equatable.dart';

class Payroll extends Equatable {
  final String id;
  final String employeeId;
  final int periodMonth;
  final int periodYear;
  final double basicSalary;
  final double grossSalary;
  final double netSalary;
  final double totalAllowances;
  final double totalDeductions;
  final double bpjsKesDeduction;
  final double bpjsTkDeduction;
  final double overtimePay;
  final double otherDeductions;
  final double pph21;
  final double thr;
  final int presentDays;
  final int workingDays;
  final String status;
  final String notes;
  final String? paidAt;
  final String createdAt;
  final String updatedAt;

  const Payroll({
    required this.id,
    required this.employeeId,
    required this.periodMonth,
    required this.periodYear,
    required this.basicSalary,
    required this.grossSalary,
    required this.netSalary,
    required this.totalAllowances,
    required this.totalDeductions,
    required this.bpjsKesDeduction,
    required this.bpjsTkDeduction,
    required this.overtimePay,
    required this.otherDeductions,
    required this.pph21,
    required this.thr,
    required this.presentDays,
    required this.workingDays,
    required this.status,
    required this.notes,
    this.paidAt,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        employeeId,
        periodMonth,
        periodYear,
        basicSalary,
        grossSalary,
        netSalary,
        totalAllowances,
        totalDeductions,
        bpjsKesDeduction,
        bpjsTkDeduction,
        overtimePay,
        otherDeductions,
        pph21,
        thr,
        presentDays,
        workingDays,
        status,
        notes,
        paidAt,
        createdAt,
        updatedAt,
      ];
}
