import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poozizic/feature/exercise_record/di/exercise_record_providers.dart';
import 'package:poozizic/feature/home/data/repository/home_repository_impl.dart';
import 'package:poozizic/feature/home/domain/repository/home_repository.dart';
import 'package:poozizic/feature/home/domain/usecase/get_daily_summary_usecase.dart';
import 'package:poozizic/feature/home/domain/usecase/get_health_score_usecase.dart';
import 'package:poozizic/feature/home/domain/usecase/get_recent_records_usecase.dart';
import 'package:poozizic/feature/home/presentation/provider/home_notifier.dart';
import 'package:poozizic/feature/home/presentation/provider/home_state.dart';
import 'package:poozizic/feature/meal_record/di/meal_record_providers.dart';
import 'package:poozizic/feature/record/di/record_providers.dart';
import 'package:poozizic/feature/water_record/di/water_record_providers.dart';

/// Home Repository Provider
final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final recordRepo = ref.watch(recordRepositoryProvider);
  final waterRepo = ref.watch(waterRecordRepositoryProvider);
  final mealRepo = ref.watch(mealRecordRepositoryProvider);
  final exerciseRepo = ref.watch(exerciseRecordRepositoryProvider);
  return HomeRepositoryImpl(recordRepo, waterRepo, mealRepo, exerciseRepo);
});

/// GetDailySummaryUseCase Provider
final getDailySummaryUseCaseProvider = Provider<GetDailySummaryUseCase>((ref) {
  final repository = ref.watch(homeRepositoryProvider);
  return GetDailySummaryUseCase(repository);
});

/// GetHealthScoreUseCase Provider
final getHealthScoreUseCaseProvider = Provider<GetHealthScoreUseCase>((ref) {
  final repository = ref.watch(homeRepositoryProvider);
  return GetHealthScoreUseCase(repository);
});

/// GetRecentRecordsUseCase Provider
final getRecentRecordsUseCaseProvider = Provider<GetRecentRecordsUseCase>((
  ref,
) {
  final repository = ref.watch(homeRepositoryProvider);
  return GetRecentRecordsUseCase(repository);
});

/// Home Notifier Provider (autoDispose 사용하지 않음 - 메인 화면)
final homeNotifierProvider = StateNotifierProvider<HomeNotifier, HomeState>((
  ref,
) {
  final getDailySummaryUseCase = ref.watch(getDailySummaryUseCaseProvider);
  final getHealthScoreUseCase = ref.watch(getHealthScoreUseCaseProvider);
  final getRecentRecordsUseCase = ref.watch(getRecentRecordsUseCaseProvider);
  return HomeNotifier(
    getDailySummaryUseCase,
    getHealthScoreUseCase,
    getRecentRecordsUseCase,
  );
});

/// Home 화면 갱신 트리거
void refreshHome(WidgetRef ref) {
  ref.read(homeNotifierProvider.notifier).refresh();
}
