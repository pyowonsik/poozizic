import 'package:flutter/material.dart';

/// 배변 기록 헤더 위젯
///
/// 페이지 상단의 타이틀과 아이콘을 표시합니다.
class RecordHeader extends StatelessWidget {
  const RecordHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF9C27B0).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.bathroom,
              color: Color(0xFF9C27B0),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            '배변 기록',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
        ],
      ),
    );
  }
}
