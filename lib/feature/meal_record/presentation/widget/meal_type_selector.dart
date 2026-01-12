import 'package:flutter/material.dart';
import 'package:poozizic/feature/meal_record/presentation/provider/meal_record_form_notifier.dart';

/// 식사 타입 선택 위젯
class MealTypeSelector extends StatelessWidget {
  /// 식사 타입 선택 위젯 생성자
  /// [selectedMealType] 선택된 식사 타입
  /// [onMealTypeSelected] 식사 타입 선택 콜백
  ///
  const MealTypeSelector({
    required this.selectedMealType,
    required this.onMealTypeSelected,
    super.key,
  });

  /// 선택된 식사 타입
  final int selectedMealType;

  /// 식사 타입 선택 콜백
  final void Function(int type) onMealTypeSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(MealRecordFormNotifier.mealTypes.length, (index) {
        final meal = MealRecordFormNotifier.mealTypes[index];
        final isSelected = selectedMealType == index;

        return Expanded(
          child: GestureDetector(
            onTap: () => onMealTypeSelected(index),
            child: Container(
              margin: EdgeInsets.only(
                right: index < MealRecordFormNotifier.mealTypes.length - 1
                    ? 12
                    : 0,
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
                  Text(meal.emoji, style: const TextStyle(fontSize: 24)),
                  const SizedBox(height: 4),
                  Text(
                    meal.label,
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
