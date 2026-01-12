/// 실패를 나타내는 추상 클래스
abstract class Failure {
  /// 실패를 나타내는 추상 클래스 생성자
  const Failure(this.message, {this.exception, this.stackTrace});

  /// 예상치 못한 오류 생성
  factory Failure.unexpected({
    required String message,

    /// 실패 예외
    Exception? exception,
  }) {
    return UnexpectedFailure(message, exception: exception);
  }

  /// 실패 메시지
  final String message;

  /// 실패 예외
  final Exception? exception;

  /// 실패 스택 트레이스
  final StackTrace? stackTrace;

  @override
  String toString() => message;
}

/// 예상치 못한 오류
class UnexpectedFailure extends Failure {
  /// 예상치 못한 오류 생성자
  const UnexpectedFailure(super.message, {super.exception, super.stackTrace});
}
