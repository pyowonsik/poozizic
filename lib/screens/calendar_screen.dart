import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // 샘플 데이터: 배변 기록이 있는 날짜들
  final Map<DateTime, bool> _recordDays = {
    DateTime(2026, 1, 1): true,
    DateTime(2026, 1, 2): true,
    DateTime(2026, 1, 4): true,
    DateTime(2026, 1, 5): true,
    DateTime(2026, 1, 6): true,
  };

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '캘린더',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF654321),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 캘린더
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                }
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              // 스타일
              calendarStyle: CalendarStyle(
                // 오늘 날짜
                todayDecoration: BoxDecoration(
                  color: const Color(0xFF8B4513).withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                // 선택된 날짜
                selectedDecoration: const BoxDecoration(
                  color: Color(0xFF8B4513),
                  shape: BoxShape.circle,
                ),
                // 기록이 있는 날짜
                markerDecoration: const BoxDecoration(
                  color: Color(0xFF90EE90),
                  shape: BoxShape.circle,
                ),
                markersMaxCount: 1,
                markerSize: 6,
                markerMargin: const EdgeInsets.only(bottom: 4),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF654321),
                ),
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: Colors.brown[700],
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: Colors.brown[700],
                ),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
                weekendStyle: TextStyle(
                  color: Colors.red[300],
                  fontWeight: FontWeight.w600,
                ),
              ),
              // 이벤트 마커
              eventLoader: (day) {
                final dateKey = DateTime(day.year, day.month, day.day);
                return _recordDays[dateKey] == true ? [true] : [];
              },
            ),
          ),

          const SizedBox(height: 20),

          // 선택된 날짜 정보
          if (_selectedDay != null)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('yyyy년 M월 d일 (E)', 'ko_KR')
                          .format(_selectedDay!),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF654321),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _hasRecord(_selectedDay!)
                        ? _buildRecordCard()
                        : _buildNoRecordCard(),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  bool _hasRecord(DateTime day) {
    final dateKey = DateTime(day.year, day.month, day.day);
    return _recordDays[dateKey] == true;
  }

  Widget _buildRecordCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF90EE90).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    '🌭',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '배변 기록',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '오전 8:30',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          _buildRecordRow('Bristol Type', 'Type 4 - 부드럽고 매끈'),
          const SizedBox(height: 12),
          _buildRecordRow('배변감', '시원함 😊'),
          const SizedBox(height: 12),
          _buildRecordRow('메모', '아침 식사 후 배변'),
        ],
      ),
    );
  }

  Widget _buildNoRecordCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
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

  Widget _buildRecordRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF333333),
            ),
          ),
        ),
      ],
    );
  }
}
