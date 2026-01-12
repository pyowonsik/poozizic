import 'package:flutter/material.dart';

/// 빠른 양 선택 버튼 위젯
class WaterQuickButtons extends StatelessWidget {
  const WaterQuickButtons({
    super.key,
    required this.onAmountSelected,
  });

  final ValueChanged<int> onAmountSelected;

  static final List<int> _quickAmounts = [100, 150, 300, 750];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_quickAmounts.length, (index) {
        final amount = _quickAmounts[index];
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(
              right: index < _quickAmounts.length - 1 ? 8 : 0,
            ),
            child: OutlinedButton(
              onPressed: () => onAmountSelected(amount),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                side: const BorderSide(
                  color: Color(0xFFE0E0E0),
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                '${amount}ml',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF666666),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
