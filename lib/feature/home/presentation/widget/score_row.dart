import 'package:flutter/material.dart';

/// 점수 행 위젯
///
/// 건강 점수 상세에서 각 항목의 점수를 표시합니다.
class ScoreRow extends StatelessWidget {
  const ScoreRow({
    super.key,
    required this.label,
    required this.score,
  });

  final String label;
  final String score;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
        ),
        Text(
          score,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF000000),
          ),
        ),
      ],
    );
  }
}
