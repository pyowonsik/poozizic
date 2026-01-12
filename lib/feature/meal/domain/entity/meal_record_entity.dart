/// 식사 기록 엔티티
class MealRecordEntity {
  final int? id;
  final int mealType; // 0: 아침, 1: 점심, 2: 저녁, 3: 간식
  final List<String> foods;
  final int fiberLevel; // 0: 많음, 1: 보통, 2: 적음
  final DateTime recordedAt;

  const MealRecordEntity({
    this.id,
    required this.mealType,
    required this.foods,
    required this.fiberLevel,
    required this.recordedAt,
  });

  String get mealTypeLabel {
    switch (mealType) {
      case 0:
        return '아침';
      case 1:
        return '점심';
      case 2:
        return '저녁';
      case 3:
        return '간식';
      default:
        return '알 수 없음';
    }
  }

  String get fiberLevelLabel {
    switch (fiberLevel) {
      case 0:
        return '많음';
      case 1:
        return '보통';
      case 2:
        return '적음';
      default:
        return '알 수 없음';
    }
  }

  MealRecordEntity copyWith({
    int? id,
    int? mealType,
    List<String>? foods,
    int? fiberLevel,
    DateTime? recordedAt,
  }) {
    return MealRecordEntity(
      id: id ?? this.id,
      mealType: mealType ?? this.mealType,
      foods: foods ?? this.foods,
      fiberLevel: fiberLevel ?? this.fiberLevel,
      recordedAt: recordedAt ?? this.recordedAt,
    );
  }
}
