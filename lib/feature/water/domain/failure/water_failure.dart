import '../../../../shared/domain/failure/failure.dart';

/// 수분 기록 생성 실패
class CreateWaterRecordFailure extends Failure {
  const CreateWaterRecordFailure(
    super.message, {
    super.exception,
    super.stackTrace,
  });
}

/// 수분 기록 조회 실패
class GetWaterRecordsFailure extends Failure {
  const GetWaterRecordsFailure(
    super.message, {
    super.exception,
    super.stackTrace,
  });
}
