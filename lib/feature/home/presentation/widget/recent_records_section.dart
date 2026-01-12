import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poozizic/feature/home/domain/entity/recent_record_entity.dart';

/// 최근 기록 섹션 위젯
class RecentRecordsSection extends StatelessWidget {
  /// 최근 기록 섹션 위젯 생성자
  /// [selectedDate] 선택된 날짜
  /// [records] 최근 기록 엔티티 목록
  /// [onPreviousDay] 이전 날짜 탭 콜백
  /// [onNextDay] 다음 날짜 탭 콜백
  /// [onCalendarTap] 캘린더로 보기 탭 콜백
  const RecentRecordsSection({
    required this.selectedDate,
    required this.records,
    required this.onPreviousDay,
    required this.onNextDay,
    super.key,
    this.onCalendarTap,
  });

  /// 선택된 날짜
  final DateTime selectedDate;

  /// 최근 기록 엔티티 목록
  final List<RecentRecordEntity> records;

  /// 이전 날짜 탭 콜백
  final VoidCallback onPreviousDay;

  /// 다음 날짜 탭 콜백
  final VoidCallback onNextDay;

  /// 캘린더로 보기 탭 콜백
  final VoidCallback? onCalendarTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 헤더
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '최근 기록',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000000),
              ),
            ),
            TextButton(
              onPressed: onCalendarTap,
              child: Row(
                children: [
                  const Text(
                    '캘린더로 보기',
                    style: TextStyle(fontSize: 14, color: Color(0xFF999999)),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right, size: 18, color: Colors.grey[400]),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // 날짜 네비게이션
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
                onPressed: onPreviousDay,
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
                onPressed: onNextDay,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 기록 목록
        if (records.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                '이 날의 기록이 없습니다',
                style: TextStyle(fontSize: 14, color: Color(0xFF999999)),
              ),
            ),
          )
        else
          ...records.map(
            (record) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildRecordCard(record),
            ),
          ),

        // 팁 카드
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              Text('💡', style: TextStyle(fontSize: 24)),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '건강 팁',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF000000),
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.check, size: 16, color: Color(0xFF27AE60)),
                        SizedBox(width: 4),
                        Text(
                          '규칙적인 배변 패턴을 보이고 있습니다',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF1976D2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecordCard(RecentRecordEntity record) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: record.backgroundColor.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(record.emoji, style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF000000),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  record.subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
          Text(
            record.time,
            style: const TextStyle(fontSize: 13, color: Color(0xFF999999)),
          ),
        ],
      ),
    );
  }

  String _getDateText(DateTime date) {
    return DateFormat('M월 d일 (E)', 'ko_KR').format(date);
  }
}
