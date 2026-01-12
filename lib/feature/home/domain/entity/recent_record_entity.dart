import 'dart:ui';

/// 기록 타입
enum RecordType { bowel, meal, water, exercise }

/// 최근 기록 엔티티
class RecentRecordEntity {
  final RecordType type;
  final String emoji;
  final String title;
  final String subtitle;
  final String time;
  final Color backgroundColor;

  const RecentRecordEntity({
    required this.type,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.backgroundColor,
  });
}
