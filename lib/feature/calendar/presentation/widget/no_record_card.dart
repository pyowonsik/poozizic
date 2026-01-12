import 'package:flutter/material.dart';

/// 기록 없음 카드 위젯
///
/// 선택한 날짜에 기록이 없을 때 표시되는 카드입니다.
class NoRecordCard extends StatelessWidget {
  const NoRecordCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(
        child: Column(
          children: [
            Icon(
              Icons.event_note,
              size: 48,
              color: Color(0xFF999999),
            ),
            SizedBox(height: 12),
            Text(
              '기록이 없습니다',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF666666),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
