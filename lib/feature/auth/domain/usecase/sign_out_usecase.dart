import 'package:dartz/dartz.dart';
import 'package:poozizic/feature/auth/domain/repository/auth_repository.dart';
import 'package:poozizic/shared/domain/failure/failure.dart';
import 'package:poozizic/shared/domain/usecase/usecase.dart';

/// 로그아웃 UseCase
class SignOutUseCase implements UseCase<void, NoParams, AuthRepository> {
  /// 로그아웃 UseCase 생성자
  SignOutUseCase(this._repository);

  final AuthRepository _repository;

  @override
  AuthRepository get repo => _repository;

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return _repository.signOut();
  }
}
