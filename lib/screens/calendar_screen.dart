import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

enum RecordType {
  bowel, // 배변
  meal, // 식단
  water, // 물마심
  exercise, // 운동
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
  // DateTime 키는 시간 부분을 제거하여 날짜만 사용
  Map<DateTime, List<RecordType>> get _recordDays {
    final now = DateTime.now();
    return {
      DateTime(now.year, now.month, 1): [RecordType.bowel, RecordType.meal],
      DateTime(now.year, now.month, 2): [RecordType.bowel, RecordType.water, RecordType.exercise],
      DateTime(now.year, now.month, 4): [RecordType.bowel, RecordType.meal, RecordType.water],
      DateTime(now.year, now.month, 5): [RecordType.bowel],
      DateTime(now.year, now.month, 6): [RecordType.bowel, RecordType.exercise],
      DateTime(now.year, now.month, 7): [RecordType.meal, RecordType.water],
      DateTime(now.year, now.month, 8): [RecordType.water, RecordType.exercise],
    };
  }
  
  // DateTime을 날짜 키로 변환하는 헬퍼 함수
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
              locale: 'ko_KR',
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
                markersMaxCount: 4,
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
                final dateKey = _normalizeDate(day);
                final records = _recordDays[dateKey];
                if (records == null || records.isEmpty) return [];
                // 기록 개수만큼 마커 표시 (최대 4개)
                return records.take(4).toList();
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
                    _buildAllRecords(_selectedDay!),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getRecordTypeColor(RecordType type) {
    switch (type) {
      case RecordType.bowel:
        return const Color(0xFF90EE90); // 연두색
      case RecordType.meal:
        return const Color(0xFFFFB347); // 주황색
      case RecordType.water:
        return const Color(0xFF87CEEB); // 하늘색
      case RecordType.exercise:
        return const Color(0xFF9370DB); // 보라색
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
        return '🌭';
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
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildRecordCard(type),
        );
      }).toList(),
    );
  }

  Widget _buildRecordCard(RecordType type) {
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
                  color: _getRecordTypeColor(type).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    _getRecordTypeEmoji(type),
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getRecordTypeName(type),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getRecordTime(type),
                      style: const TextStyle(
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
          ..._buildRecordDetails(type),
        ],
      ),
    );
  }

  String _getRecordTime(RecordType type) {
    switch (type) {
      case RecordType.bowel:
        return '오전 8:30';
      case RecordType.meal:
        return '오후 12:30';
      case RecordType.water:
        return '오후 3:00';
      case RecordType.exercise:
        return '오후 6:00';
    }
  }

  List<Widget> _buildRecordDetails(RecordType type) {
    switch (type) {
      case RecordType.bowel:
        return [
          _buildRecordRow('Bristol Type', 'Type 4 - 부드럽고 매끈'),
          const SizedBox(height: 12),
          _buildRecordRow('배변감', '시원함 😊'),
          const SizedBox(height: 12),
          _buildRecordRow('메모', '아침 식사 후 배변'),
        ];
      case RecordType.meal:
        return [
          _buildRecordRow('식사 종류', '점심 식사'),
          const SizedBox(height: 12),
          _buildRecordRow('메뉴', '김치찌개, 밥, 계란후라이'),
          const SizedBox(height: 12),
          _buildRecordRow('메모', '맛있게 먹었어요'),
        ];
      case RecordType.water:
        return [
          _buildRecordRow('섭취량', '500ml'),
          const SizedBox(height: 12),
          _buildRecordRow('누적량', '1.5L / 2L'),
          const SizedBox(height: 12),
          _buildRecordRow('메모', '운동 후 수분 보충'),
        ];
      case RecordType.exercise:
        return [
          _buildRecordRow('운동 종류', '걷기'),
          const SizedBox(height: 12),
          _buildRecordRow('시간', '30분'),
          const SizedBox(height: 12),
          _buildRecordRow('거리', '3.5km'),
          const SizedBox(height: 12),
          _buildRecordRow('메모', '공원에서 산책'),
        ];
    }
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
