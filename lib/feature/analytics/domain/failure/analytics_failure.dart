import '../../../../shared/domain/failure/failure.dart';

/// Analytics 관련 실패
class AnalyticsFailure extends Failure {
  const AnalyticsFailure(super.message, {super.exception, super.stackTrace});
}

/// 분석 요약 조회 실패
class GetAnalyticsSummaryFailure extends AnalyticsFailure {
  const GetAnalyticsSummaryFailure(super.message,
      {super.exception, super.stackTrace});
}

/// 배변 분포 조회 실패
class GetBowelDistributionFailure extends AnalyticsFailure {
  const GetBowelDistributionFailure(super.message,
      {super.exception, super.stackTrace});
}

/// 주간 빈도 조회 실패
class GetWeeklyFrequencyFailure extends AnalyticsFailure {
  const GetWeeklyFrequencyFailure(super.message,
      {super.exception, super.stackTrace});
}

/// 인사이트 조회 실패
class GetInsightsFailure extends AnalyticsFailure {
  const GetInsightsFailure(super.message, {super.exception, super.stackTrace});
}
