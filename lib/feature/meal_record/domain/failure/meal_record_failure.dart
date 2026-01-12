import '../../../../shared/domain/failure/failure.dart';

/// MealRecord 관련 실패
class MealRecordFailure extends Failure {
  const MealRecordFailure(super.message, {super.exception, super.stackTrace});
}

/// 식사 기록 생성 실패
class CreateMealRecordFailure extends MealRecordFailure {
  const CreateMealRecordFailure(super.message,
      {super.exception, super.stackTrace});
}

/// 식사 기록 조회 실패
class GetMealRecordsFailure extends MealRecordFailure {
  const GetMealRecordsFailure(super.message,
      {super.exception, super.stackTrace});
}
