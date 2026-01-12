import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poozizic/feature/record/domain/usecase/create_record_usecase.dart';
import 'package:poozizic/feature/record/presentation/provider/record_form_state.dart';

/// Record Form Notifier
class RecordFormNotifier extends StateNotifier<RecordFormState> {
  /// Record Form Notifier 생성자
  RecordFormNotifier(this._createRecordUseCase)
    : super(const RecordFormInProgress(currentStep: 0));

  /// 기록 생성 UseCase
  final CreateRecordUseCase _createRecordUseCase;

  /// Bristol Type 선택
  /// [type] 브리스톨 타입
  void selectBristolType(int type) {
    final current = state;
    if (current is RecordFormInProgress) {
      state = current.copyWith(selectedBristolType: type);
    }
  }

  /// Feeling 선택
  void selectFeeling(int feeling) {
    final current = state;
    if (current is RecordFormInProgress) {
      state = current.copyWith(selectedFeeling: feeling);
    }
  }

  /// Duration 설정
  void setDuration(int minutes) {
    final current = state;
    if (current is RecordFormInProgress) {
      state = current.copyWith(selectedDuration: minutes);
    }
  }

  /// 다음 단계로 이동
  void nextStep() {
    final current = state;
    if (current is RecordFormInProgress && current.currentStep < 2) {
      state = current.copyWith(currentStep: current.currentStep + 1);
    }
  }

  /// 이전 단계로 이동
  void previousStep() {
    final current = state;
    if (current is RecordFormInProgress && current.currentStep > 0) {
      state = current.copyWith(currentStep: current.currentStep - 1);
    }
  }

  /// 기록 제출
  Future<void> submitRecord() async {
    final current = state;
    if (current is! RecordFormInProgress) return;
    if (current.selectedBristolType == null ||
        current.selectedFeeling == null) {
      return;
    }

    state = const RecordFormSubmitting();

    final result = await _createRecordUseCase(
      CreateRecordParams(
        bristolType: current.selectedBristolType!,
        feeling: current.selectedFeeling!,
        durationMinutes: current.selectedDuration,
      ),
    );

    result.fold(
      (failure) => state = RecordFormError(failure.message),
      (record) => state = RecordFormSuccess(record),
    );
  }

  /// 상태 초기화
  void reset() {
    state = const RecordFormInProgress(currentStep: 0);
  }
}
