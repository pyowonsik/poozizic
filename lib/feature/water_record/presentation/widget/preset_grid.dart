import 'package:flutter/material.dart';
import '../provider/water_record_form_notifier.dart';

/// 프리셋 그리드 위젯
class PresetGrid extends StatelessWidget {
  final int? selectedPreset;
  final void Function(int index) onPresetSelected;

  const PresetGrid({
    super.key,
    required this.selectedPreset,
    required this.onPresetSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.4,
      children: List.generate(WaterRecordFormNotifier.presets.length, (index) {
        final preset = WaterRecordFormNotifier.presets[index];
        final isSelected = selectedPreset == index;

        return GestureDetector(
          onTap: () => onPresetSelected(index),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF2196F3).withValues(alpha: 0.1)
                  : Colors.white,
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF2196F3)
                    : const Color(0xFFE0E0E0),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  preset.emoji,
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(height: 6),
                Text(
                  preset.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? const Color(0xFF2196F3)
                        : const Color(0xFF000000),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${preset.amount}ml',
                  style: TextStyle(
                    fontSize: 11,
                    color: isSelected
                        ? const Color(0xFF2196F3)
                        : const Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
