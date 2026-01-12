import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasource/meal_record_local_datasource.dart';
import '../data/repository/meal_record_repository_impl.dart';
import '../domain/entity/meal_record_entity.dart';
import '../domain/repository/meal_record_repository.dart';
import '../domain/usecase/create_meal_record_usecase.dart';
import '../domain/usecase/get_meal_records_by_date_usecase.dart';
import '../presentation/provider/meal_record_form_notifier.dart';
import '../presentation/provider/meal_record_form_state.dart';

/// DataSource Provider (Singleton으로 데이터 유지)
final mealRecordLocalDataSourceProvider =
    Provider<MealRecordLocalDataSource>((ref) {
  return MealRecordLocalDataSource();
});

/// Repository Provider
final mealRecordRepositoryProvider = Provider<MealRecordRepository>((ref) {
  final dataSource = ref.watch(mealRecordLocalDataSourceProvider);
  return MealRecordRepositoryImpl(dataSource);
});

/// CreateMealRecordUseCase Provider
final createMealRecordUseCaseProvider =
    Provider<CreateMealRecordUseCase>((ref) {
  final repository = ref.watch(mealRecordRepositoryProvider);
  return CreateMealRecordUseCase(repository);
});

/// GetMealRecordsByDateUseCase Provider
final getMealRecordsByDateUseCaseProvider =
    Provider<GetMealRecordsByDateUseCase>((ref) {
  final repository = ref.watch(mealRecordRepositoryProvider);
  return GetMealRecordsByDateUseCase(repository);
});

/// MealRecordFormNotifier Provider (autoDispose for form screens)
final mealRecordFormNotifierProvider = StateNotifierProvider.autoDispose<
    MealRecordFormNotifier, MealRecordFormState>((ref) {
  final createMealRecordUseCase = ref.watch(createMealRecordUseCaseProvider);
  return MealRecordFormNotifier(createMealRecordUseCase);
});

/// 오늘 식사 기록 Provider
final todayMealRecordsProvider =
    FutureProvider<List<MealRecordEntity>>((ref) async {
  final useCase = ref.watch(getMealRecordsByDateUseCaseProvider);
  final result = await useCase(DateTime.now());
  return result.fold(
    (failure) => throw Exception(failure.message),
    (records) => records,
  );
});

/// 오늘 식사 횟수 Provider
final todayMealCountProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(mealRecordRepositoryProvider);
  return repository.getDailyMealCount(DateTime.now());
});

/// 식사 기록 갱신을 위한 StateProvider
final mealRecordsRefreshProvider = StateProvider<int>((ref) => 0);

/// 식사 기록 갱신 트리거
void refreshMealRecords(WidgetRef ref) {
  ref.read(mealRecordsRefreshProvider.notifier).state++;
  ref.invalidate(todayMealRecordsProvider);
  ref.invalidate(todayMealCountProvider);
}
