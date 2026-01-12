import 'package:poozizic/feature/exercise_record/domain/entity/exercise_record_entity.dart';

/// ExerciseRecord 폼 상태 (Sealed Class)
sealed class ExerciseRecordFormState {
  const ExerciseRecordFormState();
}

/// 입력 진행 중 상태
class ExerciseRecordFormInProgress extends ExerciseRecordFormState {
  /// 입력 진행 중 상태 생성자
  /// [selectedExercise] 선택된 운동 타입
  /// [duration] 운동 시간
  /// [selectedIntensity] 선택된 운동 강도
  const ExerciseRecordFormInProgress({
    this.selectedExercise,
    this.duration = 30,
    this.selectedIntensity,
  });

  /// 선택된 운동 타입
  final int? selectedExercise;

  /// 운동 시간
  final double duration;

  /// 선택된 운동 강도
  final int? selectedIntensity;

  /// 제출 가능 여부
  bool get canSubmit => selectedExercise != null && selectedIntensity != null;

  /// 입력 진행 중 상태 복사
  ExerciseRecordFormInProgress copyWith({
    int? selectedExercise,
    double? duration,
    int? selectedIntensity,
    bool clearExercise = false,
    bool clearIntensity = false,
  }) {
    return ExerciseRecordFormInProgress(
      selectedExercise: clearExercise
          ? null
          : (selectedExercise ?? this.selectedExercise),
      duration: duration ?? this.duration,
      selectedIntensity: clearIntensity
          ? null
          : (selectedIntensity ?? this.selectedIntensity),
    );
  }
}

/// 제출 중 상태
class ExerciseRecordFormSubmitting extends ExerciseRecordFormState {
  /// 제출 중 상태 생성자
  /// [selectedExercise] 선택된 운동 타입
  /// [duration] 운동 시간
  /// [selectedIntensity] 선택된 운동 강도
  const ExerciseRecordFormSubmitting({
    required this.selectedExercise,
    required this.duration,
    required this.selectedIntensity,
  });

  /// 선택된 운동 타입
  final int selectedExercise;

  /// 운동 시간
  final double duration;

  /// 선택된 운동 강도
  final int selectedIntensity;
}

/// 성공 상태
class ExerciseRecordFormSuccess extends ExerciseRecordFormState {
  /// 성공 상태 생성자
  /// [record] 운동 기록 엔티티
  const ExerciseRecordFormSuccess({required this.record});

  /// 운동 기록 엔티티
  final ExerciseRecordEntity record;
}

/// 에러 상태
class ExerciseRecordFormError extends ExerciseRecordFormState {
  /// 에러 상태 생성자
  /// [message] 에러 메시지
  /// [selectedExercise] 선택된 운동 타입
  /// [duration] 운동 시간
  /// [selectedIntensity] 선택된 운동 강도
  const ExerciseRecordFormError({
    required this.message,
    required this.duration,
    this.selectedExercise,
    this.selectedIntensity,
  });

  /// 에러 메시지
  final String message;

  /// 선택된 운동 타입
  final int? selectedExercise;

  /// 운동 시간
  final double duration;

  /// 선택된 운동 강도
  final int? selectedIntensity;
}
