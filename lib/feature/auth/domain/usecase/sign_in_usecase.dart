import 'package:dartz/dartz.dart';
import 'package:poozizic/feature/auth/domain/entity/user_entity.dart';
import 'package:poozizic/feature/auth/domain/repository/auth_repository.dart';
import 'package:poozizic/shared/domain/failure/failure.dart';
import 'package:poozizic/shared/domain/usecase/usecase.dart';

/// 로그인 파라미터
class SignInParams {
  /// 로그인 파라미터 생성자
  const SignInParams({required this.email, required this.password});

  /// 이메일
  final String email;

  /// 비밀번호
  final String password;
}

/// 로그인 UseCase
class SignInUseCase
    implements UseCase<UserEntity, SignInParams, AuthRepository> {
  /// 로그인 UseCase 생성자
  SignInUseCase(this._repository);

  final AuthRepository _repository;

  @override
  AuthRepository get repo => _repository;

  @override
  Future<Either<Failure, UserEntity>> call(SignInParams params) {
    return _repository.signIn(params.email, params.password);
  }
}
