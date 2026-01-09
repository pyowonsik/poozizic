import '../../domain/entity/record_entity.dart';

/// Record Form 상태
sealed class RecordFormState {
  const RecordFormState();
}

/// 초기 상태
class RecordFormInitial extends RecordFormState {
  const RecordFormInitial();
}

/// 진행 중 상태
class RecordFormInProgress extends RecordFormState {
  final int currentStep; // 0: Bristol, 1: Feeling, 2: Time
  final int? selectedBristolType;
  final int? selectedFeeling;
  final int selectedDuration;

  const RecordFormInProgress({
    required this.currentStep,
    this.selectedBristolType,
    this.selectedFeeling,
    this.selectedDuration = 10,
  });

  RecordFormInProgress copyWith({
    int? currentStep,
    int? selectedBristolType,
    int? selectedFeeling,
    int? selectedDuration,
  }) {
    return RecordFormInProgress(
      currentStep: currentStep ?? this.currentStep,
      selectedBristolType: selectedBristolType ?? this.selectedBristolType,
      selectedFeeling: selectedFeeling ?? this.selectedFeeling,
      selectedDuration: selectedDuration ?? this.selectedDuration,
    );
  }
}

/// 제출 중 상태
class RecordFormSubmitting extends RecordFormState {
  const RecordFormSubmitting();
}

/// 성공 상태
class RecordFormSuccess extends RecordFormState {
  final RecordEntity record;
  const RecordFormSuccess(this.record);
}

/// 에러 상태
class RecordFormError extends RecordFormState {
  final String message;
  const RecordFormError(this.message);
}
