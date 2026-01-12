import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/domain/usecase/usecase.dart';
import '../../domain/usecase/get_analytics_summary_usecase.dart';
import '../../domain/usecase/get_bowel_distribution_usecase.dart';
import '../../domain/usecase/get_weekly_frequency_usecase.dart';
import '../../domain/usecase/get_insights_usecase.dart';
import 'analytics_state.dart';

/// Analytics 화면 Notifier
class AnalyticsNotifier extends StateNotifier<AnalyticsState> {
  final GetAnalyticsSummaryUseCase _getAnalyticsSummaryUseCase;
  final GetBowelDistributionUseCase _getBowelDistributionUseCase;
  final GetWeeklyFrequencyUseCase _getWeeklyFrequencyUseCase;
  final GetInsightsUseCase _getInsightsUseCase;

  static const int _defaultPeriod = 30; // 기본 분석 기간 (30일)

  AnalyticsNotifier(
    this._getAnalyticsSummaryUseCase,
    this._getBowelDistributionUseCase,
    this._getWeeklyFrequencyUseCase,
    this._getInsightsUseCase,
  ) : super(const AnalyticsLoading()) {
    loadData();
  }

  /// 데이터 로드
  Future<void> loadData() async {
    state = const AnalyticsLoading();

    try {
      final summaryResult =
          await _getAnalyticsSummaryUseCase(_defaultPeriod);
      final distributionResult =
          await _getBowelDistributionUseCase(_defaultPeriod);
      final weeklyResult =
          await _getWeeklyFrequencyUseCase(const NoParams());
      final insightsResult = await _getInsightsUseCase(const NoParams());

      // 모든 결과 확인
      final summary = summaryResult.fold(
        (failure) => throw Exception(failure.message),
        (data) => data,
      );
      final distribution = distributionResult.fold(
        (failure) => throw Exception(failure.message),
        (data) => data,
      );
      final weeklyFrequency = weeklyResult.fold(
        (failure) => throw Exception(failure.message),
        (data) => data,
      );
      final insights = insightsResult.fold(
        (failure) => throw Exception(failure.message),
        (data) => data,
      );

      state = AnalyticsLoaded(
        summary: summary,
        distribution: distribution,
        weeklyFrequency: weeklyFrequency,
        insights: insights,
      );
    } catch (e) {
      state = AnalyticsError(message: e.toString());
    }
  }

  /// 새로고침
  Future<void> refresh() async {
    await loadData();
  }
}
