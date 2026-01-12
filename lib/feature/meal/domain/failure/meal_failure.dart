import '../../../../shared/domain/failure/failure.dart';

/// 식사 기록 생성 실패
class CreateMealRecordFailure extends Failure {
  const CreateMealRecordFailure(
    super.message, {
    super.exception,
    super.stackTrace,
  });
}

/// 식사 기록 조회 실패
class GetMealRecordsFailure extends Failure {
  const GetMealRecordsFailure(
    super.message, {
    super.exception,
    super.stackTrace,
  });
}
