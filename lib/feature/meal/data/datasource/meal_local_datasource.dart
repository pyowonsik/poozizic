import '../../domain/entity/meal_record_entity.dart';

/// 식사 기록 로컬 데이터소스
class MealLocalDataSource {
  final List<MealRecordEntity> _records = [];
  int _nextId = 1;

  /// 새 식사 기록 생성
  Future<MealRecordEntity> createRecord(MealRecordEntity record) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newRecord = MealRecordEntity(
      id: _nextId++,
      mealType: record.mealType,
      foods: record.foods,
      fiberLevel: record.fiberLevel,
      recordedAt: record.recordedAt,
    );
    _records.add(newRecord);
    return newRecord;
  }

  /// 모든 식사 기록 조회
  Future<List<MealRecordEntity>> getAllRecords() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_records)
      ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
  }

  /// 특정 날짜의 식사 기록 조회
  Future<List<MealRecordEntity>> getRecordsByDate(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _records
        .where(
          (r) =>
              r.recordedAt.year == date.year &&
              r.recordedAt.month == date.month &&
              r.recordedAt.day == date.day,
        )
        .toList()
      ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
  }
}
