/// 배변 기록 엔티티
class RecordEntity {
  final int? id;
  final DateTime dateTime;
  final int bristolType; // 1-7 (Bristol Scale)
  final int feeling; // 0: 시원함, 1: 보통, 2: 불편함, 3: 잔변감
  final int durationMinutes;
  final String? memo;
  final DateTime createdAt;

  const RecordEntity({
    this.id,
    required this.dateTime,
    required this.bristolType,
    required this.feeling,
    required this.durationMinutes,
    this.memo,
    required this.createdAt,
  });

  bool get isHealthy => bristolType >= 3 && bristolType <= 5;

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
