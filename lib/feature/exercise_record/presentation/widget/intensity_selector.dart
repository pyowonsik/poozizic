import 'package:flutter/material.dart';
import 'package:poozizic/feature/exercise_record/presentation/provider/exercise_record_form_notifier.dart';

/// 운동 강도 선택 위젯
class IntensitySelector extends StatelessWidget {
  /// 운동 강도 선택 위젯 생성자
  /// [selectedIntensity] 선택된 운동 강도
  /// [onIntensitySelected] 운동 강도 선택 콜백
  const IntensitySelector({
    required this.selectedIntensity,
    required this.onIntensitySelected,
    super.key,
  });

  /// 선택된 운동 강도
  final int? selectedIntensity;

  /// 운동 강도 선택 콜백
  final void Function(int index) onIntensitySelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(ExerciseRecordFormNotifier.intensities.length, (
        index,
      ) {
        final intensity = ExerciseRecordFormNotifier.intensities[index];
        final isSelected = selectedIntensity == index;

        return Expanded(
          child: GestureDetector(
            onTap: () => onIntensitySelected(index),
            child: Container(
              margin: EdgeInsets.only(
                right: index < ExerciseRecordFormNotifier.intensities.length - 1
                    ? 10
                    : 0,
              ),
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF4CAF50).withValues(alpha: 0.1)
                    : Colors.white,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFFE0E0E0),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(intensity.emoji, style: const TextStyle(fontSize: 28)),
                  const SizedBox(height: 6),
                  Text(
                    intensity.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
