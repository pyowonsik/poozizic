import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../record/domain/entity/record_entity.dart';
import 'no_record_card.dart';
import 'record_detail_card.dart';

class RecordListCard extends StatelessWidget {
  const RecordListCard({
    super.key,
    required this.selectedDay,
    required this.records,
  });

  final DateTime selectedDay;
  final List<RecordEntity> records;

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
            const NoRecordCard()
          else
            ...records.map((record) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: RecordDetailCard(record: record),
                )),
        ],
      ),
    );
  }
}
