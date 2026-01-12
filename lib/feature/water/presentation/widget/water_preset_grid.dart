import 'package:flutter/material.dart';

/// 수분 프리셋 그리드 위젯
class WaterPresetGrid extends StatelessWidget {
  const WaterPresetGrid({
    super.key,
    required this.selectedPreset,
    required this.onPresetSelected,
  });

  final int? selectedPreset;
  final Function(int index, int amount) onPresetSelected;

  static final List<Map<String, dynamic>> _presets = [
    {'emoji': '☕', 'label': '컵 1잔', 'amount': 200},
    {'emoji': '🥤', 'label': '머그컵', 'amount': 250},
    {'emoji': '🥫', 'label': '캔', 'amount': 355},
    {'emoji': '🧃', 'label': '물병', 'amount': 500},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.4,
      children: List.generate(_presets.length, (index) {
        final preset = _presets[index];
        final isSelected = selectedPreset == index;

        return GestureDetector(
          onTap: () => onPresetSelected(index, preset['amount'] as int),
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
                  preset['emoji'] as String,
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(height: 6),
                Text(
                  preset['label'] as String,
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
                  '${preset['amount']}ml',
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
