import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasource/exercise_local_datasource.dart';
import '../data/repository/exercise_repository_impl.dart';
import '../domain/entity/exercise_record_entity.dart';
import '../domain/repository/exercise_repository.dart';
import '../domain/usecase/create_exercise_record_usecase.dart';
import '../domain/usecase/get_exercise_records_usecase.dart';
import '../../../shared/domain/usecase/usecase.dart';
import '../presentation/provider/exercise_notifier.dart';
import '../presentation/provider/exercise_state.dart';

/// DataSource Provider (Singleton으로 데이터 유지)
final exerciseLocalDataSourceProvider = Provider<ExerciseLocalDataSource>((ref) {
  return ExerciseLocalDataSource();
});

/// Repository Provider
final exerciseRepositoryProvider = Provider<ExerciseRepository>((ref) {
  final dataSource = ref.watch(exerciseLocalDataSourceProvider);
  return ExerciseRepositoryImpl(dataSource);
});

/// CreateExerciseRecordUseCase Provider
final createExerciseRecordUseCaseProvider = Provider<CreateExerciseRecordUseCase>((ref) {
  final repository = ref.watch(exerciseRepositoryProvider);
  return CreateExerciseRecordUseCase(repository);
});

/// GetExerciseRecordsUseCase Provider
final getExerciseRecordsUseCaseProvider = Provider<GetExerciseRecordsUseCase>((ref) {
  final repository = ref.watch(exerciseRepositoryProvider);
  return GetExerciseRecordsUseCase(repository);
});

/// ExerciseNotifier Provider
final exerciseNotifierProvider =
    StateNotifierProvider.autoDispose<ExerciseNotifier, ExerciseState>((ref) {
  final createExerciseRecordUseCase = ref.watch(createExerciseRecordUseCaseProvider);
  return ExerciseNotifier(createExerciseRecordUseCase);
});

/// 전체 Exercise Records Provider
final exerciseRecordsProvider = FutureProvider<List<ExerciseRecordEntity>>((ref) async {
  final useCase = ref.watch(getExerciseRecordsUseCaseProvider);
  final result = await useCase(const NoParams());
  return result.fold(
    (failure) => throw Exception(failure.message),
    (records) => records,
  );
});
