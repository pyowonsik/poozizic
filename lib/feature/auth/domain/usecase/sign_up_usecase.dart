import 'package:dartz/dartz.dart';
import 'package:poozizic/feature/auth/domain/entity/user_entity.dart';
import 'package:poozizic/feature/auth/domain/repository/auth_repository.dart';
import 'package:poozizic/shared/domain/failure/failure.dart';
import 'package:poozizic/shared/domain/usecase/usecase.dart';

/// 회원가입 파라미터
class SignUpParams {
  /// 회원가입 파라미터 생성자
  const SignUpParams({required this.email, required this.password});

  /// 이메일
  final String email;

  /// 비밀번호
  final String password;
}

/// 회원가입 UseCase
class SignUpUseCase
    implements UseCase<UserEntity, SignUpParams, AuthRepository> {
  /// 회원가입 UseCase 생성자
  SignUpUseCase(this._repository);

  final AuthRepository _repository;

  @override
  AuthRepository get repo => _repository;

  @override
  Future<Either<Failure, UserEntity>> call(SignUpParams params) {
    return _repository.signUp(params.email, params.password);
  }
}
