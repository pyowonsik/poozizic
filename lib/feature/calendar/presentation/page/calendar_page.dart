import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../../di/calendar_providers.dart';
import '../provider/calendar_state.dart';
import '../widget/widget.dart';
import '../../../../shared/widget/pz_loading_view.dart';
import '../../../../shared/widget/pz_error_view.dart';

/// 캘린더 페이지 (Clean Architecture)
class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(calendarNotifierProvider);
    final notifier = ref.read(calendarNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          '캘린더',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: switch (state) {
        CalendarInitial() => const PzLoadingView(),
        CalendarLoading() => const PzLoadingView(),
        CalendarError(:final message) => PzErrorView(
          message: message,
          onRetry: () => notifier.refresh(),
        ),
        CalendarLoaded(
          :final focusedMonth,
          :final selectedDay,
          :final recordDays,
          :final selectedDayRecords,
          :final statistics,
        ) =>
          SingleChildScrollView(
            child: Column(
              children: [
                // 캘린더
                Container(
                  color: Colors.white,
                  child: TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: focusedMonth,
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) {
                      return selectedDay != null && isSameDay(selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      notifier.selectDay(selectedDay);
                    },
                    onFormatChanged: (format) {
                      if (_calendarFormat != format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
                    },
                    onPageChanged: (focusedDay) {
                      notifier.changeMonth(focusedDay);
                    },
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: const Color(0xFFFF6B35),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      todayTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: const Color(0xFFFF6B35),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      selectedTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      defaultTextStyle: const TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 15,
                      ),
                      weekendTextStyle: const TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 15,
                      ),
                      outsideTextStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 15,
                      ),
                      cellMargin: const EdgeInsets.all(4),
                      cellPadding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) {
                        final dateKey = _normalizeDate(day);
                        final hasRecords = recordDays.containsKey(dateKey);

                        if (hasRecords) {
                          return CalendarDayCell(day: day);
                        }
                        return null;
                      },
                      todayBuilder: (context, day, focusedDay) {
                        final dateKey = _normalizeDate(day);
                        final hasRecords = recordDays.containsKey(dateKey);
                        return CalendarTodayCell(
                          day: day,
                          hasRecords: hasRecords,
                        );
                      },
                      selectedBuilder: (context, day, focusedDay) {
                        final dateKey = _normalizeDate(day);
                        final hasRecords = recordDays.containsKey(dateKey);
                        return CalendarTodayCell(
                          day: day,
                          hasRecords: hasRecords,
                        );
                      },
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextFormatter: (date, locale) {
                        return DateFormat('yyyy년 M월', locale).format(date);
                      },
                      titleTextStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000000),
                      ),
                      leftChevronIcon: const Icon(
                        Icons.chevron_left,
                        color: Color(0xFF000000),
                        size: 28,
                      ),
                      rightChevronIcon: const Icon(
                        Icons.chevron_right,
                        color: Color(0xFF000000),
                        size: 28,
                      ),
                      headerPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      weekendStyle: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    daysOfWeekHeight: 40,
                    rowHeight: 64,
                  ),
                ),

                const SizedBox(height: 16),

                // 통계 카드
                StatisticsCard(statistics: statistics),

                const SizedBox(height: 16),

                // 선택된 날짜의 기록 목록
                if (selectedDay != null)
                  RecordListCard(
                    selectedDay: selectedDay,
                    records: selectedDayRecords,
                  ),
              ],
            ),
          ),
      },
    );
  }
}
