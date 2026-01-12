import 'dart:ui';
import '../../domain/entity/daily_summary_entity.dart';
import '../../domain/entity/health_score_entity.dart';
import '../../domain/entity/recent_record_entity.dart';
import '../../domain/repository/home_repository.dart';
import '../../../record/domain/repository/record_repository.dart';
import '../../../water_record/domain/repository/water_record_repository.dart';
import '../../../meal_record/domain/repository/meal_record_repository.dart';
import '../../../exercise_record/domain/repository/exercise_record_repository.dart';

/// Home Repository 구현체
class HomeRepositoryImpl implements HomeRepository {
  final RecordRepository _recordRepository;
  final WaterRecordRepository _waterRecordRepository;
  final MealRecordRepository _mealRecordRepository;
  final ExerciseRecordRepository _exerciseRecordRepository;

  HomeRepositoryImpl(
    this._recordRepository,
    this._waterRecordRepository,
    this._mealRecordRepository,
    this._exerciseRecordRepository,
  );

  @override
  Future<DailySummaryEntity> getDailySummary(DateTime date) async {
    // 배변 기록 조회
    final allRecords = await _recordRepository.getAllRecords();

    // 수분 기록 조회
    final waterTotal = await _waterRecordRepository.getDailyTotal(date);

    // 마지막 배변 시간
    DateTime? lastBowelTime;
    if (allRecords.isNotEmpty) {
      lastBowelTime = allRecords.first.dateTime;
    }

    // 연속 기록 계산 (최근 연속으로 배변한 날 수)
    int consecutiveDays = 0;
    final today = DateTime(date.year, date.month, date.day);
    for (int i = 0; i < 30; i++) {
      final checkDate = today.subtract(Duration(days: i));
      final dayRecords = allRecords.where((r) =>
          r.dateTime.year == checkDate.year &&
          r.dateTime.month == checkDate.month &&
          r.dateTime.day == checkDate.day);
      if (dayRecords.isNotEmpty) {
        consecutiveDays++;
      } else if (i > 0) {
        break;
      }
    }

    // 주간 배변 횟수 계산
    final weekStart = today.subtract(Duration(days: today.weekday - 1));
    int weeklyCount = 0;
    for (int i = 0; i < 7; i++) {
      final checkDate = weekStart.add(Duration(days: i));
      final dayRecords = allRecords.where((r) =>
          r.dateTime.year == checkDate.year &&
          r.dateTime.month == checkDate.month &&
          r.dateTime.day == checkDate.day);
      weeklyCount += dayRecords.length;
    }

    return DailySummaryEntity(
      date: date,
      lastBowelTime: lastBowelTime,
      consecutiveDays: consecutiveDays,
      weeklyBowelCount: weeklyCount,
      waterIntakeMl: waterTotal,
      waterGoalMl: 2000, // 기본 목표량
    );
  }

