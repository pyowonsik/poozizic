import 'package:poozizic/feature/auth/domain/entity/user_entity.dart';

/// 인증 상태
enum AuthStatus {
  /// 초기 상태
  initial,

  /// 로딩 중
  loading,

  /// 인증됨
  authenticated,

  /// 인증되지 않음
  unauthenticated,

  /// 오류
  error,
}

/// 인증 상태 클래스
class AuthState {
  /// 인증 상태 클래스 생성자
  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  /// 초기 상태 생성
  factory AuthState.initial() {
    return const AuthState();
  }

  /// 인증 상태
  final AuthStatus status;

  /// 현재 사용자
  final UserEntity? user;

  /// 오류 메시지
  final String? errorMessage;

  /// 상태 복사
  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
