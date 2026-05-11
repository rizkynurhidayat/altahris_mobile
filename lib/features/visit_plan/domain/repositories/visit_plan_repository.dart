import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/visit_plan_entity.dart';

abstract class VisitPlanRepository {
  Future<Either<Failure, VisitPlanEntity>> createVisitPlan(
      Map<String, dynamic> visitPlanData);

  Future<Either<Failure, List<VisitPlanEntity>>> getVisitPlans(String employeeId);
}
