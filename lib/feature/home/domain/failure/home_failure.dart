import 'package:poozizic/shared/domain/failure/failure.dart';

/// Home 관련 실패
class HomeFailure extends Failure {
  /// Home 관련 실패 생성자
  /// [message] 실패 메시지
  /// [exception] 실패 예외
  /// [stackTrace] 실패 스택 트레이스
  const HomeFailure(super.message, {super.exception, super.stackTrace});
}

/// 일일 요약 조회 실패
class GetDailySummaryFailure extends HomeFailure {
  /// 일일 요약 조회 실패 생성자
  /// [message] 실패 메시지
  /// [exception] 실패 예외
  /// [stackTrace] 실패 스택 트레이스
  const GetDailySummaryFailure(
    super.message, {
    super.exception,
    super.stackTrace,
  });
}

/// 건강 점수 조회 실패
class GetHealthScoreFailure extends HomeFailure {
  /// 건강 점수 조회 실패 생성자
  /// [message] 실패 메시지
  /// [exception] 실패 예외
  /// [stackTrace] 실패 스택 트레이스

  const GetHealthScoreFailure(
    super.message, {
    super.exception,
    super.stackTrace,
  });
}

/// 최근 기록 조회 실패
class GetRecentRecordsFailure extends HomeFailure {
  /// 최근 기록 조회 실패 생성자
  /// [message] 실패 메시지
  /// [exception] 실패 예외
  /// [stackTrace] 실패 스택 트레이스
  const GetRecentRecordsFailure(
    super.message, {
    super.exception,
    super.stackTrace,
  });
}
