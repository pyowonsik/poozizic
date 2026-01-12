import 'package:poozizic/shared/domain/failure/failure.dart';

/// WaterRecord 관련 실패
class WaterRecordFailure extends Failure {
  /// WaterRecord 관련 실패 생성자
  /// [message] 실패 메시지
  /// [exception] 실패 예외
  /// [stackTrace] 실패 스택 트레이스
  const WaterRecordFailure(super.message, {super.exception, super.stackTrace});
}

/// 수분 기록 생성 실패
class CreateWaterRecordFailure extends WaterRecordFailure {
  /// 수분 기록 생성 실패 생성자
  /// [message] 실패 메시지
  /// [exception] 실패 예외
  /// [stackTrace] 실패 스택 트레이스
  const CreateWaterRecordFailure(
    super.message, {
    super.exception,
    super.stackTrace,
  });
}

/// 수분 기록 조회 실패
class GetWaterRecordsFailure extends WaterRecordFailure {
  /// 수분 기록 조회 실패 생성자
  /// [message] 실패 메시지
  /// [exception] 실패 예외
  /// [stackTrace] 실패 스택 트레이스
  const GetWaterRecordsFailure(
    super.message, {
    super.exception,
    super.stackTrace,
  });
}
