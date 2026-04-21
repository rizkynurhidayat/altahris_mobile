import 'package:altahris_mobile/features/payslip/domain/entities/payroll.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class PayrollRepository {
  Future<Either<Failure, List<Payroll>>> getPayrollsMe();
}
