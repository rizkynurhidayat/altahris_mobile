import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/visit.dart';
import '../repositories/visit_repository.dart';

class StartVisitUseCase {
  final VisitRepository repository;

  StartVisitUseCase(this.repository);

  Future<Either<Failure, Visit>> execute(Map<String, dynamic> data) async {
    return await repository.startVisit(data);
  }
}