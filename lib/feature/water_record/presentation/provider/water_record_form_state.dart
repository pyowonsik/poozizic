import 'package:poozizic/feature/water_record/domain/entity/water_record_entity.dart';

/// WaterRecord 폼 상태 (Sealed Class)
sealed class WaterRecordFormState {
  const WaterRecordFormState();
}

/// 입력 진행 중 상태
class WaterRecordFormInProgress extends WaterRecordFormState {
  /// WaterRecordFormInProgress 생성자
  /// [waterAmount] 수분량
  /// [selectedPreset] 선택된 프리셋
  const WaterRecordFormInProgress({
    this.waterAmount = 250,
    this.selectedPreset = 1,
  });

  /// 수분량
  final double waterAmount;

  /// 선택된 프리셋
  final int? selectedPreset;

  /// WaterRecordFormInProgress 복사
  /// [waterAmount] 수분량
  /// [selectedPreset] 선택된 프리셋
  /// [clearPreset] 프리셋 초기화 여부
  WaterRecordFormInProgress copyWith({
    double? waterAmount,
    int? selectedPreset,
    bool clearPreset = false,
  }) {
    return WaterRecordFormInProgress(
      waterAmount: waterAmount ?? this.waterAmount,
      selectedPreset: clearPreset
          ? null
          : (selectedPreset ?? this.selectedPreset),
    );
  }
}

/// 제출 중 상태
class WaterRecordFormSubmitting extends WaterRecordFormState {
  /// WaterRecordFormSubmitting 생성자
  /// [waterAmount] 수분량
  const WaterRecordFormSubmitting({required this.waterAmount});

  /// 수분량
  final double waterAmount;
}

/// 성공 상태
class WaterRecordFormSuccess extends WaterRecordFormState {
  /// WaterRecordFormSuccess 생성자
  /// [record] 수분 기록 엔티티
  const WaterRecordFormSuccess({required this.record});

  /// 수분 기록 엔티티
  final WaterRecordEntity record;
}

/// 에러 상태
class WaterRecordFormError extends WaterRecordFormState {
  /// WaterRecordFormError 생성자
  /// [message] 에러 메시지
  /// [waterAmount] 수분량
  /// [selectedPreset] 선택된 프리셋
  const WaterRecordFormError({
    required this.message,
    required this.waterAmount,
    this.selectedPreset,
  });

  /// 에러 메시지
  final String message;

  /// 수분량
  final double waterAmount;

  /// 선택된 프리셋
  final int? selectedPreset;
}
