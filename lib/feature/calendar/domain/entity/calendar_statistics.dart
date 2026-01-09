/// 캘린더 통계 Entity
class CalendarStatistics {
  final int totalRecordsThisMonth;
  final double healthyPercentage;
  final double averageIntervalDays;

  const CalendarStatistics({
    required this.totalRecordsThisMonth,
    required this.healthyPercentage,
    required this.averageIntervalDays,
  });

  factory CalendarStatistics.empty() {
    return const CalendarStatistics(
      totalRecordsThisMonth: 0,
      healthyPercentage: 0.0,
      averageIntervalDays: 0.0,
    );
  }

  CalendarStatistics copyWith({
    int? totalRecordsThisMonth,
    double? healthyPercentage,
    double? averageIntervalDays,
  }) {
    return CalendarStatistics(
      totalRecordsThisMonth: totalRecordsThisMonth ?? this.totalRecordsThisMonth,
      healthyPercentage: healthyPercentage ?? this.healthyPercentage,
      averageIntervalDays: averageIntervalDays ?? this.averageIntervalDays,
    );
  }
}
