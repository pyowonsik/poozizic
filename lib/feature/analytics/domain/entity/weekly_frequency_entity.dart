/// 주간 배변 빈도 엔티티
class WeeklyFrequencyEntity {
  final List<int> dailyCounts; // [월, 화, 수, 목, 금, 토, 일]

  const WeeklyFrequencyEntity({
    required this.dailyCounts,
  });

  /// 주간 총 배변 횟수
  int get totalCount => dailyCounts.fold<int>(0, (a, b) => a + b);

  /// 최대 일일 배변 횟수 (차트 Y축 최대값 계산용)
  int get maxDailyCount {
    if (dailyCounts.isEmpty) return 0;
    int max = dailyCounts[0];
    for (final count in dailyCounts) {
      if (count > max) max = count;
    }
    return max;
  }

  /// 평균 일일 배변 횟수
  double get averageCount => dailyCounts.isNotEmpty
      ? totalCount / dailyCounts.length
      : 0;

  /// 요일별 라벨
  static const List<String> dayLabels = ['월', '화', '수', '목', '금', '토', '일'];
}
