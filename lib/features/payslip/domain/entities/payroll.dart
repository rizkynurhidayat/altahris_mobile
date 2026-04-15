import 'package:equatable/equatable.dart';

class Payroll extends Equatable {
  final String createdAt;
  final String id;
  final String notes;
  final String paidAt;
  final int periodMonth;
  final int periodYear;
  final String status;
  final String updatedAt;

  Payroll({
    required this.createdAt,
    required this.id,
    required this.notes,
    required this.paidAt,
    required this.periodMonth,
    required this.periodYear,
    required this.status,
    required this.updatedAt,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    createdAt,
    id,
    notes,
    paidAt,
    periodMonth,
    periodYear,
    status,
    updatedAt,
  ];
}
