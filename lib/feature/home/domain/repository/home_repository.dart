import '../entity/daily_summary_entity.dart';
import '../entity/health_score_entity.dart';
import '../entity/recent_record_entity.dart';

/// Home Repository 인터페이스
abstract class HomeRepository {
  /// 일일 요약 조회
  Future<DailySummaryEntity> getDailySummary(DateTime date);

  /// 건강 점수 조회
  Future<HealthScoreEntity> getHealthScore(DateTime date);

  /// 최근 기록 조회
  Future<List<RecentRecordEntity>> getRecentRecords(DateTime date);
}
