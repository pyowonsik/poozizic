/// 수분 기록 엔티티
class WaterRecordEntity {
  /// 수분 기록 엔티티 생성자
  /// [id] 수분 기록 ID
  /// [dateTime] 수분 기록 날짜
  /// [amountMl] 수분 기록 양
  /// [presetType] 수분 기록 프리셋 타입
  /// [createdAt] 수분 기록 생성 시간
  const WaterRecordEntity({
    required this.dateTime,
    required this.amountMl,
    required this.createdAt,
    this.id,
    this.presetType,
  });

  /// 수분 기록 ID
  final int? id;

  /// 수분 기록 날짜
  final DateTime dateTime;

  /// 수분 기록 양
  final int amountMl;

  /// 수분 기록 프리셋 타입
  final String? presetType; // cup, mug, can, bottle

  /// 수분 기록 생성 시간
  final DateTime createdAt;

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

  /// 수분 기록 엔티티 복사
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
