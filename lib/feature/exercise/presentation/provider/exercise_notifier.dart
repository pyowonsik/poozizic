import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecase/create_exercise_record_usecase.dart';
import 'exercise_state.dart';

/// 운동 기록 Notifier
class ExerciseNotifier extends StateNotifier<ExerciseState> {
  ExerciseNotifier(this._createExerciseRecordUseCase)
      : super(const ExerciseInitial());

  final CreateExerciseRecordUseCase _createExerciseRecordUseCase;

  /// 운동 종류 선택
  void selectExercise(int exercise) {
    final currentState = state;
    int currentDuration;
    int? currentIntensity;

    if (currentState is ExerciseInitial) {
      currentDuration = currentState.duration;
      currentIntensity = currentState.selectedIntensity;
    } else if (currentState is ExerciseInProgress) {
      currentDuration = currentState.duration;
      currentIntensity = currentState.selectedIntensity;
    } else {
      return;
    }

    state = ExerciseInProgress(
      selectedExercise: exercise,
      duration: currentDuration,
      selectedIntensity: currentIntensity,
    );
  }

  /// 운동 시간 설정
  void setDuration(int duration) {
    final currentState = state;
    int? currentExercise;
    int? currentIntensity;

    if (currentState is ExerciseInitial) {
      currentExercise = currentState.selectedExercise;
      currentIntensity = currentState.selectedIntensity;
    } else if (currentState is ExerciseInProgress) {
      currentExercise = currentState.selectedExercise;
      currentIntensity = currentState.selectedIntensity;
    } else {
      return;
    }

    state = ExerciseInProgress(
      selectedExercise: currentExercise,
      duration: duration,
      selectedIntensity: currentIntensity,
    );
  }

  /// 운동 강도 선택
  void selectIntensity(int intensity) {
    final currentState = state;
    int? currentExercise;
    int currentDuration;

    if (currentState is ExerciseInitial) {
      currentExercise = currentState.selectedExercise;
      currentDuration = currentState.duration;
    } else if (currentState is ExerciseInProgress) {
      currentExercise = currentState.selectedExercise;
      currentDuration = currentState.duration;
    } else {
      return;
    }

    state = ExerciseInProgress(
      selectedExercise: currentExercise,
      duration: currentDuration,
      selectedIntensity: intensity,
    );
  }

  /// 기록 제출
  Future<void> submitRecord() async {
    final currentState = state;
    int? exerciseType;
    int duration;
    int? intensity;

    if (currentState is ExerciseInProgress) {
      exerciseType = currentState.selectedExercise;
      duration = currentState.duration;
      intensity = currentState.selectedIntensity;
    } else if (currentState is ExerciseInitial) {
      exerciseType = currentState.selectedExercise;
      duration = currentState.duration;
      intensity = currentState.selectedIntensity;
    } else {
      return;
    }

    // 검증
    if (exerciseType == null || intensity == null) {
      state = const ExerciseError(message: '모든 항목을 선택해주세요.');
      return;
    }

    state = const ExerciseSubmitting();

    final result = await _createExerciseRecordUseCase(
      CreateExerciseRecordParams(
        exerciseType: exerciseType,
        duration: duration,
        intensity: intensity,
      ),
    );

    result.fold(
      (failure) => state = ExerciseError(message: failure.message),
      (_) => state = const ExerciseSuccess(),
    );
  }
}
