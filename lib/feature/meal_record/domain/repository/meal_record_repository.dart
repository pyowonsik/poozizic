import '../entity/meal_record_entity.dart';

/// MealRecord Repository 인터페이스
abstract class MealRecordRepository {
  /// 식사 기록 생성
  Future<MealRecordEntity> createRecord(MealRecordEntity record);

  /// 특정 날짜의 식사 기록 조회
  Future<List<MealRecordEntity>> getRecordsByDate(DateTime date);

  /// 특정 날짜의 식사 횟수 조회
  Future<int> getDailyMealCount(DateTime date);

  /// 전체 식사 기록 조회
  Future<List<MealRecordEntity>> getAllRecords();
}
