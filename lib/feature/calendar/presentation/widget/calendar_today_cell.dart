import 'package:flutter/material.dart';

/// 캘린더 오늘/선택된 날짜 셀 위젯
///
/// 오늘 또는 사용자가 선택한 날짜를 강조 표시합니다.
class CalendarTodayCell extends StatelessWidget {
  const CalendarTodayCell({
    super.key,
    required this.day,
    required this.hasRecords,
  });

  final DateTime day;
  final bool hasRecords;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFFF6B35),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${day.day}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (hasRecords) ...[
              const SizedBox(height: 4),
              Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
