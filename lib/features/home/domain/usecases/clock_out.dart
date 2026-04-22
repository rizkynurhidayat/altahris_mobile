import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/home_repository.dart';

class ClockOutUseCase {
  final HomeRepository repository;

  ClockOutUseCase(this.repository);

  Future<Either<Failure, void>> execute({
    required String imagePath,
    required double latitude,
    required double longitude,
    required String notes,
  }) async {
    return await repository.clockOut(
      imagePath: imagePath,
      latitude: latitude,
      longitude: longitude,
      notes: notes,
    );
  }
}
