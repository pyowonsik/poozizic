import '../../domain/entity/water_record_entity.dart';

/// WaterRecord 폼 상태 (Sealed Class)
sealed class WaterRecordFormState {
  const WaterRecordFormState();
}

/// 입력 진행 중 상태
class WaterRecordFormInProgress extends WaterRecordFormState {
  final double waterAmount;
  final int? selectedPreset;

  const WaterRecordFormInProgress({
    this.waterAmount = 250,
    this.selectedPreset = 1, // 머그컵이 기본 선택
  });

  WaterRecordFormInProgress copyWith({
    double? waterAmount,
    int? selectedPreset,
    bool clearPreset = false,
  }) {
    return WaterRecordFormInProgress(
      waterAmount: waterAmount ?? this.waterAmount,
      selectedPreset: clearPreset ? null : (selectedPreset ?? this.selectedPreset),
    );
  }
}

/// 제출 중 상태
class WaterRecordFormSubmitting extends WaterRecordFormState {
  final double waterAmount;

  const WaterRecordFormSubmitting({required this.waterAmount});
}

/// 성공 상태
class WaterRecordFormSuccess extends WaterRecordFormState {
  final WaterRecordEntity record;

  const WaterRecordFormSuccess({required this.record});
}

/// 에러 상태
class WaterRecordFormError extends WaterRecordFormState {
  final String message;
  final double waterAmount;
  final int? selectedPreset;

  const WaterRecordFormError({
    required this.message,
    required this.waterAmount,
    this.selectedPreset,
  });
}
