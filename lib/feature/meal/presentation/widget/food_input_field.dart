import 'package:flutter/material.dart';

/// 음식 입력 필드 위젯
class FoodInputField extends StatelessWidget {
  const FoodInputField({
    super.key,
    required this.controller,
    required this.onSubmitted,
    required this.onAddPressed,
  });

  final TextEditingController controller;
  final VoidCallback onSubmitted;
  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
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
            onSubmitted: (_) => onSubmitted(),
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
            onPressed: onAddPressed,
            icon: const Icon(
              Icons.add,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}
