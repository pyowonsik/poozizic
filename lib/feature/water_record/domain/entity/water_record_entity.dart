/// 수분 기록 엔티티
class WaterRecordEntity {
  final int? id;
  final DateTime dateTime;
  final int amountMl;
  final String? presetType; // cup, mug, can, bottle
  final DateTime createdAt;

  const WaterRecordEntity({
    this.id,
    required this.dateTime,
    required this.amountMl,
    this.presetType,
    required this.createdAt,
  });

  /// 프리셋 타입에 따른 이름
  String get presetTypeName {
    switch (presetType) {
      case 'cup':
        return '컵 1잔';
      case 'mug':
        return '머그컵';
      case 'can':
        return '캔';
      case 'bottle':
        return '물병';
      default:
        return '직접 입력';
    }
  }

  WaterRecordEntity copyWith({
    int? id,
    DateTime? dateTime,
    int? amountMl,
    String? presetType,
    DateTime? createdAt,
  }) {
    return WaterRecordEntity(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      amountMl: amountMl ?? this.amountMl,
      presetType: presetType ?? this.presetType,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
