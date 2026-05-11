import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/visit_plan_entity.dart';
import '../repositories/visit_plan_repository.dart';

class CreateVisitPlanUseCase {
  final VisitPlanRepository repository;

  CreateVisitPlanUseCase(this.repository);

  Future<Either<Failure, VisitPlanEntity>> execute(
      Map<String, dynamic> visitPlanData) async {
    return await repository.createVisitPlan(visitPlanData);
  }
}
