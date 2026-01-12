/// Supabase 관련 예외
class SupabaseException implements Exception {
  /// Supabase 관련 예외 생성자
  const SupabaseException(this.message, {this.code});

  /// 예외 메시지
  final String message;

  /// 예외 코드
  final String? code;

  @override
  String toString() => 'SupabaseException: $message (code: $code)';
}

/// 앱 인증 예외
class AppAuthException extends SupabaseException {
  /// 앱 인증 예외 생성자
  const AppAuthException(super.message, {super.code});
}

/// 네트워크 예외
class NetworkException extends SupabaseException {
  /// 네트워크 예외 생성자
  const NetworkException(super.message, {super.code});
}

/// 데이터베이스 예외
class DatabaseException extends SupabaseException {
  /// 데이터베이스 예외 생성자
  const DatabaseException(super.message, {super.code});
}
