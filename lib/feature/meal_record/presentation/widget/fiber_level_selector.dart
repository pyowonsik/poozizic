import 'package:flutter/material.dart';
import '../provider/meal_record_form_notifier.dart';

/// 식이섬유 레벨 선택 위젯
class FiberLevelSelector extends StatelessWidget {
  final int? selectedFiber;
  final void Function(int level) onFiberSelected;

  const FiberLevelSelector({
    super.key,
    required this.selectedFiber,
    required this.onFiberSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(MealRecordFormNotifier.fiberLevels.length, (index) {
        final fiber = MealRecordFormNotifier.fiberLevels[index];
        final isSelected = selectedFiber == index;

        return Expanded(
          child: GestureDetector(
            onTap: () => onFiberSelected(index),
            child: Container(
              margin: EdgeInsets.only(
                right: index < MealRecordFormNotifier.fiberLevels.length - 1 ? 12 : 0,
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
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
                    fiber.emoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    fiber.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
