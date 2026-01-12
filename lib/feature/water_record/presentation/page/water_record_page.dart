import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poozizic/feature/analytics/di/analytics_providers.dart';
import 'package:poozizic/feature/home/di/home_providers.dart';
import 'package:poozizic/feature/water_record/di/water_record_providers.dart';
import 'package:poozizic/feature/water_record/presentation/provider/water_record_form_notifier.dart';
import 'package:poozizic/feature/water_record/presentation/provider/water_record_form_state.dart';
import 'package:poozizic/feature/water_record/presentation/widget/preset_grid.dart';
import 'package:poozizic/feature/water_record/presentation/widget/water_amount_card.dart';

/// 수분 기록 페이지
class WaterRecordPage extends ConsumerStatefulWidget {
  /// 수분 기록 페이지 생성자
  /// [key] 키
  const WaterRecordPage({super.key});

  @override
  ConsumerState<WaterRecordPage> createState() => _WaterRecordPageState();
}

class _WaterRecordPageState extends ConsumerState<WaterRecordPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(waterRecordFormNotifierProvider);
    final notifier = ref.read(waterRecordFormNotifierProvider.notifier);

    // 성공 시 화면 닫기
    ref.listen<WaterRecordFormState>(waterRecordFormNotifierProvider, (
      previous,
      next,
    ) {
      if (next is WaterRecordFormSuccess) {
        // Home, Analytics 화면 갱신
        refreshHome(ref);
        refreshAnalytics(ref);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${next.record.amountMl}ml가 기록되었습니다'),
            backgroundColor: const Color(0xFF4CAF50),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
          ),
        );
      } else if (next is WaterRecordFormError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        notifier.clearError();
      }
    });

    // 현재 수분량과 선택된 프리셋 추출
    double waterAmount = 250;
    int? selectedPreset = 1;
    var isSubmitting = false;

    if (state is WaterRecordFormInProgress) {
      waterAmount = state.waterAmount;
      selectedPreset = state.selectedPreset;
    } else if (state is WaterRecordFormSubmitting) {
      waterAmount = state.waterAmount;
      isSubmitting = true;
    } else if (state is WaterRecordFormError) {
      waterAmount = state.waterAmount;
      selectedPreset = state.selectedPreset;
    }

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
      body: SingleChildScrollView(
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
              WaterAmountCard(waterAmount: waterAmount),

              const SizedBox(height: 20),

              // 슬라이더
              _buildSlider(waterAmount, notifier),

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

              // 프리셋 그리드
              PresetGrid(
                selectedPreset: selectedPreset,
                onPresetSelected: notifier.selectPreset,
              ),

              const SizedBox(height: 20),

              // 빠른 양 선택 버튼
              _buildQuickAmountButtons(notifier),

              const SizedBox(height: 24),

              // 기록 완료 버튼
              _buildSubmitButton(waterAmount, isSubmitting, notifier),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlider(double waterAmount, WaterRecordFormNotifier notifier) {
    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: const Color(0xFF2196F3),
            inactiveTrackColor: const Color(0xFFB3E5FC),
            thumbColor: const Color(0xFF2196F3),
            overlayColor: const Color(0xFF2196F3).withValues(alpha: 0.2),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            trackHeight: 6,
          ),
          child: Slider(
            value: waterAmount,
            min: 50,
            max: 1000,
            divisions: 95,
            onChanged: notifier.setAmount,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '50ml',
                style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
              ),
              Text(
                '1000ml',
                style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAmountButtons(WaterRecordFormNotifier notifier) {
    return Row(
      children: List.generate(WaterRecordFormNotifier.quickAmounts.length, (
        index,
      ) {
        final amount = WaterRecordFormNotifier.quickAmounts[index];
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(
              right: index < WaterRecordFormNotifier.quickAmounts.length - 1
                  ? 8
                  : 0,
            ),
            child: OutlinedButton(
              onPressed: () => notifier.selectQuickAmount(amount),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                side: const BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                '${amount}ml',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF666666),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSubmitButton(
    double waterAmount,
    bool isSubmitting,
    WaterRecordFormNotifier notifier,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isSubmitting ? null : notifier.submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2196F3),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: isSubmitting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Row(
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
    );
  }
}
