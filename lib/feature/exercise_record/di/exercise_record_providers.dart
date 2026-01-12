import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasource/exercise_record_local_datasource.dart';
import '../data/repository/exercise_record_repository_impl.dart';
import '../domain/entity/exercise_record_entity.dart';
import '../domain/repository/exercise_record_repository.dart';
import '../domain/usecase/create_exercise_record_usecase.dart';
import '../domain/usecase/get_exercise_records_by_date_usecase.dart';
import '../presentation/provider/exercise_record_form_notifier.dart';
import '../presentation/provider/exercise_record_form_state.dart';

/// DataSource Provider (Singleton으로 데이터 유지)
final exerciseRecordLocalDataSourceProvider =
    Provider<ExerciseRecordLocalDataSource>((ref) {
  return ExerciseRecordLocalDataSource();
});

/// Repository Provider
final exerciseRecordRepositoryProvider =
    Provider<ExerciseRecordRepository>((ref) {
  final dataSource = ref.watch(exerciseRecordLocalDataSourceProvider);
  return ExerciseRecordRepositoryImpl(dataSource);
});

/// CreateExerciseRecordUseCase Provider
final createExerciseRecordUseCaseProvider =
    Provider<CreateExerciseRecordUseCase>((ref) {
  final repository = ref.watch(exerciseRecordRepositoryProvider);
  return CreateExerciseRecordUseCase(repository);
});

/// GetExerciseRecordsByDateUseCase Provider
final getExerciseRecordsByDateUseCaseProvider =
    Provider<GetExerciseRecordsByDateUseCase>((ref) {
  final repository = ref.watch(exerciseRecordRepositoryProvider);
  return GetExerciseRecordsByDateUseCase(repository);
});

/// ExerciseRecordFormNotifier Provider (autoDispose for form screens)
final exerciseRecordFormNotifierProvider = StateNotifierProvider.autoDispose<
    ExerciseRecordFormNotifier, ExerciseRecordFormState>((ref) {
  final createExerciseRecordUseCase =
      ref.watch(createExerciseRecordUseCaseProvider);
  return ExerciseRecordFormNotifier(createExerciseRecordUseCase);
});

/// 오늘 운동 기록 Provider
final todayExerciseRecordsProvider =
    FutureProvider<List<ExerciseRecordEntity>>((ref) async {
  final useCase = ref.watch(getExerciseRecordsByDateUseCaseProvider);
  final result = await useCase(DateTime.now());
  return result.fold(
    (failure) => throw Exception(failure.message),
    (records) => records,
  );
});

/// 오늘 총 운동 시간(분) Provider
final todayExerciseTotalMinutesProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(exerciseRecordRepositoryProvider);
  return repository.getDailyTotalMinutes(DateTime.now());
});

/// 운동 기록 갱신을 위한 StateProvider
final exerciseRecordsRefreshProvider = StateProvider<int>((ref) => 0);

/// 운동 기록 갱신 트리거
void refreshExerciseRecords(WidgetRef ref) {
  ref.read(exerciseRecordsRefreshProvider.notifier).state++;
  ref.invalidate(todayExerciseRecordsProvider);
  ref.invalidate(todayExerciseTotalMinutesProvider);
}
