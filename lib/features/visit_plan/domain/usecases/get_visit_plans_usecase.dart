import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/visit_plan_entity.dart';
import '../../domain/repositories/visit_plan_repository.dart';

class GetVisitPlansUseCase  {
  final VisitPlanRepository repository;

  GetVisitPlansUseCase(this.repository);

  Future<Either<Failure, List<VisitPlanEntity>>> execute(String employeeId) async {
    return await repository.getVisitPlans(employeeId);
  }
}
