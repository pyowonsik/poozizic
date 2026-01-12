import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/water_providers.dart';
import '../provider/water_state.dart';
import '../widget/widget.dart';
import '../../../../shared/widget/pz_loading_view.dart';
import '../../../../shared/widget/pz_snackbar.dart';

/// 수분 기록 페이지 (Clean Architecture)
class WaterRecordPage extends ConsumerWidget {
  const WaterRecordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(waterNotifierProvider);
    final notifier = ref.read(waterNotifierProvider.notifier);

    // 성공 시 처리
    ref.listen<WaterState>(waterNotifierProvider, (previous, next) {
      if (next is WaterSuccess) {
        Navigator.pop(context);
        final amount = previous is WaterSubmitting ? previous.amount : 250;
        PzSnackBar.showSuccess(context, '${amount}ml가 기록되었습니다');
      } else if (next is WaterError) {
        PzSnackBar.showError(context, next.message);
      }
    });

    // 현재 양 가져오기
    int currentAmount;
    int? currentPreset;

    if (state is WaterInProgress) {
      currentAmount = state.amount;
      currentPreset = state.selectedPreset;
    } else if (state is WaterInitial) {
      currentAmount = state.amount;
      currentPreset = state.selectedPreset;
    } else if (state is WaterSubmitting) {
      currentAmount = state.amount;
      currentPreset = null;
    } else {
      currentAmount = 250;
      currentPreset = 1;
    }

    final isSubmitting = state is WaterSubmitting;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isSubmitting
          ? const PzLoadingView()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 헤더
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2196F3).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('💧', style: TextStyle(fontSize: 20)),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          '수분 기록',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF000000),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // 물방울 카드
                    WaterAmountCard(amount: currentAmount),

                    const SizedBox(height: 20),

                    // 슬라이더
                    WaterAmountSlider(
                      amount: currentAmount.toDouble(),
                      onChanged: (value) {
                        notifier.selectAmount(value.toInt());
                      },
                    ),

                    const SizedBox(height: 20),

                    // 빠른 선택
                    const Text(
                      '빠른 선택',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(height: 12),
                    WaterPresetGrid(
                      selectedPreset: currentPreset,
                      onPresetSelected: (index, amount) {
                        notifier.selectAmount(amount, preset: index);
                      },
                    ),

                    const SizedBox(height: 20),

                    // 빠른 양 선택 버튼
                    WaterQuickButtons(
                      onAmountSelected: (amount) {
                        notifier.selectAmount(amount);
                      },
                    ),

                    const SizedBox(height: 24),

                    // 기록 완료 버튼
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => notifier.submitRecord(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2196F3),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              '기록 완료',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }
}
