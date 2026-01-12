import 'package:flutter/material.dart';

/// 캘린더 일반 날짜 셀 위젯
///
/// 기록이 있는 날짜를 마커와 함께 표시합니다.
class CalendarDayCell extends StatelessWidget {
  const CalendarDayCell({
    super.key,
    required this.day,
  });

  final DateTime day;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${day.day}',
              style: const TextStyle(
                color: Color(0xFF333333),
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: Color(0xFF4CAF50),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
