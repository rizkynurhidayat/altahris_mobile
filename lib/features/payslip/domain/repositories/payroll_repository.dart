import 'package:altahris_mobile/features/payslip/domain/entities/payroll.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class PayrollRepository {
  Future<Either<Failure, List<Payroll>>> getAllPayrolls({
    required String id,
    required String token,
    required int month,
    required int year,
  });
  Future<Either<Failure, Payroll>> getPayrollByID({
    required String idPayroll,
    required String token,
  });
}
