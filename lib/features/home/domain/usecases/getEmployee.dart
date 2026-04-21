import 'package:altahris_mobile/features/home/domain/entities/Employee.dart';
import 'package:altahris_mobile/features/home/domain/repositories/home_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

class GetEmployeeMeUseCase {
  final HomeRepository repository;

  GetEmployeeMeUseCase(this.repository);

  Future<Either<Failure, Employee>> execute() async {
    return await repository.getEmployeeMe();
  }
}
