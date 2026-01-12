/// 건강 점수 엔티티
class HealthScoreEntity {
  /// 건강 점수 엔티티 생성자
  /// [totalScore] 총점
  /// [bowelConditionScore] 배변 상태 점수 (30점 만점)
  /// [bowelRegularityScore] 배변 규칙성 점수 (25점 만점)
  /// [waterIntakeScore] 수분 섭취 점수 (20점 만점)
  /// [bowelComfortScore] 배변 편안함 점수 (15점 만점)
  /// [bowelFrequencyScore] 배변 빈도 점수 (10점 만점)
  /// [positiveFeedbacks] 긍정적 피드백 목록
  /// [negativeFeedbacks] 부정적 피드백 목록
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

  /// 총점
  final int totalScore;

  /// 배변 상태 점수 (30점 만점)
  final int bowelConditionScore; // /30

  /// 배변 규칙성 점수 (25점 만점)
  final int bowelRegularityScore; // /25

  /// 수분 섭취 점수 (20점 만점)
  final int waterIntakeScore; // /20

  /// 배변 편안함 점수 (15점 만점)
  final int bowelComfortScore; // /15

  /// 배변 빈도 점수 (10점 만점)
  final int bowelFrequencyScore; // /10

  /// 긍정적 피드백 목록
  final List<String> positiveFeedbacks;

  /// 부정적 피드백 목록
  final List<String> negativeFeedbacks;

  /// 점수별 표시 텍스트
  String get bowelConditionText => '$bowelConditionScore/30점';

  /// 배변 규칙성 점수 표시 텍스트
  String get bowelRegularityText => '$bowelRegularityScore/25점';

  /// 수분 섭취 점수 표시 텍스트
  String get waterIntakeText => '$waterIntakeScore/20점';

  /// 배변 편안함 점수 표시 텍스트
  String get bowelComfortText => '$bowelComfortScore/15점';

  /// 배변 빈도 점수 표시 텍스트
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
