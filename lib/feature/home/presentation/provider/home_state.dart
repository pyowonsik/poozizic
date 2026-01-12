import '../../domain/entity/daily_summary_entity.dart';
import '../../domain/entity/health_score_entity.dart';
import '../../domain/entity/recent_record_entity.dart';

/// Home 화면 상태 (Sealed Class)
sealed class HomeState {
  const HomeState();
}

/// 로딩 상태
class HomeLoading extends HomeState {
  const HomeLoading();
}

/// 로드 완료 상태
class HomeLoaded extends HomeState {
  final DateTime selectedDate;
  final DailySummaryEntity summary;
  final HealthScoreEntity healthScore;
  final List<RecentRecordEntity> recentRecords;
  final bool isHealthScoreExpanded;

  const HomeLoaded({
    required this.selectedDate,
    required this.summary,
    required this.healthScore,
    required this.recentRecords,
    this.isHealthScoreExpanded = false,
  });

  HomeLoaded copyWith({
    DateTime? selectedDate,
    DailySummaryEntity? summary,
    HealthScoreEntity? healthScore,
    List<RecentRecordEntity>? recentRecords,
    bool? isHealthScoreExpanded,
  }) {
    return HomeLoaded(
      selectedDate: selectedDate ?? this.selectedDate,
      summary: summary ?? this.summary,
      healthScore: healthScore ?? this.healthScore,
      recentRecords: recentRecords ?? this.recentRecords,
      isHealthScoreExpanded:
          isHealthScoreExpanded ?? this.isHealthScoreExpanded,
    );
  }
}

/// 에러 상태
class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});
}
