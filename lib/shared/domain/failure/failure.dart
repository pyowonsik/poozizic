/// 실패를 나타내는 추상 클래스
abstract class Failure {
  const Failure(this.message, {this.exception, this.stackTrace});

  final String message;
  final Exception? exception;
  final StackTrace? stackTrace;

  factory Failure.unexpected({
    required String message,
    Exception? exception,
  }) {
    return UnexpectedFailure(message, exception: exception);
  }

  @override
  String toString() => message;
}

/// 예상치 못한 오류
class UnexpectedFailure extends Failure {
  const UnexpectedFailure(
    super.message, {
    super.exception,
    super.stackTrace,
  });
}
