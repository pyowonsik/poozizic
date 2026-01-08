import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

enum RecordType {
  bowel,
  meal,
  water,
  exercise,
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // 샘플 데이터: 각 날짜별 기록 타입들
  Map<DateTime, List<RecordType>> get _recordDays {
    final now = DateTime.now();
    return {
      DateTime(now.year, now.month, 1): [RecordType.bowel, RecordType.meal],
      DateTime(now.year, now.month, 2): [RecordType.bowel, RecordType.water, RecordType.exercise],
      DateTime(now.year, now.month, 4): [RecordType.bowel, RecordType.meal, RecordType.water],
      DateTime(now.year, now.month, 5): [RecordType.bowel],
      DateTime(now.year, now.month, 6): [RecordType.bowel, RecordType.exercise],
      DateTime(now.year, now.month, 7): [RecordType.meal, RecordType.water],
      DateTime(now.year, now.month, 8): [RecordType.bowel, RecordType.water, RecordType.exercise],
    };
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          '캘린더',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 캘린더
            Container(
              color: Colors.white,
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
                  setState(() {
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  // 오늘 날짜
                  todayDecoration: BoxDecoration(
                    color: const Color(0xFFFF6B35),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  todayTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  // 선택된 날짜
                  selectedDecoration: BoxDecoration(
                    color: const Color(0xFFFF6B35),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  selectedTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  // 기본 날짜 스타일
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
                    final hasRecords = _recordDays.containsKey(dateKey);
                    
                    if (hasRecords) {
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
                    return null;
                  },
                  todayBuilder: (context, day, focusedDay) {
                    final dateKey = _normalizeDate(day);
                    final hasRecords = _recordDays.containsKey(dateKey);
                    
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
                  },
                  selectedBuilder: (context, day, focusedDay) {
                    final dateKey = _normalizeDate(day);
                    final hasRecords = _recordDays.containsKey(dateKey);
                    
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

            // 통계 정보 - 더 간결하게
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCard('25', '이번 달', Colors.black),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.grey[200],
                  ),
                  _buildStatCard('90%', '정상 비율', const Color(0xFF27AE60)),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.grey[200],
                  ),
                  _buildStatCard('1.2일', '평균 간격', const Color(0xFFFF6B35)),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 선택된 날짜 정보
            if (_selectedDay != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('yyyy년 M월 d일 (E)', 'ko_KR')
                          .format(_selectedDay!),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildAllRecords(_selectedDay!),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color valueColor) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF666666),
          ),
        ),
      ],
    );
  }

  Color _getRecordTypeColor(RecordType type) {
    switch (type) {
      case RecordType.bowel:
        return const Color(0xFF90EE90);
      case RecordType.meal:
        return const Color(0xFFFFB347);
      case RecordType.water:
        return const Color(0xFF87CEEB);
      case RecordType.exercise:
        return const Color(0xFF9370DB);
    }
  }

  String _getRecordTypeName(RecordType type) {
    switch (type) {
      case RecordType.bowel:
        return '배변 기록';
      case RecordType.meal:
        return '식단 기록';
      case RecordType.water:
        return '물마심 기록';
      case RecordType.exercise:
        return '운동 기록';
    }
  }

  String _getRecordTypeEmoji(RecordType type) {
    switch (type) {
      case RecordType.bowel:
        return '💩';
      case RecordType.meal:
        return '🍽️';
      case RecordType.water:
        return '💧';
      case RecordType.exercise:
        return '🏃';
    }
  }

  Widget _buildAllRecords(DateTime day) {
    final dateKey = _normalizeDate(day);
    final records = _recordDays[dateKey];

    if (records == null || records.isEmpty) {
      return _buildNoRecordCard();
    }

    return Column(
      children: records.map((type) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildRecordCard(type),
        );
      }).toList(),
    );
  }

  Widget _buildRecordCard(RecordType type) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          const SizedBox(height: 8),
          _buildRecordRow('배변감', '시원함 😊'),
          const SizedBox(height: 8),
          _buildRecordRow('메모', '아침 식사 후 배변'),
        ],
      ),
    );
  }

  Widget _buildNoRecordCard() {
    return Container(
      padding: const EdgeInsets.all(32),
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