/// 배변 기록 엔티티
class RecordEntity {
  /// 배변 기록 엔티티 생성자
  const RecordEntity({
    required this.dateTime,
    required this.bristolType,
    required this.feeling,
    required this.durationMinutes,
    required this.createdAt,
    this.id,
    this.memo,
  });

  /// 배변 기록 ID
  final int? id;

  /// 배변 기록 날짜
  final DateTime dateTime;

  /// 배변 기록 Bristol Scale
  final int bristolType; // 1-7 (Bristol Scale)
  /// 배변 기록 기분
  final int feeling; // 0: 시원함, 1: 보통, 2: 불편함, 3: 잔변감
  /// 배변 기록 시간
  final int durationMinutes;

  /// 배변 기록 메모
  final String? memo;

  /// 배변 기록 생성 시간
  final DateTime createdAt;

  /// 배변 기록 건강 여부
  bool get isHealthy => bristolType >= 3 && bristolType <= 5;

  /// 배변 기록 복사
  RecordEntity copyWith({
    int? id,
    DateTime? dateTime,
    int? bristolType,
    int? feeling,
    int? durationMinutes,
    String? memo,
    DateTime? createdAt,
  }) {
    return RecordEntity(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      bristolType: bristolType ?? this.bristolType,
      feeling: feeling ?? this.feeling,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      memo: memo ?? this.memo,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
