import '../entity/meal_record_entity.dart';

/// Meal Repository 인터페이스
abstract class MealRepository {
  /// 새 식사 기록 생성
  Future<MealRecordEntity> createRecord(MealRecordEntity record);

  /// 모든 식사 기록 조회
  Future<List<MealRecordEntity>> getAllRecords();

  /// 특정 날짜의 식사 기록 조회
  Future<List<MealRecordEntity>> getRecordsByDate(DateTime date);
}
