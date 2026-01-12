import 'package:poozizic/shared/domain/failure/failure.dart';

/// MealRecord 관련 실패
class MealRecordFailure extends Failure {
  /// MealRecord 관련 실패 생성자
  /// [message] 실패 메시지
  /// [exception] 실패 예외
  /// [stackTrace] 실패 스택 트레이스
  const MealRecordFailure(super.message, {super.exception, super.stackTrace});
}

/// 식사 기록 생성 실패
class CreateMealRecordFailure extends MealRecordFailure {
  /// 식사 기록 생성 실패 생성자
  /// [message] 실패 메시지
  /// [exception] 실패 예외
  /// [stackTrace] 실패 스택 트레이스
  const CreateMealRecordFailure(
    super.message, {
    super.exception,
    super.stackTrace,
  });
}

/// 식사 기록 조회 실패
class GetMealRecordsFailure extends MealRecordFailure {
  /// 식사 기록 조회 실패 생성자

  /// 식사 기록 조회 실패 생성자
  /// [message] 실패 메시지
  /// [exception] 실패 예외
  /// [stackTrace] 실패 스택 트레이스
  const GetMealRecordsFailure(
    super.message, {
    super.exception,
    super.stackTrace,
  });
}
