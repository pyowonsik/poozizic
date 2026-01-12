import 'dart:ui';

/// 기록 타입
enum RecordType {
  /// 배변 기록
  bowel,

  /// 식사 기록
  meal,

  /// 수분 기록
  water,

  /// 운동 기록
  exercise,
}

/// 최근 기록 엔티티
class RecentRecordEntity {
  /// 최근 기록 엔티티 생성자
  const RecentRecordEntity({
    required this.type,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.backgroundColor,
  });

  /// 기록 타입
  final RecordType type;

  /// 기록 이모지
  final String emoji;

  /// 기록 제목
  final String title;

  /// 기록 부제목
  final String subtitle;

  /// 기록 시간
  final String time;

  /// 기록 배경색
  final Color backgroundColor;
}
