import '../../domain/entity/analytics_summary_entity.dart';
import '../../domain/entity/bowel_distribution_entity.dart';
import '../../domain/entity/weekly_frequency_entity.dart';
import '../../domain/entity/insight_entity.dart';

/// Analytics 화면 상태 (Sealed Class)
sealed class AnalyticsState {
  const AnalyticsState();
}

/// 로딩 상태
class AnalyticsLoading extends AnalyticsState {
  const AnalyticsLoading();
}

/// 로드 완료 상태
class AnalyticsLoaded extends AnalyticsState {
  final AnalyticsSummaryEntity summary;
  final BowelDistributionEntity distribution;
  final WeeklyFrequencyEntity weeklyFrequency;
  final List<InsightEntity> insights;

  const AnalyticsLoaded({
    required this.summary,
    required this.distribution,
    required this.weeklyFrequency,
    required this.insights,
  });

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
  final String message;

  const AnalyticsError({required this.message});
}
