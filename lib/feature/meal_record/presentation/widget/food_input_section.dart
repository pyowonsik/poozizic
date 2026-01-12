import 'package:flutter/material.dart';

/// 음식 입력 섹션 위젯
class FoodInputSection extends StatefulWidget {
  final List<String> foods;
  final void Function(String food) onFoodAdded;
  final void Function(String food) onFoodRemoved;

  const FoodInputSection({
    super.key,
    required this.foods,
    required this.onFoodAdded,
    required this.onFoodRemoved,
  });

  @override
  State<FoodInputSection> createState() => _FoodInputSectionState();
}

class _FoodInputSectionState extends State<FoodInputSection> {
  final TextEditingController _foodController = TextEditingController();

  @override
  void dispose() {
    _foodController.dispose();
    super.dispose();
  }

  void _addFood() {
    final food = _foodController.text.trim();
    if (food.isNotEmpty) {
      widget.onFoodAdded(food);
      _foodController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _foodController,
                decoration: InputDecoration(
                  hintText: '음식 이름 입력',
                  hintStyle: const TextStyle(
                    color: Color(0xFFCCCCCC),
                    fontSize: 15,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                onSubmitted: (_) => _addFood(),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF5E35B1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: _addFood,
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (widget.foods.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.foods.map((food) {
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
                      onTap: () => widget.onFoodRemoved(food),
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
          ),
      ],
    );
  }
}
