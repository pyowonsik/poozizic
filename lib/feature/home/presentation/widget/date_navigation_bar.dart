import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 날짜 네비게이션 바 위젯
///
/// 날짜를 선택하고 이동할 수 있는 네비게이션 바를 표시합니다.
class DateNavigationBar extends StatelessWidget {
  const DateNavigationBar({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 12,
        ),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () {
                onDateChanged(selectedDate.subtract(const Duration(days: 1)));
              },
            ),
            Text(
              _getDateText(selectedDate),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF000000),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () {
                onDateChanged(selectedDate.add(const Duration(days: 1)));
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getDateText(DateTime date) {
    return DateFormat('M월 d일 (E)', 'ko_KR').format(date);
  }
}
