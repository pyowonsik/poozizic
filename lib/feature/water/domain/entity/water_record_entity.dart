/// 수분 기록 엔티티
class WaterRecordEntity {
  final int? id;
  final int amount; // ml
  final DateTime recordedAt;

  const WaterRecordEntity({
    this.id,
    required this.amount,
    required this.recordedAt,
  });

  WaterRecordEntity copyWith({
    int? id,
    int? amount,
    DateTime? recordedAt,
  }) {
    return WaterRecordEntity(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      recordedAt: recordedAt ?? this.recordedAt,
    );
  }
}
