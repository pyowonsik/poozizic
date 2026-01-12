/// 분석 요약 엔티티
class AnalyticsSummaryEntity {
  /// 분석 요약 엔티티 생성자
  /// [healthScore] 건강 점수
  /// [normalRatio] 정상 비율 (%)
  /// [averageInterval] 평균 간격 (일)
  /// [period] 분성 기간 (일)
  const AnalyticsSummaryEntity({
    required this.healthScore,
    required this.normalRatio,
    required this.averageInterval,
    required this.period,
  });

  /// 건강 점수
  final int healthScore;

  /// 정상 비율 (%)
  final double normalRatio;

  /// 평균 간격 (일)
  final double averageInterval;

  /// 분석 기간 (일)
  final int period;

  /// 건강 점수 표시 텍스트
  String get healthScoreText => '$healthScore';

  /// 정상 비율 표시 텍스트
  String get normalRatioText => '${normalRatio.toStringAsFixed(0)}%';

  /// 평균 간격 표시 텍스트
  String get averageIntervalText => '${averageInterval.toStringAsFixed(1)}일';
}
