import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/home_repository.dart';

class ClockInUseCase {
  final HomeRepository repository;

  ClockInUseCase(this.repository);

  Future<Either<Failure, void>> execute({
    required String imagePath,
    required double latitude,
    required double longitude,
  }) async {
    return await repository.clockIn(
      imagePath: imagePath,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
