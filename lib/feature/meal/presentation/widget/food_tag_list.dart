import 'package:flutter/material.dart';

/// 음식 태그 리스트 위젯
class FoodTagList extends StatelessWidget {
  const FoodTagList({
    super.key,
    required this.foods,
    required this.onRemove,
  });

  final List<String> foods;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    if (foods.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: foods.map((food) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF5E35B1).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                food,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF5E35B1),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => onRemove(food),
                child: const Icon(
                  Icons.close,
                  size: 16,
                  color: Color(0xFF5E35B1),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
