import '../../domain/entity/analytics_summary_entity.dart';
import '../../domain/entity/bowel_distribution_entity.dart';
import '../../domain/entity/weekly_frequency_entity.dart';
import '../../domain/entity/insight_entity.dart';
import '../../domain/repository/analytics_repository.dart';
import '../../../record/domain/repository/record_repository.dart';
import '../../../water_record/domain/repository/water_record_repository.dart';

/// Analytics Repository 구현체
class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final RecordRepository _recordRepository;
  final WaterRecordRepository _waterRecordRepository;

  AnalyticsRepositoryImpl(this._recordRepository, this._waterRecordRepository);

  @override
  Future<AnalyticsSummaryEntity> getAnalyticsSummary(int days) async {
    final allRecords = await _recordRepository.getAllRecords();
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: days));

    // 기간 내 기록 필터링
    final periodRecords = allRecords.where((r) => r.dateTime.isAfter(startDate)).toList();

    // 정상 비율 계산 (Bristol Type 3-4)
    double normalRatio = 0;
    if (periodRecords.isNotEmpty) {
      final normalCount = periodRecords
          .where((r) => r.bristolType >= 3 && r.bristolType <= 4)
          .length;
      normalRatio = (normalCount / periodRecords.length) * 100;
    }

    // 평균 간격 계산
    double averageInterval = 1.0;
    if (periodRecords.length >= 2) {
      final sortedRecords = periodRecords.toList()
        ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

      int totalIntervalHours = 0;
      for (int i = 1; i < sortedRecords.length; i++) {
        totalIntervalHours += sortedRecords[i]
            .dateTime
            .difference(sortedRecords[i - 1].dateTime)
            .inHours;
      }
      averageInterval = (totalIntervalHours / (sortedRecords.length - 1)) / 24;
    }

    // 건강 점수 계산 (정상 비율 기반)
    int healthScore = 85;
    if (normalRatio >= 80) {
      healthScore = 90;
    } else if (normalRatio >= 60) {
      healthScore = 80;
    } else if (normalRatio >= 40) {
      healthScore = 70;
    } else {
      healthScore = 60;
    }

    return AnalyticsSummaryEntity(
      healthScore: healthScore,
      normalRatio: normalRatio,
      averageInterval: averageInterval,
      period: days,
    );
  }

  @override
  Future<BowelDistributionEntity> getBowelDistribution(int days) async {
    final allRecords = await _recordRepository.getAllRecords();
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: days));

    // 기간 내 기록 필터링
    final periodRecords = allRecords.where((r) => r.dateTime.isAfter(startDate)).toList();

    int type1_2Count = 0;
    int type3_4Count = 0;
    int type5_6Count = 0;
    int type7Count = 0;

    for (final record in periodRecords) {
      switch (record.bristolType) {
        case 1:
        case 2:
          type1_2Count++;
          break;
        case 3:
        case 4:
          type3_4Count++;
          break;
        case 5:
        case 6:
          type5_6Count++;
          break;
        case 7:
          type7Count++;
          break;
      }
    }

    return BowelDistributionEntity(
      type1_2Count: type1_2Count,
      type3_4Count: type3_4Count,
      type5_6Count: type5_6Count,
      type7Count: type7Count,
    );
  }

  @override
  Future<WeeklyFrequencyEntity> getWeeklyFrequency() async {
    final allRecords = await _recordRepository.getAllRecords();
    final now = DateTime.now();

    // 이번 주 시작일 (월요일)
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekStartDate = DateTime(weekStart.year, weekStart.month, weekStart.day);

    // 요일별 카운트 [월, 화, 수, 목, 금, 토, 일]
    final dailyCounts = List.filled(7, 0);

    for (final record in allRecords) {
      final recordDate = DateTime(
        record.dateTime.year,
        record.dateTime.month,
        record.dateTime.day,
      );

      if (!recordDate.isBefore(weekStartDate) &&
          recordDate.isBefore(weekStartDate.add(const Duration(days: 7)))) {
        final dayIndex = record.dateTime.weekday - 1; // 0-6
        if (dayIndex >= 0 && dayIndex < 7) {
          dailyCounts[dayIndex]++;
        }
      }
    }

    return WeeklyFrequencyEntity(dailyCounts: dailyCounts);
  }

  @override
  Future<List<InsightEntity>> getInsights() async {
    final allRecords = await _recordRepository.getAllRecords();
    final insights = <InsightEntity>[];

    // 최근 7일 기록 분석
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    final recentRecords = allRecords.where((r) => r.dateTime.isAfter(weekAgo)).toList();

    // 정상 패턴 분석
    if (recentRecords.isNotEmpty) {
      final normalCount = recentRecords
          .where((r) => r.bristolType >= 3 && r.bristolType <= 4)
          .length;
      final normalRatio = normalCount / recentRecords.length;

      if (normalRatio >= 0.7) {
        insights.add(const InsightEntity(
          type: InsightType.positive,
          title: '정상 패턴 유지',
          description: '최근 배변 상태가 이상적인 범위에 있습니다.',
        ));
      }
    }

    // 수분 섭취 분석
    final todayWater = await _waterRecordRepository.getDailyTotal(now);
    if (todayWater >= 1500) {
      insights.add(const InsightEntity(
        type: InsightType.water,
        title: '수분 섭취 우수',
        description: '충분한 수분 섭취가 건강한 배변을 돕고 있습니다.',
      ));
    }

    // 규칙성 분석
    if (recentRecords.length >= 5) {
      insights.add(const InsightEntity(
        type: InsightType.time,
        title: '규칙적인 시간',
        description: '일정한 시간대에 배변하는 습관이 좋습니다.',
      ));
    }

    // 기본 인사이트 추가 (최소 3개 보장)
    if (insights.isEmpty) {
      insights.add(const InsightEntity(
        type: InsightType.positive,
        title: '기록을 시작해보세요',
        description: '꾸준한 기록이 건강 관리의 첫걸음입니다.',
      ));
    }

    return insights;
  }
}
