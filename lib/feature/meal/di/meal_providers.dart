import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasource/meal_local_datasource.dart';
import '../data/repository/meal_repository_impl.dart';
import '../domain/entity/meal_record_entity.dart';
import '../domain/repository/meal_repository.dart';
import '../domain/usecase/create_meal_record_usecase.dart';
import '../domain/usecase/get_meal_records_usecase.dart';
import '../../../shared/domain/usecase/usecase.dart';
import '../presentation/provider/meal_notifier.dart';
import '../presentation/provider/meal_state.dart';

/// DataSource Provider (Singleton으로 데이터 유지)
final mealLocalDataSourceProvider = Provider<MealLocalDataSource>((ref) {
  return MealLocalDataSource();
});

/// Repository Provider
final mealRepositoryProvider = Provider<MealRepository>((ref) {
  final dataSource = ref.watch(mealLocalDataSourceProvider);
  return MealRepositoryImpl(dataSource);
});

/// CreateMealRecordUseCase Provider
final createMealRecordUseCaseProvider = Provider<CreateMealRecordUseCase>((ref) {
  final repository = ref.watch(mealRepositoryProvider);
  return CreateMealRecordUseCase(repository);
});

/// GetMealRecordsUseCase Provider
final getMealRecordsUseCaseProvider = Provider<GetMealRecordsUseCase>((ref) {
  final repository = ref.watch(mealRepositoryProvider);
  return GetMealRecordsUseCase(repository);
});

/// MealNotifier Provider
final mealNotifierProvider =
    StateNotifierProvider.autoDispose<MealNotifier, MealState>((ref) {
  final createMealRecordUseCase = ref.watch(createMealRecordUseCaseProvider);
  return MealNotifier(createMealRecordUseCase);
});

/// 전체 Meal Records Provider
final mealRecordsProvider = FutureProvider<List<MealRecordEntity>>((ref) async {
  final useCase = ref.watch(getMealRecordsUseCaseProvider);
  final result = await useCase(const NoParams());
  return result.fold(
    (failure) => throw Exception(failure.message),
    (records) => records,
  );
});
