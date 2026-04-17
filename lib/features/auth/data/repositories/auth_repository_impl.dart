import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.login(email, password);
      // Cache user on successful login
      await localDataSource.cacheUser(user);
      return Right(user);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getCachedUser() async {
    try {
      final user = await localDataSource.getCachedUser();
      return Right(user);
    } catch (e) {
      return Left(ServerFailure('Failed to retrieve cached user: $e'));
    }
  }

  @override
  Future<void> logout() async {
    try {
      final user = await localDataSource.getCachedUser();
      if (user != null && user.token != null) {
        await remoteDataSource.logout(user.token!);
      }
    } catch (_) {
      // Even if remote logout fails, we proceed to clear local cache
    } finally {
      await localDataSource.clearCache();
    }
  }
}
