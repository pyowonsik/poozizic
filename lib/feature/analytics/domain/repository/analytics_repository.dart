import 'package:poozizic/feature/analytics/domain/entity/analytics_summary_entity.dart';
import 'package:poozizic/feature/analytics/domain/entity/bowel_distribution_entity.dart';
import 'package:poozizic/feature/analytics/domain/entity/insight_entity.dart';
import 'package:poozizic/feature/analytics/domain/entity/weekly_frequency_entity.dart';

/// Analytics Repository 인터페이스
abstract class AnalyticsRepository {
  /// 분석 요약 조회 (최근 N일)
  Future<AnalyticsSummaryEntity> getAnalyticsSummary(int days);

  /// 배변 상태 분포 조회 (최근 N일)
  Future<BowelDistributionEntity> getBowelDistribution(int days);

  /// 주간 배변 빈도 조회
  Future<WeeklyFrequencyEntity> getWeeklyFrequency();

  /// 인사이트 조회
  Future<List<InsightEntity>> getInsights();
}
