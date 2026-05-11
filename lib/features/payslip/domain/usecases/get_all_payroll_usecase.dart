import 'package:altahris_mobile/features/payslip/domain/entities/payroll.dart';
import 'package:altahris_mobile/features/payslip/domain/repositories/payroll_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

class GetPayrollsMeUsecase {
  final PayrollRepository repository;

  GetPayrollsMeUsecase(this.repository);

  Future<Either<Failure, List<Payroll>>> execute() async {
    return await repository.getPayrollsMe();
  }
}
