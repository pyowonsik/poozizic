import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecase/create_water_record_usecase.dart';
import 'water_record_form_state.dart';

/// 프리셋 정보
class WaterPreset {
  final String emoji;
  final String label;
  final int amount;
  final String type;

  const WaterPreset({
    required this.emoji,
    required this.label,
    required this.amount,
    required this.type,
  });
}

/// WaterRecord 폼 Notifier
class WaterRecordFormNotifier extends StateNotifier<WaterRecordFormState> {
  final CreateWaterRecordUseCase _createWaterRecordUseCase;

  WaterRecordFormNotifier(this._createWaterRecordUseCase)
      : super(const WaterRecordFormInProgress());

  /// 프리셋 목록
  static const List<WaterPreset> presets = [
    WaterPreset(emoji: '☕', label: '컵 1잔', amount: 200, type: 'cup'),
    WaterPreset(emoji: '🥤', label: '머그컵', amount: 250, type: 'mug'),
    WaterPreset(emoji: '🥫', label: '캔', amount: 355, type: 'can'),
    WaterPreset(emoji: '🧃', label: '물병', amount: 500, type: 'bottle'),
  ];

  /// 빠른 선택 양 목록
  static const List<int> quickAmounts = [100, 150, 300, 750];

  /// 수분량 설정 (슬라이더)
  void setAmount(double amount) {
    final currentState = state;
    if (currentState is WaterRecordFormInProgress) {
      state = currentState.copyWith(
        waterAmount: amount,
        clearPreset: true,
      );
    }
  }

  /// 프리셋 선택
  void selectPreset(int index) {
    final currentState = state;
    if (currentState is WaterRecordFormInProgress) {
      state = currentState.copyWith(
        selectedPreset: index,
        waterAmount: presets[index].amount.toDouble(),
      );
    }
  }

  /// 빠른 양 선택
  void selectQuickAmount(int amount) {
    final currentState = state;
    if (currentState is WaterRecordFormInProgress) {
      state = currentState.copyWith(
        waterAmount: amount.toDouble(),
        clearPreset: true,
      );
    }
  }

  /// 제출
  Future<void> submit() async {
    final currentState = state;
    if (currentState is! WaterRecordFormInProgress) return;

    state = WaterRecordFormSubmitting(waterAmount: currentState.waterAmount);

    String? presetType;
    if (currentState.selectedPreset != null) {
      presetType = presets[currentState.selectedPreset!].type;
    }

    final result = await _createWaterRecordUseCase(CreateWaterRecordParams(
      amountMl: currentState.waterAmount.toInt(),
      presetType: presetType,
    ));

    result.fold(
      (failure) {
        state = WaterRecordFormError(
          message: failure.message,
          waterAmount: currentState.waterAmount,
          selectedPreset: currentState.selectedPreset,
        );
      },
      (record) {
        state = WaterRecordFormSuccess(record: record);
      },
    );
  }

  /// 에러에서 복구
  void clearError() {
    final currentState = state;
    if (currentState is WaterRecordFormError) {
      state = WaterRecordFormInProgress(
        waterAmount: currentState.waterAmount,
        selectedPreset: currentState.selectedPreset,
      );
    }
  }
}
