import 'package:flutter/material.dart';

/// 식이섬유 함량 선택 위젯
class FiberLevelSelector extends StatelessWidget {
  const FiberLevelSelector({
    super.key,
    required this.selectedFiber,
    required this.onFiberSelected,
  });

  final int? selectedFiber;
  final ValueChanged<int> onFiberSelected;

  static final List<Map<String, String>> _fiberLevels = [
    {'emoji': '🥬', 'label': '많음'},
    {'emoji': '🍽️', 'label': '보통'},
    {'emoji': '🥩', 'label': '적음'},
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_fiberLevels.length, (index) {
        final fiber = _fiberLevels[index];
        final isSelected = selectedFiber == index;

        return Expanded(
          child: GestureDetector(
            onTap: () => onFiberSelected(index),
            child: Container(
              margin: EdgeInsets.only(
                right: index < _fiberLevels.length - 1 ? 12 : 0,
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
                    fiber['emoji']!,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    fiber['label']!,
                    style: TextStyle(
                      fontSize: 14,
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
