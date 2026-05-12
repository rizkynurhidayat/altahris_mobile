import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/visit.dart';

abstract class VisitRepository {
  Future<Either<Failure, Visit>> startVisit(Map<String, dynamic> data);
}