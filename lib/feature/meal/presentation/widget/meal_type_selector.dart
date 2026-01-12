import 'package:flutter/material.dart';

/// 식사 구분 선택 위젯
class MealTypeSelector extends StatelessWidget {
  const MealTypeSelector({
    super.key,
    required this.selectedMealType,
    required this.onMealTypeSelected,
  });

  final int selectedMealType;
  final ValueChanged<int> onMealTypeSelected;

  static final List<Map<String, String>> _mealTypes = [
    {'emoji': '🌅', 'label': '아침'},
    {'emoji': '☀️', 'label': '점심'},
    {'emoji': '🌙', 'label': '저녁'},
    {'emoji': '🍪', 'label': '간식'},
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_mealTypes.length, (index) {
        final meal = _mealTypes[index];
        final isSelected = selectedMealType == index;

        return Expanded(
          child: GestureDetector(
            onTap: () => onMealTypeSelected(index),
            child: Container(
              margin: EdgeInsets.only(
                right: index < _mealTypes.length - 1 ? 12 : 0,
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF5E35B1).withValues(alpha: 0.1)
                    : Colors.white,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF5E35B1)
                      : const Color(0xFFE0E0E0),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    meal['emoji']!,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    meal['label']!,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected
                          ? const Color(0xFF5E35B1)
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
