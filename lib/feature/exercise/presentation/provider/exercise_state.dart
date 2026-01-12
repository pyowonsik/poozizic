/// 운동 기록 상태
sealed class ExerciseState {
  const ExerciseState();
}

/// 초기 상태
class ExerciseInitial extends ExerciseState {
  const ExerciseInitial({
    this.selectedExercise,
    this.duration = 30,
    this.selectedIntensity,
  });

  final int? selectedExercise;
  final int duration;
  final int? selectedIntensity;
}

/// 진행 중 상태
class ExerciseInProgress extends ExerciseState {
  const ExerciseInProgress({
    required this.selectedExercise,
    required this.duration,
    required this.selectedIntensity,
  });

  final int? selectedExercise;
  final int duration;
  final int? selectedIntensity;
}

/// 제출 중 상태
class ExerciseSubmitting extends ExerciseState {
  const ExerciseSubmitting();
}

/// 성공 상태
class ExerciseSuccess extends ExerciseState {
  const ExerciseSuccess();
}

/// 에러 상태
class ExerciseError extends ExerciseState {
  const ExerciseError({
    required this.message,
  });

  final String message;
}
