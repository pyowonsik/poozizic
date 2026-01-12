import 'package:poozizic/feature/record/domain/entity/record_entity.dart';

/// Record Form 상태
sealed class RecordFormState {
  const RecordFormState();
}

/// 초기 상태
class RecordFormInitial extends RecordFormState {
  /// 초기 상태 생성자
  const RecordFormInitial();
}

/// 진행 중 상태
class RecordFormInProgress extends RecordFormState {
  /// 진행 중 상태 생성자
  const RecordFormInProgress({
    required this.currentStep,
    this.selectedBristolType,
    this.selectedFeeling,
    this.selectedDuration = 10,
  });

  /// 0: Bristol, 1: Feeling, 2: Time
  final int currentStep;

  /// Bristol Scale 선택
  final int? selectedBristolType;

  /// Feeling 선택
  final int? selectedFeeling;

  /// Duration 설정
  final int selectedDuration;

  /// 기록 폼 진행 중 상태 복사
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
  /// 제출 중 상태 생성자
  const RecordFormSubmitting();
}

/// 성공 상태
class RecordFormSuccess extends RecordFormState {
  /// 성공 상태 생성자
  /// [record] 기록 엔티티
  const RecordFormSuccess(this.record);

  /// 기록 엔티티
  final RecordEntity record;
}

/// 에러 상태
class RecordFormError extends RecordFormState {
  /// 에러 상태 생성자
  /// [message] 에러 메시지
  const RecordFormError(this.message);

  /// 에러 메시지
  final String message;
}
