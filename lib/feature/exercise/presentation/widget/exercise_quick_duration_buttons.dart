import 'package:flutter/material.dart';

/// 빠른 시간 선택 버튼 위젯
class ExerciseQuickDurationButtons extends StatelessWidget {
  const ExerciseQuickDurationButtons({
    super.key,
    required this.onDurationSelected,
  });

  final ValueChanged<int> onDurationSelected;

  static final List<int> _quickDurations = [15, 30, 45, 60];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_quickDurations.length, (index) {
        final duration = _quickDurations[index];
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(
              right: index < _quickDurations.length - 1 ? 8 : 0,
            ),
            child: OutlinedButton(
              onPressed: () => onDurationSelected(duration),
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
                '$duration분',
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
