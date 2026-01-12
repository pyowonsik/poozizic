import 'package:poozizic/shared/domain/failure/failure.dart';

/// Settings 조회 실패
class GetSettingsFailure extends Failure {
  /// Settings 조회 실패 생성자
  /// [message] 실패 메시지
  /// [exception] 실패 예외
  /// [stackTrace] 실패 스택 트레이스
  const GetSettingsFailure(super.message, {super.exception, super.stackTrace});
}

/// Settings 업데이트 실패
class UpdateSettingsFailure extends Failure {
  /// Settings 업데이트 실패 생성자
  /// [message] 실패 메시지
  /// [exception] 실패 예외
  /// [stackTrace] 실패 스택 트레이스
  const UpdateSettingsFailure(
    super.message, {
    super.exception,
    super.stackTrace,
  });
}
