import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecase/create_water_record_usecase.dart';
import 'water_state.dart';

/// 수분 기록 Notifier
class WaterNotifier extends StateNotifier<WaterState> {
  WaterNotifier(this._createWaterRecordUseCase)
      : super(const WaterInitial());

  final CreateWaterRecordUseCase _createWaterRecordUseCase;

  /// 양 선택 (슬라이더나 빠른 선택)
  void selectAmount(int amount, {int? preset}) {
    state = WaterInProgress(
      amount: amount,
      selectedPreset: preset,
    );
  }

  /// 기록 제출
  Future<void> submitRecord() async {
    final currentState = state;
    int amount;

    if (currentState is WaterInProgress) {
      amount = currentState.amount;
    } else if (currentState is WaterInitial) {
      amount = currentState.amount;
    } else {
      return;
    }

    state = WaterSubmitting(amount: amount);

    final result = await _createWaterRecordUseCase(
      CreateWaterRecordParams(amount: amount),
    );

    result.fold(
      (failure) => state = WaterError(message: failure.message),
      (_) => state = const WaterSuccess(),
    );
  }
}
