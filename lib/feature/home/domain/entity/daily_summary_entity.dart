/// 일일 요약 엔티티
class DailySummaryEntity {
  /// 일일 요약 엔티티 생성자
  /// [date] 날짜
  /// [lastBowelTime] 마지막 배변 시간
  /// [consecutiveDays] 연속 기록 일수
  /// [weeklyBowelCount] 주간 배변 횟수
  /// [waterIntakeMl] 수분 섭취량 (ml)
  /// [waterGoalMl] 수분 목표량 (ml)
  const DailySummaryEntity({
    required this.date,
    required this.consecutiveDays,
    required this.weeklyBowelCount,
    required this.waterIntakeMl,
    required this.waterGoalMl,
    this.lastBowelTime,
  });

  /// 날짜
  final DateTime date;

  /// 마지막 배변 시간
  final DateTime? lastBowelTime;

  /// 연속 기록 일수
  final int consecutiveDays;

  /// 주간 배변 횟수
  final int weeklyBowelCount;

  /// 수분 섭취량 (ml)
  final int waterIntakeMl;

  /// 수분 목표량 (ml)
  final int waterGoalMl;

  /// 수분 섭취 진행률 (0.0 ~ 1.0)
  double get waterProgress =>
      waterGoalMl > 0 ? (waterIntakeMl / waterGoalMl).clamp(0.0, 1.0) : 0;

  /// 마지막 배변 시간 텍스트
  String get lastBowelText {
    if (lastBowelTime == null) return '기록 없음';

    final now = DateTime.now();
    final diff = now.difference(lastBowelTime!);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}분 전';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}시간 전';
    } else {
      return '${diff.inDays}일 전';
    }
  }

  /// 연속 기록 텍스트
  String get consecutiveText =>
      consecutiveDays > 0 ? '$consecutiveDays일째 🔥' : '아직 없음';

  /// 주간 배변 텍스트
  String get weeklyBowelText => '$weeklyBowelCount회';

  /// 수분 섭취 표시 텍스트 (L 단위)
  String get waterDisplayText {
    final intake = (waterIntakeMl / 1000).toStringAsFixed(1);
    final goal = (waterGoalMl / 1000).toStringAsFixed(0);
    return '${intake}L / ${goal}L';
  }
}
