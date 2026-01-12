import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repository/analytics_repository_impl.dart';
import '../domain/repository/analytics_repository.dart';
import '../domain/usecase/get_analytics_summary_usecase.dart';
import '../domain/usecase/get_bowel_distribution_usecase.dart';
import '../domain/usecase/get_weekly_frequency_usecase.dart';
import '../domain/usecase/get_insights_usecase.dart';
import '../presentation/provider/analytics_notifier.dart';
import '../presentation/provider/analytics_state.dart';
import '../../record/di/record_providers.dart';
import '../../water_record/di/water_record_providers.dart';

/// Analytics Repository Provider
final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  final recordRepo = ref.watch(recordRepositoryProvider);
  final waterRepo = ref.watch(waterRecordRepositoryProvider);
  return AnalyticsRepositoryImpl(recordRepo, waterRepo);
});

/// GetAnalyticsSummaryUseCase Provider
final getAnalyticsSummaryUseCaseProvider =
    Provider<GetAnalyticsSummaryUseCase>((ref) {
  final repository = ref.watch(analyticsRepositoryProvider);
  return GetAnalyticsSummaryUseCase(repository);
});

/// GetBowelDistributionUseCase Provider
final getBowelDistributionUseCaseProvider =
    Provider<GetBowelDistributionUseCase>((ref) {
  final repository = ref.watch(analyticsRepositoryProvider);
  return GetBowelDistributionUseCase(repository);
});

/// GetWeeklyFrequencyUseCase Provider
final getWeeklyFrequencyUseCaseProvider =
    Provider<GetWeeklyFrequencyUseCase>((ref) {
  final repository = ref.watch(analyticsRepositoryProvider);
  return GetWeeklyFrequencyUseCase(repository);
});

/// GetInsightsUseCase Provider
final getInsightsUseCaseProvider = Provider<GetInsightsUseCase>((ref) {
  final repository = ref.watch(analyticsRepositoryProvider);
  return GetInsightsUseCase(repository);
});

/// Analytics Notifier Provider (autoDispose 사용하지 않음 - 메인 화면)
final analyticsNotifierProvider =
    StateNotifierProvider<AnalyticsNotifier, AnalyticsState>((ref) {
  final getAnalyticsSummaryUseCase =
      ref.watch(getAnalyticsSummaryUseCaseProvider);
  final getBowelDistributionUseCase =
      ref.watch(getBowelDistributionUseCaseProvider);
  final getWeeklyFrequencyUseCase =
      ref.watch(getWeeklyFrequencyUseCaseProvider);
  final getInsightsUseCase = ref.watch(getInsightsUseCaseProvider);
  return AnalyticsNotifier(
    getAnalyticsSummaryUseCase,
    getBowelDistributionUseCase,
    getWeeklyFrequencyUseCase,
    getInsightsUseCase,
  );
});

/// Analytics 화면 갱신 트리거
void refreshAnalytics(WidgetRef ref) {
  ref.read(analyticsNotifierProvider.notifier).refresh();
}
