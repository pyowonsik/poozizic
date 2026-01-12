import 'package:poozizic/feature/home/domain/entity/daily_summary_entity.dart';
import 'package:poozizic/feature/home/domain/entity/health_score_entity.dart';
import 'package:poozizic/feature/home/domain/entity/recent_record_entity.dart';

/// Home 화면 상태 (Sealed Class)
sealed class HomeState {
  const HomeState();
}

/// 로딩 상태
class HomeLoading extends HomeState {
  /// Home 로딩 상태 생성자
  const HomeLoading();
}

/// 로드 완료 상태
class HomeLoaded extends HomeState {
  /// Home 로드 완료 상태 생성자
  const HomeLoaded({
    required this.selectedDate,
    required this.summary,
    required this.healthScore,
    required this.recentRecords,
    this.isHealthScoreExpanded = false,
  });

  /// 선택된 날짜
  final DateTime selectedDate;

  /// 일일 요약 정보
  final DailySummaryEntity summary;

  /// 건강 점수 정보
  final HealthScoreEntity healthScore;

  /// 최근 기록 목록
  final List<RecentRecordEntity> recentRecords;

  /// 건강 점수 확장 여부
  final bool isHealthScoreExpanded;

  /// Home 로드 완료 상태 복사
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
  /// Home 에러 상태 생성자
  /// [message] 에러 메시지
  const HomeError({required this.message});

  /// 에러 메시지
  final String message;
}
