import 'package:flutter/material.dart';

/// 최근 기록 헤더 위젯
///
/// 최근 기록 섹션의 헤더를 표시합니다.
class RecentRecordsHeader extends StatelessWidget {
  const RecentRecordsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '최근 기록',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Row(
              children: [
                const Text(
                  '캘린더로 보기',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF999999),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
