/// 일일 요약 엔티티
class DailySummaryEntity {
  final DateTime date;
  final DateTime? lastBowelTime;
  final int consecutiveDays;
  final int weeklyBowelCount;
  final int waterIntakeMl;
  final int waterGoalMl;

  const DailySummaryEntity({
    required this.date,
    this.lastBowelTime,
    required this.consecutiveDays,
    required this.weeklyBowelCount,
    required this.waterIntakeMl,
    required this.waterGoalMl,
  });

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
