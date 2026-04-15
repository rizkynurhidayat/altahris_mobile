import 'package:altahris_mobile/features/payslip/domain/entities/payroll.dart';
import 'package:altahris_mobile/features/payslip/domain/repositories/payroll_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';

class GetAllPayrollUsecase {
  final PayrollRepository repository;

  GetAllPayrollUsecase(this.repository);

  Future<Either<Failure, List<Payroll>>> execute(
    GetAllPayrollParams params,
  ) async {
    return await repository.getAllPayrolls(
      id: params.id,
      token: params.token,
      month: params.month,
      year: params.year,
    );
  }
}

class GetAllPayrollParams extends Equatable {
  final String id;
  final String token;
  final int month;
  final int year;

  const GetAllPayrollParams({
    required this.id,
    required this.token,
    required this.month,
    required this.year,
  });

  @override
  List<Object?> get props => [id, month, year, token];
}
