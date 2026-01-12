import '../../../../shared/domain/failure/failure.dart';

/// Home 관련 실패
class HomeFailure extends Failure {
  const HomeFailure(super.message, {super.exception, super.stackTrace});
}

/// 일일 요약 조회 실패
class GetDailySummaryFailure extends HomeFailure {
  const GetDailySummaryFailure(super.message,
      {super.exception, super.stackTrace});
}

/// 건강 점수 조회 실패
class GetHealthScoreFailure extends HomeFailure {
  const GetHealthScoreFailure(super.message,
      {super.exception, super.stackTrace});
}

/// 최근 기록 조회 실패
class GetRecentRecordsFailure extends HomeFailure {
  const GetRecentRecordsFailure(super.message,
      {super.exception, super.stackTrace});
}
