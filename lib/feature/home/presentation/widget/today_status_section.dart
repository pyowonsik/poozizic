import 'package:flutter/material.dart';
import 'stat_row.dart';

/// 오늘의 상태 섹션 위젯
///
/// 홈 화면의 "오늘의 상태" 섹션을 표시합니다.
class TodayStatusSection extends StatelessWidget {
  const TodayStatusSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '오늘의 상태',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Column(
              children: [
                StatRow(
                  label: '마지막 배변',
                  value: '2시간 전',
                  valueColor: Color(0xFF27AE60),
                ),
                SizedBox(height: 16),
                StatRow(label: '연속 기록', value: '7일째 🔥'),
                SizedBox(height: 16),
                StatRow(label: '이번 주 배변', value: '5회'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
