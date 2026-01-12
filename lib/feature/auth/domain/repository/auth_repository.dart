import 'package:dartz/dartz.dart';
import 'package:poozizic/feature/auth/domain/entity/user_entity.dart';
import 'package:poozizic/shared/domain/failure/failure.dart';

/// 인증 Repository 인터페이스
abstract class AuthRepository {
  /// 로그인
  Future<Either<Failure, UserEntity>> signIn(String email, String password);

  /// 회원가입
  Future<Either<Failure, UserEntity>> signUp(String email, String password);

  /// 로그아웃
  Future<Either<Failure, void>> signOut();

  /// 현재 사용자 조회
  Future<Either<Failure, UserEntity?>> getCurrentUser();

  /// 인증 상태 변경 스트림
  Stream<UserEntity?> get authStateChanges;
}