  @override
  Future<HealthScoreEntity> getHealthScore(DateTime date) async {
    final allRecords = await _recordRepository.getAllRecords();
    final waterTotal = await _waterRecordRepository.getDailyTotal(date);

    // 배변 상태 점수 (Bristol 3-5가 이상적)
    int bowelConditionScore = 28;
    if (allRecords.isNotEmpty) {
      final recentRecords = allRecords.take(7).toList();
      final normalCount = recentRecords
          .where((r) => r.bristolType >= 3 && r.bristolType <= 5)
          .length;
      bowelConditionScore = ((normalCount / recentRecords.length) * 30).round();
    }

    // 배변 규칙성 점수
    int bowelRegularityScore = 25;

    // 수분 섭취 점수
    int waterIntakeScore = ((waterTotal / 2000) * 20).round().clamp(0, 20);

    // 배변 편안함 점수
    int bowelComfortScore = 13;
    if (allRecords.isNotEmpty) {
      final comfortCount =
          allRecords.take(7).where((r) => r.feeling <= 1).length;
      bowelComfortScore = ((comfortCount / 7) * 15).round().clamp(0, 15);
    }

    // 배변 빈도 점수
    int bowelFrequencyScore = 10;

    final totalScore = bowelConditionScore +
        bowelRegularityScore +
        waterIntakeScore +
        bowelComfortScore +
        bowelFrequencyScore;

    // 피드백 생성
    final positiveFeedbacks = <String>[];
    final negativeFeedbacks = <String>[];

    if (bowelConditionScore >= 25) {
      positiveFeedbacks.add('이상적인 배변 상태를 유지하고 있습니다');
    }
    if (bowelRegularityScore >= 20) {
      positiveFeedbacks.add('규칙적인 배변 패턴을 보이고 있습니다');
    }
    if (bowelComfortScore >= 10) {
      positiveFeedbacks.add('편안한 배변을 하고 있습니다');
    }

    if (waterIntakeScore < 15) {
      negativeFeedbacks.add('물을 조금 더 마셔보세요');
    }

    return HealthScoreEntity(
      totalScore: totalScore.clamp(0, 100),
      bowelConditionScore: bowelConditionScore,
      bowelRegularityScore: bowelRegularityScore,
      waterIntakeScore: waterIntakeScore,
      bowelComfortScore: bowelComfortScore,
      bowelFrequencyScore: bowelFrequencyScore,
      positiveFeedbacks: positiveFeedbacks,
      negativeFeedbacks: negativeFeedbacks,
    );
  }

  @override
  Future<List<RecentRecordEntity>> getRecentRecords(DateTime date) async {
    final records = <RecentRecordEntity>[];

    // 배변 기록
    final bowelRecords = await _recordRepository.getRecordsByDate(date);
    if (bowelRecords.isNotEmpty) {
      final latest = bowelRecords.first;
      final bristolNames = [
        '',
        '딱딱한 덩어리',
        '울퉁불퉁한 소시지',
        '갈라진 소시지',
        '부드러운 소시지',
        '부드러운 덩어리',
        '뭉게뭉게',
        '물처럼 묽은'
      ];
      records.add(RecentRecordEntity(
        type: RecordType.bowel,
        emoji: '💩',
        title: 'Bristol Type ${latest.bristolType} - ${bristolNames[latest.bristolType]}',
        subtitle: '배변 기록',
        time: '${latest.dateTime.hour.toString().padLeft(2, '0')}:${latest.dateTime.minute.toString().padLeft(2, '0')}',
        backgroundColor: const Color(0xFF90EE90),
      ));
    }

    // 식사 기록
    final mealRecords = await _mealRecordRepository.getRecordsByDate(date);
    if (mealRecords.isNotEmpty) {
      records.add(RecentRecordEntity(
        type: RecordType.meal,
        emoji: '🍽️',
        title: '식사 ${mealRecords.length}회 기록됨',
        subtitle: '식단 기록',
        time: '오늘',
        backgroundColor: const Color(0xFFD8BFD8),
      ));
    }

    // 수분 기록
    final waterRecords = await _waterRecordRepository.getRecordsByDate(date);
    if (waterRecords.isNotEmpty) {
      final totalMl =
          waterRecords.fold<int>(0, (sum, r) => sum + r.amountMl);
      records.add(RecentRecordEntity(
        type: RecordType.water,
        emoji: '💧',
        title: '수분 ${waterRecords.length}회 (${totalMl}ml)',
        subtitle: '수분 섭취 기록',
        time: '오늘',
        backgroundColor: const Color(0xFF87CEEB),
      ));
    }

    // 운동 기록
    final exerciseRecords =
        await _exerciseRecordRepository.getRecordsByDate(date);
    if (exerciseRecords.isNotEmpty) {
      final totalMinutes =
          exerciseRecords.fold<int>(0, (sum, r) => sum + r.durationMinutes);
      records.add(RecentRecordEntity(
        type: RecordType.exercise,
        emoji: '🏃',
        title: '운동 ${exerciseRecords.length}회 ($totalMinutes분)',
        subtitle: '운동 기록',
        time: '오늘',
        backgroundColor: const Color(0xFF98FB98),
      ));
    }

    return records;
  }
}
