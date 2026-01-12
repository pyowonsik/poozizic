import '../../../../shared/domain/failure/failure.dart';

/// WaterRecord 관련 실패
class WaterRecordFailure extends Failure {
  const WaterRecordFailure(super.message, {super.exception, super.stackTrace});
}

/// 수분 기록 생성 실패
class CreateWaterRecordFailure extends WaterRecordFailure {
  const CreateWaterRecordFailure(super.message,
      {super.exception, super.stackTrace});
}

/// 수분 기록 조회 실패
class GetWaterRecordsFailure extends WaterRecordFailure {
  const GetWaterRecordsFailure(super.message,
      {super.exception, super.stackTrace});
}
