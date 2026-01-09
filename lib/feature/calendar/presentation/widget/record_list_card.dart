import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../record/domain/entity/record_entity.dart';

class RecordListCard extends StatelessWidget {
  const RecordListCard({
    super.key,
    required this.selectedDay,
    required this.records,
  });

  final DateTime selectedDay;
  final List<RecordEntity> records;

  static const List<String> bristolTypeDescriptions = [
    'Type 1 - 딱딱한 덩어리',
    'Type 2 - 울퉁불퉁한 소시지',
    'Type 3 - 금 간 소시지',
    'Type 4 - 부드러운 소시지',
    'Type 5 - 부드러운 조각',
    'Type 6 - 흐트러진 조각',
    'Type 7 - 액체 상태',
  ];

  static const List<Map<String, String>> feelings = [
    {'emoji': '😊', 'label': '시원함'},
    {'emoji': '😐', 'label': '보통'},
    {'emoji': '😣', 'label': '불편함'},
    {'emoji': '😰', 'label': '잔변감'},
  ];

  String _getBristolDescription(int type) {
    if (type >= 0 && type < bristolTypeDescriptions.length) {
      return bristolTypeDescriptions[type];
    }
    return 'Unknown';
  }

  String _getFeelingText(int feeling) {
    if (feeling >= 0 && feeling < feelings.length) {
      return '${feelings[feeling]['label']} ${feelings[feeling]['emoji']}';
    }
    return 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('yyyy년 M월 d일 (E)', 'ko_KR').format(selectedDay),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 16),
          if (records.isEmpty)
            _buildNoRecordCard()
          else
            ...records.map((record) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildRecordCard(record),
                )),
        ],
      ),
    );
  }

  Widget _buildRecordCard(RecordEntity record) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF90EE90).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    '💩',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '배변 기록',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('a h:mm', 'ko_KR').format(record.dateTime),
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
          _buildRecordRow('Bristol Type', _getBristolDescription(record.bristolType)),
          const SizedBox(height: 8),
          _buildRecordRow('배변감', _getFeelingText(record.feeling)),
          const SizedBox(height: 8),
          _buildRecordRow('소요 시간', '${record.durationMinutes}분'),
          if (record.memo != null && record.memo!.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildRecordRow('메모', record.memo!),
          ],
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
