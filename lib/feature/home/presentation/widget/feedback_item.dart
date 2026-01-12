import 'package:flutter/material.dart';

/// 피드백 아이템 위젯
///
/// 건강 점수 피드백 목록의 각 항목을 표시합니다.
class FeedbackItem extends StatelessWidget {
  const FeedbackItem({
    super.key,
    required this.text,
    required this.isPositive,
  });

  final String text;
  final bool isPositive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isPositive ? Icons.check : Icons.warning_amber_rounded,
            size: 16,
            color: isPositive
                ? const Color(0xFF27AE60)
                : const Color(0xFFF39C12),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: Color(0xFF666666)),
            ),
          ),
        ],
      ),
    );
  }
}
