/// 식사 기록 엔티티
class MealRecordEntity {
  final int? id;
  final DateTime dateTime;
  final int mealType; // 0: 아침, 1: 점심, 2: 저녁, 3: 간식
  final List<String> foods;
  final int fiberLevel; // 0: 많음, 1: 보통, 2: 적음
  final DateTime createdAt;

  const MealRecordEntity({
    this.id,
    required this.dateTime,
    required this.mealType,
    required this.foods,
    required this.fiberLevel,
    required this.createdAt,
  });

  /// 식사 타입 이름
  String get mealTypeName {
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
        return '기타';
    }
  }

  /// 식사 타입 이모지
  String get mealTypeEmoji {
    switch (mealType) {
      case 0:
        return '🌅';
      case 1:
        return '☀️';
      case 2:
        return '🍌';
      case 3:
        return '🍪';
      default:
        return '🍽️';
    }
  }

  /// 식이섬유 레벨 이름
  String get fiberLevelName {
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
    DateTime? dateTime,
    int? mealType,
    List<String>? foods,
    int? fiberLevel,
    DateTime? createdAt,
  }) {
    return MealRecordEntity(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      mealType: mealType ?? this.mealType,
      foods: foods ?? this.foods,
      fiberLevel: fiberLevel ?? this.fiberLevel,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
