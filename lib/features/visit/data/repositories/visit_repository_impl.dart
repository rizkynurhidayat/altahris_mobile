import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/visit.dart';
import '../../domain/repositories/visit_repository.dart';
import '../datasources/visit_remote_datasource.dart';

class VisitRepositoryImpl implements VisitRepository {
  final VisitRemoteDataSource remoteDataSource;

  VisitRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Visit>> startVisit(Map<String, dynamic> data) async {
    try {
      final remoteData = await remoteDataSource.startVisit(data);
      return Right(remoteData);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(e.toString()));
    }
  }
}