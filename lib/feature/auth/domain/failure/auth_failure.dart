import 'package:poozizic/shared/domain/failure/failure.dart';

/// 잘못된 자격 증명 실패
class InvalidCredentialsFailure extends Failure {
  /// 잘못된 자격 증명 실패 생성자
  const InvalidCredentialsFailure([
    super.message = '이메일 또는 비밀번호가 올바르지 않습니다.',
  ]);
}

/// 이미 사용 중인 이메일 실패
class EmailAlreadyInUseFailure extends Failure {
  /// 이미 사용 중인 이메일 실패 생성자
  const EmailAlreadyInUseFailure([
    super.message = '이미 사용 중인 이메일입니다.',
  ]);
}

/// 약한 비밀번호 실패
class WeakPasswordFailure extends Failure {
  /// 약한 비밀번호 실패 생성자
  const WeakPasswordFailure([
    super.message = '비밀번호가 너무 약합니다.',
  ]);
}

/// 네트워크 실패
class AuthNetworkFailure extends Failure {
  /// 네트워크 실패 생성자
  const AuthNetworkFailure([
    super.message = '네트워크 연결을 확인해주세요.',
  ]);
}

/// 인증 실패
class AuthFailure extends Failure {
  /// 인증 실패 생성자
  const AuthFailure(super.message);
}
