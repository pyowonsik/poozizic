/// 건강 점수 엔티티
class HealthScoreEntity {
  final int totalScore;
  final int bowelConditionScore; // /30
  final int bowelRegularityScore; // /25
  final int waterIntakeScore; // /20
  final int bowelComfortScore; // /15
  final int bowelFrequencyScore; // /10
  final List<String> positiveFeedbacks;
  final List<String> negativeFeedbacks;

  const HealthScoreEntity({
    required this.totalScore,
    required this.bowelConditionScore,
    required this.bowelRegularityScore,
    required this.waterIntakeScore,
    required this.bowelComfortScore,
    required this.bowelFrequencyScore,
    required this.positiveFeedbacks,
    required this.negativeFeedbacks,
  });

  /// 점수별 표시 텍스트
  String get bowelConditionText => '$bowelConditionScore/30점';
  String get bowelRegularityText => '$bowelRegularityScore/25점';
  String get waterIntakeText => '$waterIntakeScore/20점';
  String get bowelComfortText => '$bowelComfortScore/15점';
  String get bowelFrequencyText => '$bowelFrequencyScore/10점';

  /// 점수 상태 (좋음, 보통, 나쁨)
  String get scoreStatus {
    if (totalScore >= 80) return '좋음';
    if (totalScore >= 50) return '보통';
    return '개선 필요';
  }

  /// 이상적인 상태인지
  bool get isIdeal => totalScore >= 80;
}
