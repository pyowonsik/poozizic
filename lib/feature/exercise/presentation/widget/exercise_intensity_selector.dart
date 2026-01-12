import 'package:flutter/material.dart';

/// 운동 강도 선택 위젯
class ExerciseIntensitySelector extends StatelessWidget {
  const ExerciseIntensitySelector({
    super.key,
    required this.selectedIntensity,
    required this.onIntensitySelected,
  });

  final int? selectedIntensity;
  final ValueChanged<int> onIntensitySelected;

  static final List<Map<String, String>> _intensities = [
    {'emoji': '😌', 'label': '가볍게'},
    {'emoji': '💪', 'label': '보통'},
    {'emoji': '🔥', 'label': '격하게'},
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_intensities.length, (index) {
        final intensity = _intensities[index];
        final isSelected = selectedIntensity == index;

        return Expanded(
          child: GestureDetector(
            onTap: () => onIntensitySelected(index),
            child: Container(
              margin: EdgeInsets.only(
                right: index < _intensities.length - 1 ? 10 : 0,
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
                  Text(
                    intensity['emoji']!,
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    intensity['label']!,
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
