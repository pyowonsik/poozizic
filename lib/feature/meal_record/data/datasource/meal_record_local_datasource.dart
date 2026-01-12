import 'dart:math';
import 'package:poozizic/feature/meal_record/domain/entity/meal_record_entity.dart';

/// MealRecord 로컬 데이터소스 (목업)
class MealRecordLocalDataSource {
  /// MealRecord Local Data Source 생성자
  MealRecordLocalDataSource() {
    _generateMockData();
  }
  final List<MealRecordEntity> _records = [];
  int _nextId = 1;

  /// 목업 데이터 생성 (최근 7일)
  void _generateMockData() {
    final random = Random();
    final now = DateTime.now();
    final sampleFoods = [
      ['밥', '김치찌개', '계란후라이'],
      ['비빔밥', '된장국'],
      ['불고기', '밥', '시금치나물'],
      ['떡볶이', '순대'],
      ['샐러드', '닭가슴살'],
      ['라면', '김밥'],
      ['돈까스', '밥', '샐러드'],
      ['치킨', '맥주'],
    ];

    for (var i = 0; i < 7; i++) {
      final date = now.subtract(Duration(days: i));
      // 하루에 2-4끼
      final mealCount = 2 + random.nextInt(3);

      final mealTypes = <int>[];
      while (mealTypes.length < mealCount) {
        final type = random.nextInt(4);
        if (!mealTypes.contains(type)) {
          mealTypes.add(type);
        }
      }
      mealTypes.sort();

      for (final mealType in mealTypes) {
        final hours = [8, 12, 18, 15][mealType];
        final foods = sampleFoods[random.nextInt(sampleFoods.length)];
        final fiberLevel = random.nextInt(3);

        _records.add(
          MealRecordEntity(
            id: _nextId++,
            dateTime: DateTime(
              date.year,
              date.month,
              date.day,
              hours,
              random.nextInt(60),
            ),
            mealType: mealType,
            foods: List.from(foods),
            fiberLevel: fiberLevel,
            createdAt: DateTime(
              date.year,
              date.month,
              date.day,
              hours,
              random.nextInt(60),
            ),
          ),
        );
      }
    }

    // 시간순 정렬
    _records.sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  /// 식사 기록 생성
  Future<MealRecordEntity> createRecord(MealRecordEntity record) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final newRecord = record.copyWith(id: _nextId++);
    _records.insert(0, newRecord);
    return newRecord;
  }

  /// 특정 날짜의 식사 기록 조회
  Future<List<MealRecordEntity>> getRecordsByDate(DateTime date) async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    return _records.where((record) {
      return record.dateTime.year == date.year &&
          record.dateTime.month == date.month &&
          record.dateTime.day == date.day;
    }).toList();
  }

  /// 특정 날짜의 식사 횟수
  Future<int> getDailyMealCount(DateTime date) async {
    final records = await getRecordsByDate(date);
    return records.length;
  }

  /// 전체 기록 조회
  Future<List<MealRecordEntity>> getAllRecords() async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    return List.from(_records);
  }
}
