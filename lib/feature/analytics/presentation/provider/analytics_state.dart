import 'package:poozizic/feature/analytics/domain/entity/analytics_summary_entity.dart';
import 'package:poozizic/feature/analytics/domain/entity/bowel_distribution_entity.dart';
import 'package:poozizic/feature/analytics/domain/entity/insight_entity.dart';
import 'package:poozizic/feature/analytics/domain/entity/weekly_frequency_entity.dart';

/// Analytics 화면 상태 (Sealed Class)
sealed class AnalyticsState {
  const AnalyticsState();
}

/// 로딩 상태
class AnalyticsLoading extends AnalyticsState {
  /// 로딩 상태
  const AnalyticsLoading();
}

/// 로드 완료 상태
class AnalyticsLoaded extends AnalyticsState {
  /// 로드 완료 상태
  const AnalyticsLoaded({
    required this.summary,
    required this.distribution,
    required this.weeklyFrequency,
    required this.insights,
  });

  /// 분석 요약
  final AnalyticsSummaryEntity summary;

  /// 배변 상태 분포
  final BowelDistributionEntity distribution;

  /// 주간 빈도
  final WeeklyFrequencyEntity weeklyFrequency;

  /// 인사이트
  final List<InsightEntity> insights;

  /// 분석 요약 복사
  AnalyticsLoaded copyWith({
    AnalyticsSummaryEntity? summary,
    BowelDistributionEntity? distribution,
    WeeklyFrequencyEntity? weeklyFrequency,
    List<InsightEntity>? insights,
  }) {
    return AnalyticsLoaded(
      summary: summary ?? this.summary,
      distribution: distribution ?? this.distribution,
      weeklyFrequency: weeklyFrequency ?? this.weeklyFrequency,
      insights: insights ?? this.insights,
    );
  }
}

/// 에러 상태
class AnalyticsError extends AnalyticsState {
  /// 에러 상태 생성자
  const AnalyticsError({required this.message});

  /// 에러 상태
  final String message;
}
