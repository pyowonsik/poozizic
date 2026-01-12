/// 수분 기록 상태
sealed class WaterState {
  const WaterState();
}

/// 초기 상태
class WaterInitial extends WaterState {
  const WaterInitial({
    this.amount = 250,
    this.selectedPreset = 1,
  });

  final int amount;
  final int? selectedPreset;
}

/// 진행 중 상태
class WaterInProgress extends WaterState {
  const WaterInProgress({
    required this.amount,
    required this.selectedPreset,
  });

  final int amount;
  final int? selectedPreset;
}

/// 제출 중 상태
class WaterSubmitting extends WaterState {
  const WaterSubmitting({
    required this.amount,
  });

  final int amount;
}

/// 성공 상태
class WaterSuccess extends WaterState {
  const WaterSuccess();
}

/// 에러 상태
class WaterError extends WaterState {
  const WaterError({
    required this.message,
  });

  final String message;
}
