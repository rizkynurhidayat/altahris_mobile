import 'package:altahris_mobile/features/home/data/datasources/home_local_datasource.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final HomeLocalDataSources homeLocalDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.homeLocalDataSource,
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
      await homeLocalDataSource.clearCache();
    }
  }

  @override
  Future<Either<Failure, void>> refreshToken() async {
    try {
      final user = await localDataSource.getCachedUser();
      if (user != null && user.refreshToken != null) {
        final result = await remoteDataSource.refreshToken(user.refreshToken!);
        final updatedUser = user.copyWith(
          token: result['access_token'],
          refreshToken: result['refresh_token'] ?? user.refreshToken,
        );
        await localDataSource.cacheUser(updatedUser);
        return const Right(null);
      }
      return Left(ServerFailure('No refresh token available'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
