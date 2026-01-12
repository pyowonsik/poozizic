import 'package:flutter/material.dart';

/// 통계 행 위젯
///
/// 홈 화면의 통계 정보를 레이블과 값으로 표시합니다.
class StatRow extends StatelessWidget {
  const StatRow({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

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
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: valueColor ?? const Color(0xFF000000),
          ),
        ),
      ],
    );
  }
}
