import 'package:altahris_mobile/features/payslip/domain/entities/payroll.dart';
import 'package:altahris_mobile/features/payslip/domain/repositories/payroll_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';

class GetPayrollByIdUsecase {
  final PayrollRepository repository;

  GetPayrollByIdUsecase(this.repository);

  Future<Either<Failure, Payroll>> execute(GetPayrollByIdParams params) async {
    return await repository.getPayrollByID(
      idPayroll: params.id,
      token: params.token,
    );
  }
}

class GetPayrollByIdParams extends Equatable {
  final String id;
  final String token;

  const GetPayrollByIdParams({required this.id, required this.token});

  @override
  List<Object?> get props => [id, token];
}
