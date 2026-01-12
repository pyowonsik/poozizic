import 'package:dartz/dartz.dart';
import 'package:poozizic/feature/auth/domain/entity/user_entity.dart';
import 'package:poozizic/feature/auth/domain/repository/auth_repository.dart';
import 'package:poozizic/shared/domain/failure/failure.dart';
import 'package:poozizic/shared/domain/usecase/usecase.dart';

/// 현재 사용자 조회 UseCase
class GetCurrentUserUseCase
    implements UseCase<UserEntity?, NoParams, AuthRepository> {
  /// 현재 사용자 조회 UseCase 생성자
  GetCurrentUserUseCase(this._repository);

  final AuthRepository _repository;

  @override
  AuthRepository get repo => _repository;

  @override
  Future<Either<Failure, UserEntity?>> call(NoParams params) {
    return _repository.getCurrentUser();
  }
}
