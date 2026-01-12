import 'package:dartz/dartz.dart';
import 'package:poozizic/core/error/supabase_exception.dart';
import 'package:poozizic/feature/auth/data/datasource/auth_remote_datasource.dart';
import 'package:poozizic/feature/auth/domain/entity/user_entity.dart';
import 'package:poozizic/feature/auth/domain/failure/auth_failure.dart';
import 'package:poozizic/feature/auth/domain/repository/auth_repository.dart';
import 'package:poozizic/shared/domain/failure/failure.dart';

/// 인증 Repository 구현체
class AuthRepositoryImpl implements AuthRepository {
  /// 인증 Repository 구현체 생성자
  AuthRepositoryImpl(this._dataSource);

  final AuthRemoteDataSource _dataSource;

  @override
  Future<Either<Failure, UserEntity>> signIn(
    String email,
    String password,
  ) async {
    try {
      final user = await _dataSource.signIn(email, password);
      return Right(user);
    } on AppAuthException catch (e) {
      if (e.code == 'invalid_credentials') {
        return const Left(InvalidCredentialsFailure());
      }
      return Left(AuthFailure(e.message));
    } catch (e) {
      return const Left(AuthNetworkFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUp(
    String email,
    String password,
  ) async {
    try {
      final user = await _dataSource.signUp(email, password);
      return Right(user);
    } on AppAuthException catch (e) {
      if (e.code == 'user_already_exists') {
        return const Left(EmailAlreadyInUseFailure());
      }
      if (e.code == 'weak_password') {
        return const Left(WeakPasswordFailure());
      }
      return Left(AuthFailure(e.message));
    } catch (e) {
      return const Left(AuthNetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _dataSource.signOut();
      return const Right(null);
    } on AppAuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return const Left(AuthNetworkFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = _dataSource.getCurrentUser();
      return Right(user);
    } catch (e) {
      return const Left(AuthNetworkFailure());
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges => _dataSource.authStateChanges;
}
