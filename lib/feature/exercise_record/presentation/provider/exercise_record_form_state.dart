import '../../domain/entity/exercise_record_entity.dart';

/// ExerciseRecord 폼 상태 (Sealed Class)
sealed class ExerciseRecordFormState {
  const ExerciseRecordFormState();
}

/// 입력 진행 중 상태
class ExerciseRecordFormInProgress extends ExerciseRecordFormState {
  final int? selectedExercise;
  final double duration;
  final int? selectedIntensity;

  const ExerciseRecordFormInProgress({
    this.selectedExercise,
    this.duration = 30,
    this.selectedIntensity,
  });

  bool get canSubmit => selectedExercise != null && selectedIntensity != null;

  ExerciseRecordFormInProgress copyWith({
    int? selectedExercise,
    double? duration,
    int? selectedIntensity,
    bool clearExercise = false,
    bool clearIntensity = false,
  }) {
    return ExerciseRecordFormInProgress(
      selectedExercise:
          clearExercise ? null : (selectedExercise ?? this.selectedExercise),
      duration: duration ?? this.duration,
      selectedIntensity:
          clearIntensity ? null : (selectedIntensity ?? this.selectedIntensity),
    );
  }
}

/// 제출 중 상태
class ExerciseRecordFormSubmitting extends ExerciseRecordFormState {
  final int selectedExercise;
  final double duration;
  final int selectedIntensity;

  const ExerciseRecordFormSubmitting({
    required this.selectedExercise,
    required this.duration,
    required this.selectedIntensity,
  });
}

/// 성공 상태
class ExerciseRecordFormSuccess extends ExerciseRecordFormState {
  final ExerciseRecordEntity record;

  const ExerciseRecordFormSuccess({required this.record});
}

/// 에러 상태
class ExerciseRecordFormError extends ExerciseRecordFormState {
  final String message;
  final int? selectedExercise;
  final double duration;
  final int? selectedIntensity;

  const ExerciseRecordFormError({
    required this.message,
    this.selectedExercise,
    required this.duration,
    this.selectedIntensity,
  });
}
