/// 캘린더 통계 Entity
class CalendarStatistics {
  /// 캘린더 통계 Entity 생성자
  const CalendarStatistics({
    required this.totalRecordsThisMonth,
    required this.healthyPercentage,
    required this.averageIntervalDays,
  });

  /// 캘린더 통계 Entity 빈 객체 생성
  factory CalendarStatistics.empty() {
    return const CalendarStatistics(
      totalRecordsThisMonth: 0,
      healthyPercentage: 0,
      averageIntervalDays: 0,
    );
  }

  /// 총 기록 수
  final int totalRecordsThisMonth;

  /// 정상 비율
  final double healthyPercentage;

  /// 평균 간격
  final double averageIntervalDays;

  /// 캘린더 통계 Entity 복사
  CalendarStatistics copyWith({
    int? totalRecordsThisMonth,
    double? healthyPercentage,
    double? averageIntervalDays,
  }) {
    return CalendarStatistics(
      totalRecordsThisMonth:
          totalRecordsThisMonth ?? this.totalRecordsThisMonth,
      healthyPercentage: healthyPercentage ?? this.healthyPercentage,
      averageIntervalDays: averageIntervalDays ?? this.averageIntervalDays,
    );
  }
}
