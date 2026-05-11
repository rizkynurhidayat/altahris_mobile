import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/visit_plan_entity.dart';
import '../../domain/repositories/visit_plan_repository.dart';
import '../datasources/visit_plan_remote_datasource.dart';

class VisitPlanRepositoryImpl implements VisitPlanRepository {
  final VisitPlanRemoteDataSource remoteDataSource;

  VisitPlanRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, VisitPlanEntity>> createVisitPlan(
      Map<String, dynamic> visitPlanData) async {
    try {
      final remoteData = await remoteDataSource.createVisitPlan(visitPlanData);
      return Right(remoteData);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<VisitPlanEntity>>> getVisitPlans(
      String employeeId) async {
    try {
      final remoteData = await remoteDataSource.getVisitPlans(employeeId);
      return Right(remoteData);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(e.toString()));
    }
  }
}
