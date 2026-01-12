import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecase/get_daily_summary_usecase.dart';
import '../../domain/usecase/get_health_score_usecase.dart';
import '../../domain/usecase/get_recent_records_usecase.dart';
import 'home_state.dart';

/// Home 화면 Notifier
class HomeNotifier extends StateNotifier<HomeState> {
  final GetDailySummaryUseCase _getDailySummaryUseCase;
  final GetHealthScoreUseCase _getHealthScoreUseCase;
  final GetRecentRecordsUseCase _getRecentRecordsUseCase;

  HomeNotifier(
    this._getDailySummaryUseCase,
    this._getHealthScoreUseCase,
    this._getRecentRecordsUseCase,
  ) : super(const HomeLoading()) {
    loadData(DateTime.now());
  }

  /// 데이터 로드
  Future<void> loadData(DateTime date) async {
    state = const HomeLoading();

    try {
      final summaryResult = await _getDailySummaryUseCase(date);
      final healthScoreResult = await _getHealthScoreUseCase(date);
      final recentRecordsResult = await _getRecentRecordsUseCase(date);

      // 모든 결과 확인
      final summary = summaryResult.fold(
        (failure) => throw Exception(failure.message),
        (data) => data,
      );
      final healthScore = healthScoreResult.fold(
        (failure) => throw Exception(failure.message),
        (data) => data,
      );
      final recentRecords = recentRecordsResult.fold(
        (failure) => throw Exception(failure.message),
        (data) => data,
      );

      state = HomeLoaded(
        selectedDate: date,
        summary: summary,
        healthScore: healthScore,
        recentRecords: recentRecords,
      );
    } catch (e) {
      state = HomeError(message: e.toString());
    }
  }

  /// 날짜 선택
  void selectDate(DateTime date) {
    loadData(date);
  }

  /// 이전 날짜로 이동
  void goToPreviousDay() {
    final currentState = state;
    if (currentState is HomeLoaded) {
      final newDate = currentState.selectedDate.subtract(const Duration(days: 1));
      loadData(newDate);
    }
  }

  /// 다음 날짜로 이동
  void goToNextDay() {
    final currentState = state;
    if (currentState is HomeLoaded) {
      final newDate = currentState.selectedDate.add(const Duration(days: 1));
      loadData(newDate);
    }
  }

  /// 건강 점수 상세 토글
  void toggleHealthScoreExpanded() {
    final currentState = state;
    if (currentState is HomeLoaded) {
      state = currentState.copyWith(
        isHealthScoreExpanded: !currentState.isHealthScoreExpanded,
      );
    }
  }

  /// 새로고침
  Future<void> refresh() async {
    final currentState = state;
    if (currentState is HomeLoaded) {
      await loadData(currentState.selectedDate);
    } else {
      await loadData(DateTime.now());
    }
  }
}
