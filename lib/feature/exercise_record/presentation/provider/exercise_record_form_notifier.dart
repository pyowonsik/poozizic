import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poozizic/feature/exercise_record/domain/usecase/create_exercise_record_usecase.dart';
import 'package:poozizic/feature/exercise_record/presentation/provider/exercise_record_form_state.dart';

/// 운동 타입 정보
class ExerciseType {
  /// 운동 타입 정보 생성자
  const ExerciseType({required this.emoji, required this.label});

  /// 운돱 타입 이모지
  final String emoji;

  /// 운동 타입 라벨
  final String label;
}

/// 강도 정보
class Intensity {
  /// 강도 정보 생성자
  const Intensity({required this.emoji, required this.label});

  /// 강도 이모지
  final String emoji;

  /// 강도 라벨
  final String label;
}

/// ExerciseRecord 폼 Notifier
class ExerciseRecordFormNotifier
    extends StateNotifier<ExerciseRecordFormState> {
  /// ExerciseRecord 폼 Notifier 생성자
  ExerciseRecordFormNotifier(this._createExerciseRecordUseCase)
    : super(const ExerciseRecordFormInProgress());
  final CreateExerciseRecordUseCase _createExerciseRecordUseCase;

  /// 운동 타입 목록
  static const List<ExerciseType> exerciseTypes = [
    ExerciseType(emoji: '🏃', label: '달리기'),
    ExerciseType(emoji: '🚶', label: '걷기'),
    ExerciseType(emoji: '🚴', label: '자전거'),
    ExerciseType(emoji: '🏊', label: '수영'),
    ExerciseType(emoji: '🧘', label: '요가'),
    ExerciseType(emoji: '🏋️', label: '웨이트'),
  ];

  /// 강도 목록
  static const List<Intensity> intensities = [
    Intensity(emoji: '😌', label: '가볍게'),
    Intensity(emoji: '💪', label: '보통'),
    Intensity(emoji: '🔥', label: '격하게'),
  ];

  /// 빠른 시간 선택 목록
  static const List<int> quickDurations = [15, 30, 45, 60];

  /// 운동 타입 선택
  void selectExercise(int index) {
    final currentState = state;
    if (currentState is ExerciseRecordFormInProgress) {
      state = currentState.copyWith(selectedExercise: index);
    }
  }

  /// 시간 설정 (슬라이더)
  void setDuration(double duration) {
    final currentState = state;
    if (currentState is ExerciseRecordFormInProgress) {
      state = currentState.copyWith(duration: duration);
    }
  }

  /// 빠른 시간 선택
  void selectQuickDuration(int minutes) {
    final currentState = state;
    if (currentState is ExerciseRecordFormInProgress) {
      state = currentState.copyWith(duration: minutes.toDouble());
    }
  }

  /// 강도 선택
  void selectIntensity(int index) {
    final currentState = state;
    if (currentState is ExerciseRecordFormInProgress) {
      state = currentState.copyWith(selectedIntensity: index);
    }
  }

  /// 제출
  Future<void> submit() async {
    final currentState = state;
    if (currentState is! ExerciseRecordFormInProgress) return;
    if (!currentState.canSubmit) return;

    state = ExerciseRecordFormSubmitting(
      selectedExercise: currentState.selectedExercise!,
      duration: currentState.duration,
      selectedIntensity: currentState.selectedIntensity!,
    );

    final result = await _createExerciseRecordUseCase(
      CreateExerciseRecordParams(
        exerciseType: currentState.selectedExercise!,
        durationMinutes: currentState.duration.toInt(),
        intensity: currentState.selectedIntensity!,
      ),
    );

    result.fold(
      (failure) {
        state = ExerciseRecordFormError(
          message: failure.message,
          selectedExercise: currentState.selectedExercise,
          duration: currentState.duration,
          selectedIntensity: currentState.selectedIntensity,
        );
      },
      (record) {
        state = ExerciseRecordFormSuccess(record: record);
      },
    );
  }

  /// 에러에서 복구
  void clearError() {
    final currentState = state;
    if (currentState is ExerciseRecordFormError) {
      state = ExerciseRecordFormInProgress(
        selectedExercise: currentState.selectedExercise,
        duration: currentState.duration,
        selectedIntensity: currentState.selectedIntensity,
      );
    }
  }
}
